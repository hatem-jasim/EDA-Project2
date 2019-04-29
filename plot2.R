#load requred package
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
#filter Baltimore City, Maryland from Emmision and group by year summrize sum 
Baltimore_emissions<- filter(summarySCC_PM25, fips == '24510') %>% group_by(year) %>% 
                      summarise(Emissions = sum(Emissions))
#open png device

png("plot2.png", width=480, height=480)
#plot graph 
p<- barplot(Baltimore_emissions$Emissions/1000, 
            names.arg=Baltimore_emissions$year,
            xlab="years", 
            ylab='total PM[2.5] emission in kilotons',
            ylim=c(0,4),
            main='PM[2.5] emissions in Baltimore City from 1999 to 2008')
print(p)
dev.off()