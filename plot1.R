library(plyr)

if (!file.exists("Source_Classification_Code.rds")) {
  dataUrl = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
  tmp = tempfile()
  download.file(dataUrl, tmp)
  unzip(tmp)
  unlink(tmp)
}

nei = readRDS("summarySCC_PM25.rds")

emissionSummary = ddply(nei, .(year), summarise, totalEmissions = sum(Emissions))

png("plot1.png")
with(emissionSummary, plot(year, totalEmissions, main = "US PM2.5 Emissions: 1999-2008", xlab = "Year", ylab = "Emissions (tons)", type = "b", col = "red", cex.lab = 1.2, lwd = 3, xaxt = "n"))
axis(side = 1, at = emissionSummary$year)
dev.off()
