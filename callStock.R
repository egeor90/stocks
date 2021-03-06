callStock <- function(wdTicker){
  require(data.table)
  require(dplyr)
  load(".../allData.RData")
  source(".../stockFunction.R")

  goog <- as.data.frame(fread(paste0(".../",wdTicker,"_1min.csv"), stringsAsFactors = F))
  #goog <- goog[1:(nrow(goog)-10),]
  goog$date <- as.POSIXct(goog$date, format = "%Y-%m-%d %H:%M:%S", tz = "UTC")

  ticker <- stock(wdTicker)
  colnames(ticker)[2] <- "close"

  goog <- dplyr::union(goog,ticker)
  goog <- goog %>% arrange(date)
  goog <- goog[!duplicated(goog),]
}
