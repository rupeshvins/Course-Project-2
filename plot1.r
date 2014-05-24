### Exploratory Data Analysis Project 2: Plot 1

# read data
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")
str(NEI)
str(SCC)

# aggregate data by year
NEIbyYear <- tapply(NEI[,"Emissions"], NEI$year, sum, na.rm=TRUE)/1e6

# plot the data
png("plot1.png", width=600)
barX <- barplot(height=NEIbyYear,
                col="red",                
                border="black",
                main="Total Emissions by Year",
                xlab="Year",
                ylab=expression(paste("Total Emissions (tons of ", PM[2.5], ") x", 10^6, sep="")),
                ylim=c(0,8),
                yaxp=c(0,8,8),
                mgp=c(2.5,1,0),
                las=1)
data_labels <- format(NEIbyYear, digits=3, nsmall=2)
text(barX, NEIbyYear+par("cxy")[2], data_labels, adj=c(0.5,1))
graphics.off()
