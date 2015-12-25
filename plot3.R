library(dplyr)

if (!file.exists("Source_Classification_Code.rds") | !file.exists("summarySCC_PM25.rds")) {
  dataUrl = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
  tmp = tempfile()
  download.file(dataUrl, tmp)
  unzip(tmp)
  unlink(tmp)
}

nei = readRDS("summarySCC_PM25.rds")

baltTypeSummary = ddply(subset(nei, fips == "24510"), .(year, type), summarise, totalEmissions = sum(Emissions))

png("plot3.png")
p = qplot(year, totalEmissions, data = baltTypeSummary, geom = "line", main = "Total PM2.5 Emissions In Baltimore City by Year, Type", xlab = "Year", ylab = "Total PM2.5 Emissions (tons)")
p = p + facet_wrap(~type, scales = "free_y")
p = p + scale_x_continuous(breaks = c(1999, 2002, 2005, 2008))
print(p)
dev.off()