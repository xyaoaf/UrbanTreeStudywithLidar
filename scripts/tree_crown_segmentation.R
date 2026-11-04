# Input parameters
# 1. Raster (Trees)
# 2. minht

# Import functions
# install.packages("ForestTools")
library(ForestTools)
library(rgdal)
library(raster)

# Input filenames and parameters
canopy_filename <- "data/FHM_Center.tif"  # canopy height model (CHM) raster
output_folder <- "output"
output_name_treetops <- "treetop"
output_name_crowns <- "crowns"
minht <- 10

# Function for tree delineation (Change if needed)
lin <- function(x){x * .05 + 3.5}

##############################################################################################################
# Compute treetops
canopyht <- raster(canopy_filename)
ttops <- vwf(CHM = canopyht, minHeight = minht, minWinNeib = "rook", winFun = lin)
# par(mar = rep(0.5, 4))
plot(canopyht, xlab = "", ylab = "", xaxt='n', yaxt = 'n')
plot(ttops, col="blue", pch=20, cex=0.5, add=TRUE)
writeOGR(ttops, output_folder, output_name_treetops, driver="ESRI Shapefile")

# Compute crowns
crowns <- mcws(treetops = ttops, format = "polygons", CHM = canopyht, minHeight = minht, verbose = FALSE)
plot(canopyht, xlab = "", ylab = "", xaxt='n', yaxt = 'n')
plot(crowns, col="blue", pch=20, cex=0.5, add=TRUE)
writeOGR(crowns, output_folder, output_name_crowns, driver="ESRI Shapefile")


