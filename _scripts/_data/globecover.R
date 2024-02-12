library(terra)

lc <- rast('~/Documents/Projects/PRSN/Hazus/Data/Spatial/Raster/Globcover2009_V2/GLOBCOVER_L4_200901_200912_V2.3.tif')

maskLyr <- vect('~/Documents/Projects/PRSN/Hazus/Data/Spatial/Vector/Geology/PRgeology.shp')

maskLyr <- project(maskLyr,lc)
maskLyr <- aggregate(maskLyr)
maskLyr <- buffer(maskLyr,1000)

lc <- crop(lc,maskLyr,ext=TRUE)

writeRaster(lc,'~/Documents/Projects/PRSN/Hazus/Data/Spatial/Raster/Globcover2009_PR.tif')


