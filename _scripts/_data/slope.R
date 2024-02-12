library(terra)
library(elevatr)

source('~/Documents/Projects/PRSN/Data/R/Hazus/_scripts/_data/func_reclass_nadim.R')

extent <- rast('~/Documents/Projects/PRSN/Hazus/Data/Spatial/Raster/CCAP_Reclass_PR.tif')

# dem <- get_elev_raster(extent, src='srtm15plus')
dem <- rast('~/Documents/Projects/PRSN/Hazus/Data/Spatial/Raster/dem_PR_lowRes.tif')
slope <- terrain(dem,'slope')

slope <- project(slope,extent)
slope <- mask(slope,extent)

breaks <- c(0,1,8,16,32)

slope2 <- classify(slope,breaks)

slope2 <- slope2 * 2

slopeRaster <- c(slope[[1]],slope2[[1]])
names(slopeRaster) <- c('Slope','SI')

writeRaster(dem,'~/Documents/Projects/PRSN/Hazus/Data/Spatial/Raster/dem_PR_lowRes.tif')
writeRaster(slopeRaster,'~/Documents/Projects/PRSN/Hazus/Data/Spatial/Raster/slope_PR_lowRes.tif',
            overwrite=TRUE)
