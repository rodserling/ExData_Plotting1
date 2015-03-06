##
## This file reads in "household_power_consumption.txt" and genenerates the specified plot.
## This plot being Global_active_power samples over the specified 2 day period.
##
## The file runs assuming the "household_power_consumption.txt" and "plot2.R" file reside in the same directory.
## The file plot2.png will be created in the same directory.
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
powCon2Days_NoNA<-powCon2Days[activePower_NoNA,]
##
## The output plot is delivered into the same diretory as "plot2.R".
## The output plot is a line plot depicting each sampled value of $Global_active_power for day1 and day2 
## i.e. all of day1 and day2.  The axis.POSICct code plots the Thur through Sat "rug" below the x-axis.
##
png("plot2.png")
plot(powCon2Days_NoNA$datetime,powCon2Days_NoNA$Global_active_power,type = "l", xaxt="n", xlab="",ylab = "Global Active Power (kilowatts)")
axis.POSIXct(1,powCon2Days_NoNA$datetime,at=c(day1,day2,day3),format="%a")
dev.off()
