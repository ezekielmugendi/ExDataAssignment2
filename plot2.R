library(dplyr)

if (!file.exists("Source_Classification_Code.rds") | !file.exists("summarySCC_PM25.rds")) {
  dataUrl = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
  tmp = tempfile()
  download.file(dataUrl, tmp)
  unzip(tmp)
  unlink(tmp)
}

nei = readRDS("summarySCC_PM25.rds")

baltSummary = ddply(subset(nei, fips == "24510"), .(year), summarise, totalEmissions = sum(Emissions))

png("plot2.png")
with(baltSummary, plot(year, totalEmissions, type = "l", main = "Total PM2.5 Emissions In Baltimore City by Year", xlab = "Year", ylab = "Total PM2.5 Emissions (tons)", col = "red", cex.lab = 1.2, lwd = 3, xaxt = "n"))
axis(side = 1, at = baltSummary$year)
dev.off()