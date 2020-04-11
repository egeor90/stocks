# rm(list = ls())
# start_ <- Sys.time()
stock <- function(ticker_name){
  require(dplyr)
  require(xts)
  #data_ <- as.data.frame(readRDS("~/Project/Stocks/allData.rds"))
  load("~/Project/Stocks/allData.RData")
  data_ <- data_[which(data_$status != "closed"),-4]
  ticker_name <- toupper(ticker_name)
  xts_ <- xts(data_[which(grepl(ticker_name,data_$ticker)),3],data_[which(grepl(ticker_name,data_$ticker)),2])
  colnames(xts_) <- tolower(ticker_name)
  my.endpoints <- endpoints(xts_,k=1,on="minutes")
  xts_ <- period.apply(xts_, INDEX = my.endpoints, function(x) tail(x,1))
  index(xts_) <- align.time(index(xts_))-60
  df <- as.data.frame(xts_)
  df$date <- as.POSIXct(rownames(df), tz = "America/New_York")
  df <- df[,c(2,1)]
  rownames(df) <- index(df)
  assign(tolower(ticker_name), df, envir = .GlobalEnv)
  # write.table(df,
  #             paste0("/home/ege/Project/Stocks/",ticker_name,"_1m.csv"),
  #             row.names=F,
  #             na="NA",
  #             append=F,
  #             quote= FALSE,
  #             sep=",",
  #             col.names=T)
  return(df)
}

# system.time(
# stock("IXIC"))

# tick <- c("ACN","ATVI","CSCO","IXIC","PFE","QCOM","IBM","MSFT")
# for(i in 1:length(tick)){
#   stock(tick[i])
# }
# 
# 
# end_ <- Sys.time()
# (time_ <- end_-start_)


# a_xts <- as.data.frame(readRDS("allData.rds")) %>% filter(grepl(ticker_name,ticker))

