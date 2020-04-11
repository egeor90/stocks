get_quote_data <- function(symbol='IBM', data_range='1d', data_interval='5m'){
  require(xts)
  require(jsonlite)
  res <- paste0("https://query1.finance.yahoo.com/v8/finance/chart/",symbol,"?range=",data_range,"&interval=",data_interval)
  data <- fromJSON(res)
  names_ <- data.frame(names(unlist(data)))
  
  time_nr <- which(grepl('^chart.result.timestamp',names_[,1]))
  time_ <- as.POSIXct(as.numeric(as.character(data.frame(unlist(data))[time_nr,])), tz = "UTC", origin = "1970-01-01 00:00:00")
  
  for(i in c("open","high","low","close","volume")){
    nr_ <- which(grepl(paste0('^chart.result.indicators.quote.',i),names_[,1]))
    var_ <- data.frame(as.numeric(as.character(data.frame(unlist(data))[nr_,])))
    colnames(var_) <- i
    if(!exists("var_2")){
      var_2 <- var_
    }else{
      var_2 <- cbind(var_2,var_)
    }
  }  
  
  var_2 <- data.frame(date=time_,var_2)
  
  #data_ <- xts(var_2[,-1],var_2[,1])
  return(var_2)
}


stockCombine <- function(ticker){
  if(ticker == "NASDAQ"){
    wdTicker <- "%5Eixic"
  }else{
    wdTicker <- ticker
  }
  data_ <- read.csv(paste0(".../",ticker,"_1min.csv"), header = T, stringsAsFactors = F)
  data_1 <- get_quote_data(symbol = wdTicker, data_range = '1d', data_interval = "5m")
  data_$date <- as.POSIXct(data_[,"date"], tz="UTC")
  data_$volume <- as.numeric(data_[,"volume"])
  goog <- rbind(data_,data_1[which(data_1[,"date"] > tail(data_[,"date"],1)),])
  goog <- xts(goog[,-1],goog[,1])
  return(goog)
}

goog <- stockCombine(ticker = "NASDAQ")
