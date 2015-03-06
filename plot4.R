##
## This file reads in "household_power_consumption.txt" and genenerates the specified plot.
## This plot being the 2x2 different plots in one file.
##
## The file runs assuming the "household_power_consumption.txt" and "plot4.R" file reside in the same directory.
## The file plot4.png will be created in the same directory.
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
## The following eliminates all rows with at least one NA in either the $datetime column or $Global_active_power 
## column.  
## 
activePower_NoNA<-c( (!is.na(powCon2Days$Global_active_power)) & (!is.na(powCon2Days$datetime)))
powCon2DaysPlot1_NoNA<-powCon2Days[activePower_NoNA,]
##
## The following eliminates all rows with at least one NA in either the $datetime column or $Voltage 
## column.  
## 
voltage_NoNA<-c( (!is.na(powCon2Days$Voltage)) & (!is.na(powCon2Days$datetime)))
powCon2DaysPlot2_NoNA<-powCon2Days[voltage_NoNA,]
##
## The following eliminates all rows with at least one NA in either the $datetime column or any of the
## three diffferent sub_meter columns.
## 
subMet123_NoNA<-c( (!is.na(powCon2Days$Sub_metering_1)) & (!is.na(powCon2Days$Sub_metering_2)) & (!is.na(powCon2Days$Sub_metering_3)) & (!is.na(powCon2Days$datetime)))
powCon2DaysPlot3_NoNA<-powCon2Days[subMet123_NoNA,]
##
## The following eliminates all rows with at least one NA in either the $datetime column or $Reactive_active_power 
## column.  
## 
reactivePower_NoNA<-c( (!is.na(powCon2Days$Global_reactive_power)) & (!is.na(powCon2Days$datetime)))
powCon2DaysPlot4_NoNA<-powCon2Days[reactivePower_NoNA,]
##
## The following sets the formate of a 2x2 placement of plots in 1 png.  
## The png file is placed into the same directory as plot4.R
##
png("plot4.png", pointsize=12)
par(mfrow = c(2,2), oma = c(1, 1, 0, 0), mar = c(3, 3, 3, 3), mgp = c(2, 1, 0), xpd = NA)
##
## The upper left output plot is a line plot depicting each sampled value of $Global_active_power for day1 and day2 
## i.e. all of day1 and day2.  The axis.POSICct line plots the Thur through Sat "rug" below the x-axis.
##
plot(powCon2DaysPlot1_NoNA$datetime,powCon2DaysPlot1_NoNA$Global_active_power,type = "l", xaxt="n", xlab="",ylab = "Global Active Power")
axis.POSIXct(1,powCon2DaysPlot1_NoNA$datetime,at=c(day1,day2,day3),format="%a")
##
## The upper right output plot is a line plot depicting each sampled value of $Voltage for day1 and day2 
## i.e. all of day1 and day2.  The axis.POSICct code plots the Thur through Sat "rug" below the x-axis.
##
plot(powCon2DaysPlot2_NoNA$datetime,powCon2DaysPlot2_NoNA$Voltage,type = "l", xaxt="n", xlab="datetime",ylab = "Voltage")
axis.POSIXct(1,powCon2DaysPlot1_NoNA$datetime,at=c(day1,day2,day3),format="%a")
##
## The lower left output plot is a line plot depicting each sampled value of the 3 different sub_meters for day1 and day2 
## i.e. all of day1 and day2.  The axis.POSICct code plots the Thur through Sat "rug" below the x-axis.
##
plot(powCon2DaysPlot3_NoNA$datetime,powCon2DaysPlot3_NoNA$Sub_metering_1,type = "l", xaxt="n", xlab="",ylab = "Energy sub metering")
points(powCon2DaysPlot3_NoNA$datetime,powCon2DaysPlot3_NoNA$Sub_metering_2, type = "l", col="red")
points(powCon2DaysPlot3_NoNA$datetime,powCon2DaysPlot3_NoNA$Sub_metering_3, type = "l", col="blue")
legend("topright",bty="n",cex=.8,col=c("black","red","blue"), lty = c(1,1,1), legend = c("Sub_metering_1","Sub_metering_2","Sub_metering_3"))
axis.POSIXct(1,powCon3Days_NoNA$datetime,at=c(day1,day2,day3),format="%a")
##
## The lower right output plot is a line plot depicting each sampled value of $Global_reactive_power for day1 and day2 
## i.e. all of day1 and day2.  The axis.POSICct code plots the Thur through Sat "rug" below the x-axis.
##
plot(powCon2DaysPlot4_NoNA$datetime,powCon2DaysPlot4_NoNA$Global_reactive_power,type = "l", xaxt="n", xlab="datetime",ylab = "Global_reactive_power")
axis.POSIXct(1,powCon2DaysPlot4_NoNA$datetime,at=c(day1,day2,day3),format="%a")
##
dev.off()

