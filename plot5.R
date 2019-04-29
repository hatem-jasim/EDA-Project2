#laod required package
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
#laod files 
summarySCC_PM25 <- readRDS("exdata_data_NEI_data/summarySCC_PM25.rds")

#filter baltimore and emission motor vehicle sources type and groupby year and summarize sum  
Baltimore_emissions<- filter(summarySCC_PM25, fips=="24510" & type=="ON-ROAD") %>%
                      group_by(year)%>% summarise(Emissions = sum(Emissions))
#open png device 
png("plot5.png", width=480, height=480)

#plot figure
p<-ggplot(Baltimore_emissions, aes(x=factor(year), y=Emissions)) +
  geom_bar(stat="identity") +
  xlab("year") +
  ylab("total PM[2.5]emissions in kilotons") +
  ggtitle("Emissions from motor vehicle sources in Baltimore City")
print(p)
dev.off()