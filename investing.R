require(lubridate)
rm(list = ls())
setwd("~/Project/Stocks")
#between 08:30 and 16:00
if(hm(substr(as.character(Sys.time()),12,16)) >= hm("12:00") & hm(substr(as.character(Sys.time()),12,16)) <= hm("20:05")){
  library(rvest)
  require(stringr)
  
  sources <- c('equities/accenture-ltd','equities/activision-inc','equities/cisco-sys-inc','indices/nasdaq-composite',
               'equities/pfizer','equities/qualcomm-inc','equities/ibm','equities/microsoft-corp')
  for(i in 1:length(sources)){
    url <- paste0("https://www.investing.com/",sources[i])
    html <- read_html(url)
    
    price <- html %>% 
      html_nodes('#last_last') %>% 
      html_text() %>% 
      str_trim() %>% 
      unlist()
    
    ticker <- (html %>% 
                 html_nodes('.relativeAttr') %>% 
                 html_text() %>% 
                 str_trim() %>% 
                 unlist())[1]
    
    time <- substr((html %>% 
                      html_nodes('.arial_11') %>% 
                      html_text() %>% 
                      str_trim() %>% 
                      unlist())[4],1,8)
    status <- if(substr((html %>% 
                        html_nodes('.arial_11') %>% 
                        html_text() %>% 
                        str_trim() %>% 
                        unlist())[4],9,14) == "Closed"){
      "closed"
    }else{
      "open"
    }
    
    date_time <- as.POSIXct(paste(Sys.Date(), time), tz = "America/New_York")
    
    df <- data.frame(ticker = ticker, time = date_time, price = as.numeric(gsub(",","",price)),status = status)
    #df[which(hms(substr(df$time, 12,19)) >= hm("16:01")) || which(hms(substr(df$time, 12,19)) <= hm("12:29")) ,4] <- "closed"
    
    if(!exists("data_2")){
      data_2 <- df
    }else{
      data_2 <- rbind(data_2,df)
    }
  } 
  
  data_2 <- data_2[which(substr(data_2$time,12,19) != "00:00:00"),]
  data_2 <- data_2[!duplicated(data_2),]
  #save.image("~/Project/Stocks/allData.RData")
  # saveRDS(list(data_),file="allData.rds")
  
  # stock <- function(ticker_name){
  #   require(dplyr)
  #   require(xts)
  #   ticker_name <- toupper(ticker_name)
  #   xts_ <- xts(data_[which(grepl(ticker_name,data_$ticker)),3],data_[which(grepl(ticker_name,data_$ticker)),2])
  #   colnames(xts_) <- tolower(ticker_name)
  #   my.endpoints <- endpoints(xts_,k=1,on="minutes")
  #   xts_ <- period.apply(xts_, INDEX = my.endpoints, function(x) tail(x,1))
  #   index(xts_) <- align.time(index(xts_))-60
  #   df <- as.data.frame(xts_)
  #   df$date <- as.POSIXct(rownames(df), tz = "America/New_York")
  #   df <- df[,c(2,1)]
  #   rownames(df) <- index(df)
  #   assign(tolower(ticker_name), df, envir = .GlobalEnv)
  #   write.table(df,
  #               paste0("/home/ege/Project/Stocks/",ticker_name,"_1m.csv"), 
  #               row.names=F,
  #               na="NA",
  #               append=F, 
  #               quote= FALSE, 
  #               sep=",", 
  #               col.names=T)
  #   return(df)
  # }
  # 
  # 
  # tick <- c("ACN","ATVI","CSCO","IXIC","PFE","QCOM","IBM","MSFT")
  # for(i in 1:length(tick)){
  #   stock(tick[i])
  # }
  
  
  load("allData.RData")
  data_ <- rbind(data_,data_2)
  data_ <- data_[!duplicated(data_),]
  rm(list=setdiff(ls(), "data_"))
  
  save.image("allData.RData")
  }else{
    stop("Market closed!")
}

#allData <- as.data.frame(readRDS("~/Project/Stocks/allData.rds"))
# 
# appendToFile <- function(newRow, savedFile){
#   load(savedFile, new.env())
#   df = rbind(df, newRow)
#   save(df, file = savedFile)
# }
# 
# 
# 
# 
# 
# df <- data.frame(x = 1:5, y = 6:10)
# save(df, file = "file.RData")
# appendToFile(c(50, 100), "file.RData")
# 
# # Check if changes are saved
# load("file.RData")
# tail(df, 3)
# # 
# # con <- file("allData.rds")
# # open(con)
# # df <- readRDS(con)
# # df.new <- rbind(df,df)
# # saveRDS(df.new, con)
# # close(con)

# data_$status <- "open"
# data_[which(hms(substr(data_$time, 12,19)) >= hm("16:01")) ,4] <- "closed"
# data_[which(hms(substr(data_$time, 12,19)) <= hm("12:29")),4] <- "closed"
