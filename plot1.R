# load required package
library(dplyr)

#Download DataSet
filename <- "exdata_data_NEI_data.zip"

if (!file.exists(filename)){
  fileURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
  download.file(fileURL, filename, method="curl")
}  

if (!file.exists("exdata_data_NEI_data")) { 
  unzip(filename) 
}

#read file
summarySCC_PM25 <- readRDS("exdata_data_NEI_data/summarySCC_PM25.rds")
#group and summrizae sum  Emissions Data by year
Emissions_Data <- group_by(summarySCC_PM25, year)  %>% summarise(Emissions = sum(Emissions))

#open png device 

png("plot1.png", width=480, height=480)
#plot graph
p <- barplot(Emissions_Data$Emissions/1000, 
            names.arg=Emissions_Data$year,
            xlab="years", 
            ylab='PM[2.5]emission in kilotons ',
            ylim=c(0,8000),
            main='Total PM[2.5] emissions from 1999 to 2008')
print(p)
dev.off()
