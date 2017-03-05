library(ggplot2)
library(plyr)

# Read in NEI data
subdir <- "exdata_data_NEI_data"
file1 <- "summarySCC_PM25.rds"
file2 <- "Source_Classification_Code.rds"
#NEI <- readRDS( paste( subdir, file1, sep = "/" ) ) 
#SCC <- readRDS( paste( subdir, file2, sep = "/" ) )

# Subset the data for Baltimore
baltimore <- NEI[ NEI$fips == 24510, ]

# Split the data into groups of (type, year)
YTBaltimore = aggregate( x = baltimore$Emissions,
                         by = list( baltimore$year, baltimore$type ), 
                         FUN = "sum" )
colnames(YTBaltimore) <- c( "Year", "Type", "Emissions" )
YTBaltimore$Type <- revalue( YTBaltimore$Type, 
                               c( "NON-ROAD" = "Non-Road",
                                  "NONPOINT" = "Nonpoint",
                                  "ON-ROAD" = "On-Road",
                                  "POINT" = "Point") )

# Generate the plot
g <- qplot(YTBaltimore$Year, YTBaltimore$Emissions, color=YTBaltimore$Type)
g <- g + scale_y_log10()
g <- g + labs(x="Year", y=expression(paste("Total Emissions (", log[10] ,")")), color = "Emissions Type" )
g <- g + labs(title = "Annual Emissions in Baltimore")
g <- g + geom_smooth(method = "lm", se = FALSE)
ggsave( filename = "plot3.png", width = 5, height = 4, dpi = 108 )
