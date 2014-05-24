### Exploratory Data Analysis Project 2: Plot 4

# read data
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")
str(NEI)
str(SCC)

# Determined coal sources based on an inspection of NEI$Short.Name entries that contain
# the word coal.  Lignite also included.  From this inspection, it was decided that the
# combustion sources will contain one of the keywords: [Ff]uel, [Ff]ir[ei], [Bb]urn, [Cc]omb
search1 <- grep("[Cc]oal|[Ll]ignite", SCC$Short.Name)
search2 <- grep("[Ff]uel|[Ff]ir[ei]|[Bb]urn|[Cc]omb", SCC$Short.Name)
combSCC <- SCC$SCC[search1[search1 %in% search2]]
combNEI <- NEI[NEI$SCC %in% combSCC,]

# aggregate data by year for coal combustion sources
NEIbyYear <- tapply(combNEI[,"Emissions"], combNEI$year, sum, na.rm=TRUE)/1e5

# plot the data
png("plot4.png", width=600)
barX <- barplot(height=NEIbyYear,
                col="lightblue",
                border="black",
                main="Total Emissions by Year for Coal Combustion Sources",
                xlab="Year",
                ylab=expression(paste("Total Emissions (tons of ", PM[2.5], ") x ", 10^5, sep="")),
                ylim=c(0,6.2),
                yaxp=c(0,6,6),
                mgp=c(2.5,1,0),
                las=1)
data_labels <- format(NEIbyYear, digits=3, nsmall=2)
text(barX, y=NEIbyYear+par("cxy")[2], data_labels, adj=c(0.5,1))
graphics.off()