# exdata-016 sergioquadros 2014-12-18
# R version 3.1.2 (2014-10-31) -- "Pumpkin Helmet"
# Platform: i686-pc-linux-gnu (32-bit)

# libraries
library(dplyr)
library(magrittr)
library(ggplot2)
library(png)
# setting working directory
workdir <- getwd()
# downloading and unzip data
download.file("http://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
              ,destfile="exdata_data_NEI_data.zip")
unzip(zipfile="exdata_data_NEI_data.zip", files = NULL, list = FALSE, 
      overwrite = TRUE, junkpaths = FALSE, exdir = workdir, unzip = "internal",
      setTimes = FALSE)
# This first line will likely take a few seconds. Be patient!
NEI <- readRDS("summarySCC_PM25.rds")
nei <- tbl_df(NEI)
nei$year %<>% factor
nei$type %<>% factor
# Subset Baltimore fips=="24510": 2096 TRUEs
balt_type<-nei %>%
  filter(fips=="24510") %>%
  select(year, type, Emissions) %>%
  group_by(year,type) %>%
  summarise(total=sum(Emissions)) 
# open png device
png(filename = "plot3.png",
    width = 480, height = 480, units = "px", 
    bg = "white",res=NA)
qplot(year, total, data=balt_type, colour=type, facets=type~.,type="l",
      geom=c("point","line"))+
  facet_grid(type ~ ., scale = "free_y")+aes(group = 1)+
  geom_line(size = 0.5)+labs(x="Year", y ="Emissions (tons)",
                             title=expression("Annual "*PM[2.5]*" Emissions in the Baltimore by sources' type"))
# close device        
dev.off()