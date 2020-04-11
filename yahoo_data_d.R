source("/home/ege/Project/Stocks/yahoo_data.R")
stocks_ <- c("ACN","ATVI","CSCO","IBM","PFE","QCOM")
for(i in 1:length(stocks_)){
  assign(paste0(tolower(stocks_[i]),1),get_quote_data(symbol = stocks_[i], data_range = '1d', data_interval = "5m"))
  assign(tolower(stocks_[i]),read.csv(paste0("/home/ege/Project/Stocks/",stocks_[i],"_1min.csv"), header = T, stringsAsFactors = F))
  assign(tolower(stocks_[i]), `[[<-`(get(tolower(stocks_[i])), 'date', value = as.POSIXct(get(paste0(tolower(stocks_[i])))[,"date"], tz="UTC")))
  assign(tolower(stocks_[i]), `[[<-`(get(tolower(stocks_[i])), 'volume', value = as.numeric(get(paste0(tolower(stocks_[i])))[,"volume"])))
  assign(paste0(tolower(stocks_[i]),2), rbind(get(tolower(stocks_[i])),
                                              get(tolower(paste0(stocks_[i],1)))[which(get(tolower(paste0(stocks_[i],1)))[,"date"] > tail(get(tolower(stocks_[i]))[,"date"],1)),]))
}


for(i in 1:length(stocks_)){
write.table(get(paste0(tolower(stocks_[i]),2)),
              paste0("/home/ege/Project/Stocks/",stocks_[i],"_1min.csv"),
              row.names=F,
              na="NA",
              append=F,
              quote= FALSE,
              sep=",",
              col.names=T)
}

nasdaq <- read.csv(paste0("/home/ege/Project/Stocks/NASDAQ_1min.csv"), header = T, stringsAsFactors = F)
nasdaq1 <- get_quote_data(symbol = "%5Eixic", data_range = '1d', data_interval = "5m")
nasdaq$date <- as.POSIXct(nasdaq[,"date"], tz="UTC")
nasdaq$volume <- as.numeric(nasdaq[,"volume"])
nasdaq2 <- rbind(nasdaq,nasdaq1[which(nasdaq1[,"date"] > tail(nasdaq[,"date"],1)),])

write.table(nasdaq2,
            paste0("/home/ege/Project/Stocks/NASDAQ_1min.csv"),
            row.names=F,
            na="NA",
            append=F,
            quote= FALSE,
            sep=",",
            col.names=T)


