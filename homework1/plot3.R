make_plot3 <- function(){
  
  # Read data
  data <- read.csv("household_power_consumption.txt", sep=";", na.strings = "?")
  
  # Convert relevant data
  data["Date"] <- as.Date(data$Date, "%d/%m/%Y")
  data["Sub_metering_1"] <- as.numeric( data$Sub_metering_1 )
  data["Sub_metering_2"] <- as.numeric( data$Sub_metering_2 )
  data["Sub_metering_3"] <- as.numeric( data$Sub_metering_3 )

  # Filter to subset for 2/1/2007 and 2/2/2007
  data <- subset(data, Date >= "2007-02-01" & Date <= "2007-02-02")

  # Merge date and time columns into a datetime object
  data["DateTime"] <- as.POSIXct(paste(data$Date, data$Time), format="%Y-%m-%d %H:%M:%S")
  
  # Generate plot
  png(filename = "plot3.png", width = 480, height = 480, units = "px")
  par(mar = c(3, 4, 4, 2))
  plot(data$Sub_metering_1 ~ data$DateTime, type="n", xlab="", ylab="Energy sub metering")
  lines(data$Sub_metering_1 ~ data$DateTime, lty=1)
  lines(data$Sub_metering_2 ~ data$DateTime, lty=1, col="red")
  lines(data$Sub_metering_3 ~ data$DateTime, lty=1, col="blue")
  legendCols <- c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3")
  legend("topright", lty=1, col = c("black", "red", "blue"), legend = legendCols)
  dev.off()
  
}