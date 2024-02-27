library(terra)

r18 <- rast('C:\\Users\\estudiante\\Documents\\Projects\\Data\\GIS\\Raster\\usgs2018.tif')

r15 <- rast('C:\\Users\\estudiante\\Documents\\Projects\\Data\\GIS\\Raster\\usgs2015.tif')

r15 <- project(r15,r18)

r <- classify(r15,cbind(0,NA))
r <- trim(r)
r2 <- classify(r18,cbind(0,NA))
r2 <- trim(r2)

r <- mask(r,r2,inverse=TRUE)
r <- trim(r)

rm(r18);rm(r15)

writeRaster(r, 'C:\\Users\\estudiante\\Documents\\Projects\\Data\\GIS\\Raster\\usgs2015Mask.tif',
            overwrite=TRUE)
rm(r2)
rm(r15)
r <- merge(r,r18) 
writeRaster(r, 'C:\\Users\\estudiante\\Documents\\Projects\\Data\\GIS\\Raster\\usgs2024.tif',
            overwrite=TRUE)
