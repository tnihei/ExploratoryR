make_plot1 <- function(){

  # Read data
  data <- read.csv("household_power_consumption.txt", sep=";", na.strings = "?")

  # Convert relevant data
  data["Date"] <- as.Date(data$Date, "%d/%m/%Y")
  data["Global_active_power"] <- as.numeric(data$Global_active_power)
 
  # Filter to subset for 2/1/2007 and 2/2/2007
  data <- subset(data, Date >= "2007-02-01" & Date <= "2007-02-02")
  
  # Generate plot
  png(filename = "plot1.png", width = 480, height = 480, units = "px")
  hist(data$Global_active_power, breaks=11, col="red", xlab="Global Active Power (kilowatts)", main="Global Active Power")
  dev.off()

}