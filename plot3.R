library(plyr)
library(ggplot2)

if (!file.exists("Source_Classification_Code.rds")) {
  dataUrl = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
  tmp = tempfile()
  download.file(dataUrl, tmp)
  unzip(tmp)
  unlink(tmp)
}

nei = readRDS("summarySCC_PM25.rds")

baltTypeSummary = ddply(subset(nei, fips == "24510"), .(year, type), summarise, totalEmissions = sum(Emissions))

png("plot3.png")
p = qplot(year, totalEmissions, data = baltTypeSummary, geom = "line", main = "Baltimore PM2.5 Emissions by Type: 1999-2008", xlab = "Year", ylab = "Emissions (tons)")
p = p + geom_point()
p = p + facet_wrap(~type, scales = "free_y")
p = p + scale_x_continuous(breaks = c(1999, 2002, 2005, 2008))
print(p)
dev.off()