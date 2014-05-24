### Exploratory Data Analysis Project 2: Plot 6

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
BCmotVehNEI <- motVehNEI[motVehNEI$fips == "24510",]     # data for Baltimore City
LAmotVehNEI <- motVehNEI[motVehNEI$fips == "06037",]     # data for Los Angeles

# aggregate data by year for motor vehicle sources
BCNEIbyYear <- tapply(BCmotVehNEI[,"Emissions"], BCmotVehNEI$year, sum, na.rm=TRUE)/1e3
LANEIbyYear <- tapply(LAmotVehNEI[,"Emissions"], LAmotVehNEI$year, sum, na.rm=TRUE)/1e3

# plot the data
png("plot6.png", width=600)
plot(1:4, LANEIbyYear,
     type="n",
     ann=FALSE,
     frame.plot=TRUE,
     axes=FALSE,
     ylim=c(0,5))
title(main="Total Motor Vehicle Emissions by Year")
axis(1, at=1:4, labels=names(BCNEIbyYear))
title(xlab="Year")
axis(2, at=seq(0,5,0.5), las=1)
title(ylab=expression(paste("Total Emissions (tons of ", PM[2.5], ") x ", 10^3, sep="")),
   mgp=c(2.5,1,0))
lines(1:4, BCNEIbyYear, type="b", col="red", lwd=1.5, pch=18, cex=1.25)
BCdata_labels <- format(BCNEIbyYear, digits=2, nsmall=2)
text(1:4, y=BCNEIbyYear+par("cxy")[2], BCdata_labels, adj=c(0.5,1), cex=0.8)
lines(1:4, LANEIbyYear, type="b", col="blue", lwd=1.5, pch=18, cex=1.25)
LAdata_labels <- format(LANEIbyYear, digits=2, nsmall=2)
text(1:4, y=LANEIbyYear+par("cxy")[2], LAdata_labels, adj=c(0.5,1), cex=0.8)
legend("center", legend=c("Los Angeles County","Baltimore City"), col=c("blue","red"),
   bty="n", pt.bg="white", pch=18, lty=1, lwd=1.5, inset=0.02, pt.cex=1.25, cex=1.1)
graphics.off()