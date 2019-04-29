#load required package
library(dplyr)
library(ggplot2)
#Download DataSet
filename <- "exdata_data_NEI_data.zip"

if (!file.exists(filename)){
  fileURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
  download.file(fileURL, filename, method="curl")
}  

if (!file.exists("exdata_data_NEI_data")) { 
  unzip(filename) 
}
#read national emssion invontry data 

summarySCC_PM25 <- readRDS("exdata_data_NEI_data/summarySCC_PM25.rds")
#filter baltomore city form all emission data group by year and type summarize sum 
Baltimore_emissions<- filter(summarySCC_PM25, fips == "24510")%>%
                      group_by(year, type)%>% 
                      summarise(Emissions = sum(Emissions))
#open png device
png("plot3.png", width=480, height=480)

#plot figure

p <- ggplot(Baltimore_emissions, aes(x=factor(year), y=Emissions)) +
  geom_bar(stat="identity") +
  facet_grid(. ~ type) +
  xlab("year") +
  ylab("total PM[2.5] emission in kilotons") +
  ggtitle("Total PM[2.5] emissions from 1999 to 2008")
print(p)
dev.off()