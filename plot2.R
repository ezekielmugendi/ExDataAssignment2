library(plyr)

if (!file.exists("Source_Classification_Code.rds")) {
  dataUrl = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
  tmp = tempfile()
  download.file(dataUrl, tmp)
  unzip(tmp)
  unlink(tmp)
}

nei = readRDS("summarySCC_PM25.rds")

baltSummary = ddply(subset(nei, fips == "24510"), .(year), summarise, totalEmissions = sum(Emissions))

png("plot2.png")
with(baltSummary, plot(year, totalEmissions, type = "b", main = "Baltimore PM2.5 Emissions: 1999-2008", xlab = "Year", ylab = "Emissions (tons)", col = "red", cex.lab = 1.2, lwd = 3, xaxt = "n"))
axis(side = 1, at = baltSummary$year)
dev.off()