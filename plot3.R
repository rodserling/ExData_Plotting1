##
## This file reads in "household_power_consumption.txt" and genenerates the specified plot.
## This plot being 3 different Sub_meter values plotted together vs time.
##
## The file runs assuming the "household_power_consumption.txt" and "plot3.R" file reside in the same directory.
## The file plot3.png will be created in the same directory.
## The following line reads in the file, setting "?" to NA's and sets the column variable names.
##
powerConsumption <- read.table("household_power_consumption.txt",sep=";", header = TRUE, na.strings = c("NA","?"), colClasses = "character" )
##
## The following line creates a column in the frame upon which dates can be subsetted i.e. converts the
## date and time character column to a POSIX column and adds that column to the frame.
##
powerConsumption$datetime<-c(strptime(paste(powerConsumption$Date,powerConsumption$Time,sep=" "),"%d/%m/%Y %H:%M:%S"))
##  
##  Next lines convert the reference days 2007-02-01 through 2007-02-03 to POSIX values to use 
##  with logical comparisons, plots, etc.
## 
day1<-c(strptime("2007-02-01 00:00:00","%Y-%m-%d %H:%M:%S"))
day2<-c(strptime("2007-02-02 00:00:00","%Y-%m-%d %H:%M:%S"))  
day3<-c(strptime("2007-02-03 00:00:00","%Y-%m-%d %H:%M:%S"))
##
## Please note for the following created data frame all of "day1" and "day2" are used but none of "day3" i.e. Feb 3.  The "day3" value
## is only an upper bound.  The following creates a 4th order magnitude smaller size frame for manageability.
##
powCon2Days<-powerConsumption[c( powerConsumption$datetime >= day1 & powerConsumption$datetime < day3 )  ,]
##
## The following eliminates all rows with at least one NA in either the $datetime column or any of the
## three diffferent sub_meter columns.
## 
subMet123_NoNA<-c( (!is.na(powCon2Days$Sub_metering_1)) & (!is.na(powCon2Days$Sub_metering_2)) & (!is.na(powCon2Days$Sub_metering_3)) & (!is.na(powCon2Days$datetime)))
powCon2Days_NoNA<-powCon2Days[subMet123_NoNA,]
##
## The output plot is delivered into the same diretory as "plot3.R".
## The output plot is a line plot depicting each sampled value of the 3 different sub_meters for day1 and day2 
## i.e. all of day1 and day2.  The axis.POSICct code plots the Thur through Sat "rug" below the x-axis.
##
png("plot3.png")
plot(powCon2Days_NoNA$datetime,powCon2Days_NoNA$Sub_metering_1,type = "l", xaxt="n", xlab="",ylab = "Energy sub metering")
points(powCon2Days_NoNA$datetime,powCon2Days_NoNA$Sub_metering_2, type = "l", col="red")
points(powCon2Days_NoNA$datetime,powCon2Days_NoNA$Sub_metering_3, type = "l", col="blue")
legend("topright",col=c("black","red","blue"), lty = c(1,1,1), legend = c("Sub_metering_1","Sub_metering_2","Sub_metering_3"))
axis.POSIXct(1,powCon2Days_NoNA$datetime,at=c(day1,day2,day3),format="%a")
dev.off()
