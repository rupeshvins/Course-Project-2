### Exploratory Data Analysis Project 2: Plot 5

# read data
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")
str(NEI)
str(SCC)

# Determined motor vehicle sources based on following search and inspection of created file.
# Most sources were either highway or off-highway vehicles.  Indirect sources not related to
# actual motor emissions were excluded, as well as very specialized sources such as traffic
# due to iron ore mining on site.  Thus, based on examination of the created file,
# indices 1158:1163 and 1168:1360 of the search were excluded from sources.  The search
# catches all of the ON-ROAD sources as well as 71593 NON-ROAD sources.  Only 33 "others"
# are included.
search1 <- grep("[Mm]otor [Vv]eh|[Vv]eh|^[Bb]us|[ ][Bb]us|[Mm]otorcycle|[Tt]ruck", SCC$Short.Name, value=TRUE)
cat(search1, file="vehiclelist.txt", sep="\n")

# extract relevant data
search1 <- grep("[Mm]otor [Vv]eh|[Vv]eh|^[Bb]us|[ ][Bb]us|[Mm]otorcycle|[Tt]ruck", SCC$Short.Name)
index <- search1[-c(1158:1163,1168:1360)]
motVehSCC <- SCC$SCC[index]
motVehNEI <- NEI[NEI$SCC %in% motVehSCC,]
motVehNEI <- motVehNEI[motVehNEI$fips == "24510",]    # data for Baltimore City

# aggregate data by year for motor vehicle sources
NEIbyYear <- tapply(motVehNEI[,"Emissions"], motVehNEI$year, sum, na.rm=TRUE)

# plot the data
png("plot5.png", width=600)
barX <- barplot(height=NEIbyYear,
                col="hotpink",
                border="black",
                main="Total Motor Vehicle Emissions by Year for Baltimore City",
                xlab="Year",
                ylab=expression(paste("Total Emissions (tons of ", PM[2.5], ")", sep="")),
                ylim=c(0,400),
                yaxp=c(0,400,8),
                mgp=c(2.5,1,0),
                las=1)
data_labels <- format(NEIbyYear, digits=3, nsmall=1)
text(barX, y=NEIbyYear+par("cxy")[2], data_labels, adj=c(0.5,1))
graphics.off()