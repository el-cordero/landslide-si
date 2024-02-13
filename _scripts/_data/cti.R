library(terra)

source('~/Documents/Projects/PRSN/Data/R/Landslides/_scripts/_functions/func_flow_accumulation.R')

dem <- rast('~/Documents/Projects/PRSN/Hazus/Data/Spatial/Raster/dem_PR_lowRes.tif')

# s <- rast(ext=ext(dem),crs=ext(dem),resolution=70)
# dem <- resample(dem,s)
# plot(dem)

# Define flow directions using D8 algorithm
flowDir <- terrain(dem, "flowdir")

flowAcc <- flow_accumulation(flowDir)

# Plot flow accumulation raster
plot(flowAcc, main = "Flow Accumulation")

slope <- terrain(dem,'slope', unit='radians')

sca <- flowAcc / tan(slope)
cti <- log(sca)

breaks <- c(0,5,10,15,20,25,30,35,40,45,50)
cti2 <- classify(cti,breaks)

ctiStack <- c(cti,cti2)
names(ctiStack) <- c('cti','SI')

# Save CTI raster
writeRaster(ctiStack, "~/Documents/Projects/PRSN/Hazus/Data/Spatial/Raster/cti.tif", overwrite=TRUE)
