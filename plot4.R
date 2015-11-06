## plot4.R
## This script reads the data household_power_consumption.txt 
## and generates the required plot4.png. The data file is assumed
## to be in the same folder as the script. 
## The png file is created in the same folder.

library(dplyr)
library(lubridate)
options(stringsAsFactors = FALSE)
dev.off()

### Read the file
householdData <- tbl_df(read.table( file = "household_power_consumption.txt", sep=";", quote = "", header = TRUE))

## filter to the two days 2/1/2007 and 2/2/2007
februaryHouseholdData <- householdData %>% filter(grepl("^[12]{1}/2/2007", Date))
februaryHouseholdData$Date <- as.Date(februaryHouseholdData$Date, format =  "%d/%m/%Y")  ## not required here

## make quantities numerical and add a datetime column
february1 <- februaryHouseholdData %>% select(-Date,-Time) %>% mutate_each(funs(as.numeric)) 
februaryData <- februaryHouseholdData %>% select(Date,Time) %>% bind_cols(february1) %>% 
        mutate(datetime = paste(Date, " " , Time))

## convert the datetime values to POSIXlt POSIXt 
februaryData$datetime <- strptime(februaryData$datetime, format = "%Y-%m-%d %H:%M:%S")

## plot with type "l" to connect dots; add label and legend; fix a bit teh locations/size
par(mfrow = c(2,2), mar = c(6,4,0,6), oma = c(0,4,1,4))
## plot A
with(februaryData, plot(datetime, Global_active_power, type  = "l", xlab = "", ylab = "Global Active Power")) 
## plot B
with(februaryData, plot(datetime, Voltage, type  = "l", ylab = "Voltage")) 
## plot C
with(februaryData,   plot(datetime, Sub_metering_1, type  = "l", xlab = "", ylab = "Energy sub metering"))
with(februaryData, points(datetime, Sub_metering_2, type  = "l", col = "red"))
with(februaryData, points(datetime, Sub_metering_3, type  = "l", col = "blue")) 
legend("topright", lty = c(1,1,1), bty = "n", col = c("black", "red", "blue"), legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
## plot D
with(februaryData, plot(datetime, Global_reactive_power, type  = "l")) 
 
## Convert to plot4.png
dev.copy(png, file = "plot4.png", width = 1200, height = 600) ## Copy my plot to a PNG file
dev.off() ## Don't forget to close the PNG device!