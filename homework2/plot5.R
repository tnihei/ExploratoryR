library(ggplot2)
library(plyr)

# Read in NEI data
subdir <- "exdata_data_NEI_data"
file1 <- "summarySCC_PM25.rds"
file2 <- "Source_Classification_Code.rds"
#NEI <- readRDS( paste( subdir, file1, sep = "/" ) )
#SCC <- readRDS( paste( subdir, file2, sep = "/" ) )

# Subset the data for Baltimore and Motor Vehicles, and then
# merge the data
City <- NEI[ NEI$fips == 24510, ]
City_SCC <- merge( City, SCC, by = "SCC" )
City_Motor <- City_SCC[ grepl( "Mobile - On-Road", City_SCC$EI.Sector ), ]

# Split the data into groups of (year, sector)
cc <- aggregate( x = City_Motor$Emissions,
                 by = list( City_Motor$year, City_Motor$EI.Sector ), 
                 FUN = "sum" )

# Renaming some columns and re-labeling city's by human-readable labels
colnames( cc ) <- c( "Year", "Sector", "Emissions" )
cc$Sector <- revalue(cc$Sector, 
                     c("Mobile - On-Road Diesel Heavy Duty Vehicles" = "Diesel Heavy Duty",
                       "Mobile - On-Road Diesel Light Duty Vehicles" = "Diesel Light Duty",
                       "Mobile - On-Road Gasoline Heavy Duty Vehicles" = "Gasoline Heavy Duty",
                       "Mobile - On-Road Gasoline Light Duty Vehicles" = "Gasoline Light Duty"))

# Generate the plot
g <- qplot(cc$Year, cc$Emissions, color=cc$Sector)
g <- g + scale_y_log10()
g <- g + labs(x="Year", y=expression(paste("Total Emissions (", log[10] ,")")),
              color = "Industry Sector")
g <- g + labs(title = "Total Emissions by On-Road Vehicles For Baltimore")
g <- g + geom_smooth(method = "lm", se = FALSE)
ggsave(filename = "plot5.png", width = 7, height = 4, dpi = 108)
