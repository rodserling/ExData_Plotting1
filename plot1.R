##
## This file reads in "household_power_consumption.txt" and genenerates the specified plot.
## This plot being a histogram of Global_active_power.
##
## The file runs assuming the "household_power_consumption.txt" and "plot1.R" file reside in the same directory.
## The file plot1.png will be created in the same directory.
## The following line reads in the file, setting "?" to NA's and sets the column variable names.
##
powerConsumption <- read.table("household_power_consumption.txt",sep=";", header = TRUE, na.strings = c("NA","?"), colClasses = "character" )
##
## The following line creates a column in the frame upon which dates can be subsetted i.e. converts the
## date and time character column to a POSIX column and adds that column to the frame.
##
powerConsumption$datetime<-c(strptime(paste(powerConsumption$Date,powerConsumption$Time,sep=" "),"%d/%m/%Y %H:%M:%S"))
##  
##  Next lines convert the reference days 2007-02-01 and 2007-02-03 to POSIX values to use 
##  with logical comparisons, plots, etc.
##  
day1<-c(strptime("2007-02-01 00:00:00","%Y-%m-%d %H:%M:%S"))
day3<-c(strptime("2007-02-03 00:00:00","%Y-%m-%d %H:%M:%S"))
##
## Please note for the following data frame all of "day1" and "day2" are used but none of "day3" i.e. Feb 3.  The "day3" value
## is only an upper bound.  The following creates a 4th order magnitude smaller size frame for manageability.
##
powCon2Days<-powerConsumption[c( powerConsumption$datetime >= day1 & powerConsumption$datetime < day3 )  ,]
##
## The following eliminates all rows with NA's and converts usable rows to numerics per the histogram requirement.
## 
powCon2Days_GlobalActivePower<-as.numeric(powCon2Days$Global_active_power[!is.na(powCon2Days$Global_active_power)])
##
## The output plot is delivered into the same diretory as "plot1.R".
## The output plot is a histogram depicting the distribution of values between day1 and day3 i.e. all of day1 and day2
##
png("plot1.png")
hist(powCon2Days_GlobalActivePower,main=" Global Active Power",xlab = "Global Active Power (kilowatts)",col = "red")
dev.off()
