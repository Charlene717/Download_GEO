# 首先，需要安裝並載入必要的套件
if (!requireNamespace("BiocManager", quietly = TRUE))
  install.packages("BiocManager")

BiocManager::install("GEOquery")

library(GEOquery)

# GSE編號列表
gse_ids <- c("GSE84133", "GSE118767", "GSE103239", "GSE120575", "GSE108989",
             "E-MTAB-5061", "GSE81608", "GSE111664", "GSE96583")

# 下載資料並整理成表格的函數
get_geo_data <- function(gse_id) {
  gse <- getGEO(gse_id, GSEMatrix =TRUE, AnnotGPL=TRUE)

  if (length(gse) > 1) {
    idx <- grep("GPL96", attr(gse, "names")) # 選擇你需要的平台，這裡以 GPL96 為例
    gse <- gse[[idx]]
  } else {
    gse <- gse[[1]]
  }

  # 將資料整理成表格的格式
  eset <- gse@assayData$exprs
  pData <- pData(gse)
  fData <- fData(gse)

  return(list(eset = eset, pData = pData, fData = fData))
}

# 使用 lapply 下載並整理所有的 GSE 資料
geo_data <- lapply(gse_ids, get_geo_data)

# 將資料儲存到指定的資料夾
dir.create("scRNA-seq/10X_PBMC", showWarnings = FALSE)
for (i in seq_along(gse_ids)) {
  saveRDS(geo_data[[i]], file = paste0("scRNA-seq/10X_PBMC/", gse_ids[i], ".rds"))
}
