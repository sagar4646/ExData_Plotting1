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
png("plot3.png")
par(mar=c(3,3,1,1))
with(d_sub,plot(date_time,
                Sub_metering_1,
                type="n",
                ylab = "Energy sub metering"))
lines(d_sub$date_time,d_sub$Sub_metering_1,col="black")
lines(d_sub$date_time,d_sub$Sub_metering_2,col="red")
lines(d_sub$date_time,d_sub$Sub_metering_3,col="blue")
legend("topright",legend = c(paste0("Sub_metering_",1:3)),
       lty=1,col=c("black","red","blue"),cex=.75)
dev.off()
