library(plyr)
library(ggplot2)

if (!file.exists("Source_Classification_Code.rds") | !file.exists("summarySCC_PM25.rds")) {
  dataUrl = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
  tmp = tempfile()
  download.file(dataUrl, tmp)
  unzip(tmp)
  unlink(tmp)
}

nei = readRDS("summarySCC_PM25.rds")
scc = readRDS("Source_Classification_Code.rds")

scc_motor_vehicle_ids = scc$SCC[grep("^mobile - on-road .* vehicles$", scc$EI.Sector, ignore.case = T)]
mvEmissions = ddply(subset(nei, fips == "24510" & SCC %in% scc_motor_vehicle_ids), .(year), summarize, totalEmissions = sum(Emissions))

png("plot5.png")
p = qplot(year, totalEmissions, data = mvEmissions, geom = "line", main = "Baltimore Motor Vehicle-Related PM2.5 Emissions: 1999-2008", xlab = "Year", ylab = "Emissions (tons)")
p = p + scale_x_continuous(breaks = mvEmissions$year)
print(p)
dev.off()