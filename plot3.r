### Exploratory Data Analysis Project 2: Plot 3
library(ggplot2)

# read data
NEI <- readRDS("summarySCC_PM25.rds")
NEI$type <- as.factor(NEI$type)
SCC <- readRDS("Source_Classification_Code.rds")
str(NEI)
str(SCC)

# aggregate data by year for Balitmore city
BCNEI <- NEI[NEI$fips == "24510",]
NEIbyYear <- aggregate(Emissions ~ year + type, data=BCNEI, FUN=sum, na.rm=TRUE)

# plot the data
png("plot3.png", width=600)
qplot(x=factor(year), y=Emissions, data=NEIbyYear, geom="bar", fill=type, facets=.~type,
   stat="identity", main="Total Emissions by Source - Baltimore City", xlab="Year",
   ylab=expression(paste("Emissions (tons of ", PM[2.5], ")"))) + guides(fill=FALSE)
graphics.off()