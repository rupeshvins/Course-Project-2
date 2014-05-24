### Exploratory Data Analysis Project 2: Plot 2

# read data
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")
str(NEI)
str(SCC)

# aggregate data by year for Balitmore city
NEIbyYear <- NEI[NEI$fips == "24510",]
NEIbyYear <- tapply(NEIbyYear[,"Emissions"], NEIbyYear$year, sum, na.rm=TRUE)/1e3

# plot the data
png("plot2.png", width=600)
barX <- barplot(height=NEIbyYear,
                col="green",
                border="black",
                main="Total Emissions by Year for Baltimore City",
                xlab="Year",
                ylab=expression(paste("Total Emissions (tons of ", PM[2.5], ") x ", 10^3, sep="")),
                ylim=c(0,3.5),
                yaxp=c(0,3.5,7),
                mgp=c(2.5,1,0),
                las=1)
data_labels <- format(NEIbyYear, digits=3, nsmall=2)
text(barX, NEIbyYear+par("cxy")[2], data_labels, adj=c(0.5,1))
graphics.off()