#import lubridate for date processing 
library(lubridate)

#Check if file exists, downloads/unzips if file does not exist
txtFile <- "data/household_power_consumption.txt"
if(!file.exists(txtFile))
{
  zipFile <- "data/household_power_consumption.zip"
  if(!file.exists(zipFile))
  {
    fileURL <- "https://archive.ics.uci.edu/ml/machine-learning-databases/00235/household_power_consumption.zip"
    download.file(fileURL,destfile = zipFile)
  }
  unzip(zipFile,exdir = "./data")
}

#read data and create subset to store data for 1st and 2nd Feb 2007
electricity <- read.table(txtFile, sep = ";",header = TRUE)
edata <- electricity[which(electricity$Date %in% c("1/2/2007","2/2/2007")),]

#format data classes and create a date time column for ease of plotting along date_time
edata$Date <- dmy(edata$Date)
edata[,10]<-as_datetime(paste(edata$Date,edata$Time))
names(edata)[10]<-"Date_time"
edata[,3:9] <- sapply(edata[,3:9],as.numeric)
#summary(edata)
#str(edata)

#Plot 4
png("figure/Plot4.png")
par(mfcol = c(2,2),mar=c(4,4,2,1))

with(edata,plot(Date_time,Global_active_power,type = "n",ylab = "Global Active Power (kW)", xlab = ""))
lines(edata$Date_time,edata$Global_active_power)

with(edata,plot(Date_time,Sub_metering_1,type = "n",ylab = "Energy Sub Metering", xlab = ""))
lines(edata$Date_time,edata$Sub_metering_1)
lines(edata$Date_time,edata$Sub_metering_2,col="red")
lines(edata$Date_time,edata$Sub_metering_3,col="blue")
legend("topright",legend = c("Sub Metering 1","Sub Metering 2","Sub Metering 3"),col = c("black","red","blue"),lwd=c(1,1,1))

with(edata,plot(Date_time,Voltage,type = "n",ylab = "Voltage", xlab = ""))
lines(edata$Date_time,edata$Voltage)

with(edata,plot(Date_time,Global_reactive_power,type = "n",ylab = "Global Reactive Power", xlab = ""))
lines(edata$Date_time,edata$Global_reactive_power)

dev.off()

