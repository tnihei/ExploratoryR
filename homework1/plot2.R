make_plot2 <- function(){
  
  # Read data
  data <- read.csv("household_power_consumption.txt", sep=";", na.strings = "?")
  
  # Convert relevant data
  data["Date"] <- as.Date(data$Date, "%d/%m/%Y")
  data["Global_active_power"] <- as.numeric(data$Global_active_power)
  
  # Filter to subset for 2/1/2007 and 2/2/2007
  data <- subset(data, Date >= "2007-02-01" & Date <= "2007-02-02")

  # Merge date and time columns into a datetime object
  data["DateTime"] <- as.POSIXct(paste(data$Date, data$Time), format="%Y-%m-%d %H:%M:%S")
  
  # Generate plot
  png(filename = "plot2.png", width = 480, height = 480, units = "px")
  par(mar = c(3, 4, 4, 2))
  plot(data$Global_active_power ~ data$DateTime, type="n", xlab="", ylab="Global Active Power (kilowatts)")
  lines(data$Global_active_power ~ data$DateTime, lty=1)
  dev.off()
  
}