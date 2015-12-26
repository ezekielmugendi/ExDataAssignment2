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

scc_motor_vehicle_ids = scc$SCC[grep("^mobile - on-road .* vehicles$", scc$EI.Sector, ignore.case = T)]
baltAndLaMvEmissions = ddply(subset(nei, fips == "24510" | fips == "06037" & SCC %in% scc_motor_vehicle_ids), .(year, fips), summarize, totalEmissions = sum(Emissions))

baltAndLaMvEmissions$year = as.factor(baltAndLaMvEmissions$year)
baltAndLaMvEmissions$fips = as.factor(baltAndLaMvEmissions$fips)
levels(baltAndLaMvEmissions$fips) = c("Los Angeles County", "Baltimore City")

# splitEmisisons = split(baltAndLaMvEmissions, baltAndLaMvEmissions$fips)
# baltMvEmissions = splitEmisisons$`24510`
# laMvEmissions = splitEmisisons$`06037`

png("plot6.png")
p = ggplot(baltAndLaMvEmissions, aes(x = year, y = totalEmissions, group = fips, colour = fips))
p = p + geom_line()
p = p + geom_point()
p = p + scale_colour_discrete(name = "Location")
p = p + ggtitle("Motor Vehicle-Related PM2.5 Emissions, LA vs Baltimore")
p = p + xlab("Year")
p = p + ylab("Total PM2.5 Emissions (tons)")
print(p)
dev.off()