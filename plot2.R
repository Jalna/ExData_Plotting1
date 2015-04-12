# Data source description:
# - provider: UC Irvine Machine Learning Repository
# - content: Individual household electric power consumption data set
# - last modification: 16-Oct-2012 11:06
# - size: 20M
# - zip file (size 20 Mb) named:
zipFileName <- "household_power_consumption.zip"
# - is available at:
zipFilePath <- "https://archive.ics.uci.edu/ml/machine-learning-databases/00235/"
# - and contains a text file named:
txtFileName <- "household_power_consumption.txt"

# Load the data from UCI repository if not available in the working directory:
if(!file.exists(txtFileName)) {
        if(!file.exists(zipFileName)) {
                download.file(paste(zipFilePath,zipFileName,sep=""),zipFileName) 
        }
        unzip(zipFileName)
        file.remove(zipFileName)
}
fileUrl <- txtFileName

# The dataset is very large but only specific rows (having dates 2007-02-01 and 
# 2007-02-02) are to be retrieved.
# Read the first row to retrieve the column names 
df.row1 <- read.table(fileUrl, header = TRUE, sep=";",nrows=1)
df.colnames <- colnames(df.row1)
# Read all rows but with just the 1st column which is the date
df.date <- read.table(fileUrl, header = TRUE, sep=";",as.is=TRUE, 
                      colClasses = c(NA, rep("NULL",8)))
# Retrieve the index of consecutives rows having the requested dates:
df.index <- which(df.date=="1/2/2007" | df.date=="2/2/2007")
# Retrieve the data frame for the requested index only:
df <- read.table(fileUrl, header = TRUE, sep=";",col.names=df.colnames,
                 na.strings="?", skip = df.index[1]-1, nrows=length(df.index))
# Create a DateTime variable from the Date and Time variables:
df$DateTime <- strptime(paste(df$Date,df$Time),"%d/%m/%Y %H:%M:%S")

# Select the png graphics device
png(filename = "plot2.png")
# Create the requested plot
plot(df$DateTime,df$Global_active_power, type="l",main = "",
     xlab = "", ylab = "Global Active Power (kilowatts)")
# Shut down the png device
dev.off()
### End Of File ###