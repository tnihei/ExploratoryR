# exdata-016 sergioquadros 2014-12-18
# R version 3.1.2 (2014-10-31) -- "Pumpkin Helmet"
# Platform: i686-pc-linux-gnu (32-bit)

# libraries
library(dplyr)
library(magrittr)
library(base)
library(png)
# setting working directory
workdir <- getwd()
# downloading and unzip data
download.file("http://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
              ,destfile="exdata_data_NEI_data.zip")
unzip(zipfile="exdata_data_NEI_data.zip", files = NULL, list = FALSE, 
      overwrite = TRUE, junkpaths = FALSE, exdir = workdir, unzip = "internal",
      setTimes = FALSE)
## This first line will likely take a few seconds. Be patient!
NEI <- readRDS("summarySCC_PM25.rds")
nei <- tbl_df(NEI)
nei$year %<>% factor
# Subsetting Baltimore's emissions fips="24510": 2096 TRUEs
balt_pm<-nei %>%
  filter(fips=="24510") %>%
  select(year,Emissions) %>%
  group_by(year) %>%
  summarise(total=sum(Emissions)) 
# open png device
png(filename = "plot2.png",
    width = 480, height = 480, units = "px", 
    bg = "white",res=NA)
# nice tip from forum
with(balt_pm,barplot(total,names.arg=year, xlab="Year",
                     main=expression("Annual "*PM[2.5]*" Emissions in Baltimore"),
                     ylab=expression("Annual "*PM[2.5]*" emissions (tons)")))
dev.off()
