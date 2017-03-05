
# Read in NEI data
subdir <- "exdata_data_NEI_data"
file1 <- "summarySCC_PM25.rds"
file2 <- "Source_Classification_Code.rds"

NEI <- readRDS(paste(subdir, file1, sep="/"))
SCC <- readRDS(paste(subdir, file2, sep="/"))

# Subset the data for Baltimore
baltimore <- NEI[NEI[ , c("fips")] == 24510, ]

# Split the data into levels based on year
splitBaltimore <- split(baltimore$Emissions, baltimore$year)
summedEmissions <- sapply(splitBaltimore, sum)
years = names(summedEmissions)

png(filename = "plot2.png", width = 480, height = 480, units = "px")
plot(years,summedEmissions, pch=19, ylab="Emissions", xlab="year", 
     main = "Total Emissions by Year in Baltimore")
dev.off()