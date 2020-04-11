stockCombine <- function(ticker_name){
  source("stockFunction.R")
  a1 <- read.csv(paste0("/home/ege/Project/Stocks/",ticker_name,"_1min2.csv"), stringsAsFactors = F)
  a1$date <- as.POSIXct(a1$date, tz = "UTC")
  ticker <- stock(ticker_name)
  ticker <- xts(ticker[,-1], ticker[,1])
  ticker <- ticker[paste0((as.Date(tail(a1[,1],1))+1),"/"),]
  ticker <- ticker["T09:30/T16:00",]
  dt <- index(ticker)
  lub.dt <- ymd_hms(dt, tz = 'America/New_York')
  index(ticker) <- lub.dt
  indexTZ(ticker) <- "UTC"
  ticker <- data.frame(ticker)
  ticker$date <- as.POSIXct(rownames(ticker), tz = "UTC")
  rownames(ticker) <- 1:nrow(ticker)
  ticker <- ticker[,c(2,1)]
  colnames(ticker)[2] <- "close"
  a2 <- rbind(a1,ticker)
  write.table(a2,
              paste0("/home/ege/Project/Stocks/",ticker_name,"_1min2.csv"), 
              row.names=F,
              na="NA",
              append=F, 
              quote= FALSE, 
              sep=",", 
              col.names=T)
}


# wdTicker <- c("ACN","ATVI","CSCO","IBM","NASDAQ","PFE","QCOM")
# system.time(for(i in 1:length(wdTicker)){
#   stockCombine(wdTicker[i])
# })

