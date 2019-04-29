#laod package 
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
#filter baltimore ciyt  motor vehicle sources type form all emission and group by year and summirze sum  

Baltimore_emissions <- filter(summarySCC_PM25, fips == "24510"& type == 'ON-ROAD')%>%
                       group_by(year)%>% summarise(Emissions=sum(Emissions))
#filter Loss Angeles  ciyt  motor vehicle sources type form all emission and group by year and summirze sum  

LosAngeles_emissions<- filter(summarySCC_PM25, fips == "06037"& type == 'ON-ROAD')%>%
                       group_by(year)%>% summarise(Emissions=sum(Emissions))
#add colum to contery name to filter data 
Baltimore_emissions$County <- "Baltimore"
LosAngeles_emissions$County <- "Los Angeles"
#marage data 
Both_emissions <- rbind(Baltimore_emissions, LosAngeles_emissions)
#open png file 
png("plot6.png", width=480, height=480)
#plot figure
p<- ggplot(Both_emissions, aes(x=factor(year), y=Emissions)) +
  geom_bar(stat="identity") + 
  facet_grid(County~., scales="free") +
  ylab("total PM[2.5] emissions in tons") + 
  xlab("year") +
  ggtitle("Motor vehicle emission variation in Baltimore and Los Angeles in tons")
print(p)
dev.off()