library(ggplot2)
library(plyr)

# Read in NEI data
subdir <- "exdata_data_NEI_data"
file1 <- "summarySCC_PM25.rds"
file2 <- "Source_Classification_Code.rds"
#NEI <- readRDS(paste(subdir, file1, sep="/"))
#SCC <- readRDS(paste(subdir, file2, sep="/"))
#NEI_SCC <- merge(NEI, SCC, by = "SCC")

# Subset the data for CoalCombustion
CoalCombustion <- NEI_SCC[grepl("Coal", NEI_SCC$EI.Sector),]

# Split the data into groups of (year, sector)
cc= aggregate(x = CoalCombustion$Emissions,
              by = list(CoalCombustion$year, CoalCombustion$EI.Sector), 
              FUN = "sum")
colnames(cc) <- c("Year", "Sector", "Emissions")
cc$Sector <- revalue(cc$Sector, 
                     c("Fuel Comb - Electric Generation - Coal" = "Electric Generation",
                       "Fuel Comb - Industrial Boilers, ICEs - Coal" = "Industrial Boilers, ICEs",
                       "Fuel Comb - Comm/Institutional - Coal" = "Comm/Institutional"))


# Generate the plot
g <- qplot(cc$Year, cc$Emissions, color=cc$Sector)
g <- g + scale_y_log10()
g <- g + labs(x="Year", y=expression(paste("Total Emissions (", log[10] ,")")),
              color = "Industry Sector")
g <- g + labs(title = "Total Emissions by Coal Combustion")
g <- g + geom_smooth(method = "lm", se = FALSE)
ggsave(filename = "plot4.png", width = 7, height = 4, dpi = 108)