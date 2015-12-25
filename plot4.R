library(dplyr)
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

scc_coal_ids = scc$SCC[grep("^fuel comb -.*- coal$", scc$EI.Sector, ignore.case = TRUE)]
coalEmissions = ddply(subset(nei, SCC %in% scc_coal_ids), .(year), summarize, totalEmissions = sum(Emissions))

png("plot4.png")
p = qplot(year, totalEmissions, data = coalEmissions, geom = "line", main = "Total Coal Combustion-Related PM2.5 Emissions by Year", xlab = "Year", ylab = "Total PM2.5 Emissions (tons)")
p = p + scale_x_continuous(breaks = coalEmissions$year)
print(p)
dev.off()