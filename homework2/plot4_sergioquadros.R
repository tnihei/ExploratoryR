# exdata-016 sergioquadros 2014-12-20
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
SCC <- readRDS("Source_Classification_Code.rds")
nei <- tbl_df(NEI)
scc <- tbl_df(SCC)

# Subsetting USA's coal combustion-related sources: 239 levels
# with 53400 sources that used coal.

coal_scc <- filter(scc, grepl('[Cc]oal', scc$Short.Name))
coal_nei <- (nei$SCC %in% coal_scc$SCC) # logical flag to "[Cc]oal"
usa_coal <- nei[coal_nei,]
usa_coal$year %<>% factor
usa_coal$SCC %<>% as.numeric
usa_coal %<>% select(Emissions,year)%>%
  group_by(year) %>%
  summarise(total=sum(Emissions, na.rm = TRUE)/1000) 

# open png device
png(filename = "plot4.png",
    width = 480, height = 480, units = "px", 
    bg = "white",res=NA)
qplot(year, total, data=usa_coal, geom=c("point","smooth"))+aes(group = 1)+
  geom_line(size = 0.4)+geom_smooth(method="loess")+
  labs(x="Year", y ="Emissions (kilotons)",
       title=expression("Annual "*PM[2.5]*" Emissions in USA by coal sources"))
# close device        
dev.off()