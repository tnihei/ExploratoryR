subdir <- "exdata_data_NEI_data"
file1 <- "summarySCC_PM25.rds"
file2 <- "Source_Classification_Code.rds"

NEI <- readRDS(paste(subdir, file1, sep="/"))
SCC <- readRDS(paste(subdir, file2, sep="/"))

splitNEI <- split(NEI$Emissions, NEI$year)
summedEmissions <- sapply(splitNEI, sum)
years = names(summedEmissions)

png(filename = "plot1.png", width = 480, height = 480, units = "px")
plot(years,summedEmissions, pch=19, ylab="Emissions", xlab="year", 
     main = "Total Emissions by Year")
dev.off()