#Plot4
#144 MB of Data
## Unzip File
url<-"https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
temp <- tempfile()
download.file(url,temp)
data <- read.table(unz(temp, "household_power_consumption.txt"),header = TRUE,sep=";")
unlink(temp)

## Reading Date Column and choosing from them
dates<-data$Date
dates<-as.character(dates)
dates<-as.Date(dates,"%d/%m/%Y")
data$Date<-dates
r<-c("2007-02-01","2007-02-02")
p<-sapply(r, function(y) grep(y,dates))   #Getting the Index of those two days
p<-c(p[,1],p[,2])

#Making Data Small
data<-data[p,]


#Time Column 
data$Time<-as.character(data$Time)
data$Date<-as.character(data$Date)
data$DateTime<-with(data,paste(Date,Time))

data$Time<-strptime(data$DateTime,format="%Y-%m-%d %H:%M:%S")
data$Time<-as.POSIXlt(data$Time)

# ? -> NA
data[data$Global_intensity=="?"]<-NA
data[data$Global_active_power=="?"]<-NA
data[data$Global_reactive_power=="?"]<-NA
data[data$Voltage=="?"]<-NA
data[data$Sub_metering_1=="?"]<-NA
data[data$Sub_metering_2=="?"]<-NA
data[data$Sub_metering_3=="?"]<-NA

## Plot 4 ##
data$Voltage<-as.character(data$Voltage)
data$Voltage<-as.numeric(data$Voltage)

data$Global_reactive_power<-as.character(data$Global_reactive_power)
data$Global_reactive_power<-as.numeric(data$Global_reactive_power)

par(mfrow=c(2,2))
plot(data$Time,data$Global_active_power,type="l",xlab="",ylab="Global Active Power")
plot(data$Time,data$Voltage,type="l",xlab="datetime",ylab="Voltage")


plot(data$Time, data$Sub_metering_1, type="l", col="black",ylim=c(0,35),ylab = "Energy sub metering",xlab = "")
par(new=TRUE)
plot(data$Time, data$Sub_metering_2, type="l", col="red",ylim=c(0,35),ylab="Energy sub metering",xlab = "")
par(new=TRUE)
plot(data$Time, data$Sub_metering_3, type="l", col="blue",ylim=c(0,35),ylab="Energy sub metering",xlab = "")
par(new=FALSE)
legend("topright",col=c("black","red","blue"),legend=c("Sub_metering_1","Sub_metering_2","Sub_metering_3"),lty=1)


plot(data$Time,data$Global_reactive_power,type="l",xlab="datetime",ylab="Global_reactive_power")
dev.copy(png,file="plot4.png") #Copy plot to png file
dev.off()