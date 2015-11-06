## plot1.R
## This script reads the data household_power_consumption.txt 
## and generates the required plot1.png. The data file is assumed
## to be in the same folder as the script. 
## The png file is created in the same folder.

library(dplyr)
options(stringsAsFactors = FALSE)
dev.off()

## Read the file
householdData <- tbl_df(read.table( file = "household_power_consumption.txt", sep=";", quote = "", header = TRUE))

## filter to the two days 2/1/2007 and 2/2/2007
februaryHouseholdData <- householdData %>% filter(grepl("^[12]{1}/2/2007", Date))
februaryHouseholdData$Date <- as.Date(februaryHouseholdData$Date, format =  "%d/%m/%Y")  ## not required here

## make quantities numerical
february1 <- februaryHouseholdData %>% select(-Date,-Time) %>% mutate_each(funs(as.numeric)) 
februaryData <- februaryHouseholdData %>% select(Date,Time) %>% bind_cols(february1) %>% 
        mutate(DateTime = paste(Date, " " , Time))

## plot to screen and then copy to png file
with(februaryData, hist(Global_active_power, main = "Global Active Power", col = "red", xlab = "Global Active Power (kilowatts)") )
dev.copy(png, file = "plot1.png",  width = 480, height = 480) ## Copy my plot to a PNG file
dev.off() ## Don't forget to close the PNG device!