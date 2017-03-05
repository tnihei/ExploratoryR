library(ggplot2)
library(plyr)

# Read in NEI data
subdir <- "exdata_data_NEI_data"
file1 <- "summarySCC_PM25.rds"
file2 <- "Source_Classification_Code.rds"
#NEI <- readRDS(paste(subdir, file1, sep="/"))
#SCC <- readRDS(paste(subdir, file2, sep="/"))

# Subset the data for Baltimore and LA,  and Motor Vehicles, 
# and then merge the data.  I define the motor vehicles by 
# any EI.Sector description containing the string 'Mobile - On-Road'
Cities <- NEI[NEI$fips %in% c("24510","06037"),]
Cities_SCC <- merge(Cities, SCC, by = "SCC")
Cities_Motor <- Cities_SCC[grepl("Mobile - On-Road", Cities_SCC$EI.Sector),]

# Split the data into groups by (year, EI.Sector, fips) or 
# (year, sector, city) and then sum by groups
cc <- aggregate(x=Cities_Motor$Emissions, 
                by=list(Cities_Motor$year, 
                        Cities_Motor$EI.Sector, 
                        Cities_Motor$fips), 
                FUN="sum")

# Renaming some columns and re-labeling city's by human-readable labels
colnames(cc) <- c("Year", "Sector", "City", "Emissions")
cc$City <- revalue(cc$City, c("24510"="Baltimore", "06037"="Los Angeles"))
cc$Sector <- revalue(cc$Sector, 
                     c("Mobile - On-Road Diesel Heavy Duty Vehicles" = "Diesel Heavy Duty",
                       "Mobile - On-Road Diesel Light Duty Vehicles" = "Diesel Light Duty",
                       "Mobile - On-Road Gasoline Heavy Duty Vehicles" = "Gasoline Heavy Duty",
                       "Mobile - On-Road Gasoline Light Duty Vehicles" = "Gasoline Light Duty"))

# Generate panel plots of Emissions on a log10 scale by year, where each 
# panel represents motor vehicle type. Cities are separated visually by shapes.
g <- qplot(data = cc, x = Year, y = Emissions, color = Sector, shape = City)
g <- g + scale_y_log10()
g <- g + facet_wrap(~City)
g <- g + facet_wrap(~Sector)
g <- g + labs(x="Year", y=expression(paste("Total Emissions (", log[10] ,")")),
              color = "Sector", shape = "City")
g <- g + labs(title = "Total Emissions by On-Road Vehicles")
g <- g + geom_smooth(method = "lm", se = FALSE)
ggsave(filename = "plot6.png", width = 6.5, height = 4.5, dpi = 108)
