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

#plot1
par(mfrow = c(1,1))

hist(data$Global_active_power, col = "red", main = "Global Active Power", xlab="Global Active Power (kilowatts)")

dev.copy(png, file = "plot1.png")
dev.off()