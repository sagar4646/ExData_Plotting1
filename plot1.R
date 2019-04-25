# Global active power
library(lubridate)
library(dplyr)
library(tidyr)
d=read.delim("household_power_consumption.txt",stringsAsFactors = F,sep=";")
str(d)

# required dates to be filtered
req_dates=as.Date("2007/02/01")+0:1

d_sub=d%>%
    mutate(date=dmy(Date))%>%
    filter(date %in% req_dates)%>%
    unite(date_time,c("Date","Time"),sep=" ")%>%
    mutate(date_time=dmy_hms(date_time))%>%
    select(1:8)
str(d_sub)

# search for '?'
sapply(d_sub[-(1)],function(x){
    length(grep("\\?",x))
})                               # no ?'s

# convert all var into numeric except date_time
d_sub[-(1)]=sapply(d_sub[-(1)],as.numeric)

# create the plot and store it has *.png
png("plot1.png")
with(d_sub,hist(Global_active_power,main = "Global Active Power",
                xlab = "Global Active Power(Kilowatts)",
                col="red"))
dev.off()