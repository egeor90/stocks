callStock <- function(wdTicker){
  require(data.table)
  require(dplyr)
  load("/home/ege/Project/Stocks/allData.RData")
  source("/home/ege/Project/Stocks/stockFunction.R")

  goog <- as.data.frame(fread(paste0("/home/ege/Project/Stocks/",wdTicker,"_1min.csv"), stringsAsFactors = F))
  #goog <- goog[1:(nrow(goog)-10),]
  goog$date <- as.POSIXct(goog$date, format = "%Y-%m-%d %H:%M:%S", tz = "UTC")

  ticker <- stock(wdTicker)
  colnames(ticker)[2] <- "close"

  goog <- dplyr::union(goog,ticker)
  goog <- goog %>% arrange(date)
  goog <- goog[!duplicated(goog),]
}
