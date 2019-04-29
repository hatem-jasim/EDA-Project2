#load required library 
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
#read files 
summarySCC_PM25 <- readRDS("exdata_data_NEI_data/summarySCC_PM25.rds")
Source_Classification_Code <- readRDS("exdata_data_NEI_data/Source_Classification_Code.rds")
#make index to emissions from coal combustion-related sources
coal_combustion_index <- grepl("Fuel Comb.*Coal", Source_Classification_Code$EI.Sector)
#recall source form Source_Classification_Code by index 
coal_combustion<- Source_Classification_Code[coal_combustion_index,]

# Find emissions from coal combustion-related sources
emissions_coal_combustion <- summarySCC_PM25[(summarySCC_PM25$SCC %in% coal_combustion$SCC), ]
#group by year and summirze sum 
emissions_coal_related <- group_by(emissions_coal_combustion, year)%>% summarise(Emissions=sum(Emissions))
#open png device 
png("plot4.png", width=480, height=480)
#plot figure
p<- ggplot(emissions_coal_related, aes(x=factor(year), y=Emissions/1000)) +
  geom_bar(stat="identity") +
  xlab("year") +
  ylab("total PM[2.5]emissions in kilotons") +
  ggtitle("Emissions from coal combustion-related sources changed from 1999-2008")
print(p)
dev.off()