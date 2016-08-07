# Find lines that correspond to [1/2/2007, 2/2/2007] date range
text <- readLines("household_power_consumption.txt")
filter_min <- min(grep("1/2/2007", text, fixed = TRUE))
filter_max <- min(grep("3/2/2007", text, fixed = TRUE))

# Read data only within date range [1/2/2007, 2/2/2007]
data <- read.csv("household_power_consumption.txt", na.strings = "?", sep = ";",skip = filter_min, nrows = filter_max - filter_min, header = FALSE)

# Read column names(because if 'nrows' specified read.csv won't see header)
names(data) <- names(read.csv("household_power_consumption.txt", sep = ";", nrows = 1))

# Because filter was rough we need to clean up data
data <- subset(data, Date == "1/2/2007" | Date == "2/2/2007")

# Merge Date and Time columns to DateTime column with type convertion 
data <- within(data, DateTime <- strptime(paste(Date, Time, sep=' '), "%d/%m/%Y %H:%M:%S"))

#plot4
par(mfrow = c(2,2))

plot(data$DateTime,data$Global_active_power, type = "l", ylab="Global Active Power", xlab ="" )

plot(data$DateTime,data$Voltage, type = "l", ylab="Voltage", xlab ="datetime" )

plot(data$DateTime,data$Sub_metering_1, type = "l", ylab="Energy sub metering", xlab ="")
lines(data$DateTime,data$Sub_metering_2, type = "l", col = "red")
lines(data$DateTime,data$Sub_metering_3, type = "l", col = "blue")
legend("topright", c("Sub_metering_1","Sub_metering_2","Sub_metering_3"), col = c("black","red", "blue"), bty = "n", lty = 1, text.width = strwidth("Sub_metering_3"))

plot(data$DateTime,data$Global_reactive_power, type = "l", ylab="Global_reactive_power", xlab ="datetime" )

dev.copy(png, file = "plot4.png")
dev.off()
