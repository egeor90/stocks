rm(list = ls())
gc()
# library(microbenchmark)
# microbenchmark(n <- readRDS('allData.rds'),load('b.RData'),times = 1000)
#bm <- NA
for(i in 1:5000){
start_ <- Sys.time()
load("b.RData")
#b %>% filter(ticker == "Pfizer Inc (PFE)")
end_ <- Sys.time()
time1 <- end_-start_

start_ <- Sys.time()
d <- as.data.frame(readRDS("allData.rds"))
#%>% filter(ticker == "Pfizer Inc (PFE)")
end_ <- Sys.time()
time2 <- end_-start_

start_ <- Sys.time()
csv_ <- as.data.frame(fread("a.csv"))
end_ <- Sys.time()
time3 <- end_-start_


if(!exists("bm")){
  bm <- data.frame(rdata = as.numeric(time1), rds = as.numeric(time2), csv = as.numeric(time3),iter = i)
}else{
  bm <- rbind(bm,data.frame(rdata = as.numeric(time1), rds = as.numeric(time2), csv = as.numeric(time3), iter = i))
}
}
options(scipen = 20)
colMeans(bm)

#the winner is rdata > rds > fread.csv

