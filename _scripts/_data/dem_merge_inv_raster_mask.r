library(terra)

pr <- vect('C:\\Users\\estudiante\\Documents\\Projects\\Data\\GIS\\Vector\\base\\PRmain.shp')

r18 <- rast('C:\\Users\\estudiante\\Documents\\Projects\\Data\\GIS\\Raster\\usgs2018.tif')

r15 <- rast('C:\\Users\\estudiante\\Documents\\Projects\\Data\\GIS\\Raster\\usgs2015.tif')

pr <- project(pr,r18)
r15 <- project(r15,r18)

r <- classify(r15,cbind(0,NA))
r <- trim(r)
r2 <- classify(r18,cbind(0,NA))
r2 <- trim(r2)


r <- mask(r,r2,inverse=TRUE)
r <- trim(r)

rm(r15)

writeRaster(r, 'C:\\Users\\estudiante\\Documents\\Projects\\Data\\GIS\\Raster\\usgs2015Mask.tif',
            overwrite=TRUE)
rm(r2)
rm(r15)
r <- merge(r,r18) 
names(r) <- 'elevation'

pr <- buffer(pr,100)
r <- crop(r,pr)

writeRaster(r, 'C:\\Users\\estudiante\\Documents\\Projects\\Data\\GIS\\Raster\\usgs2024.tif',
            overwrite=TRUE)




rFinal <- rast('C:\\Users\\estudiante\\Documents\\Projects\\Data\\GIS\\Raster\\usgs2024.tif')
pr <- project(pr,rFinal)
pr <- buffer(pr,100)
rFinal <- crop(rFinal,pr,ext=TRUE)


r2 <- classify(rFinal,cbind(0,NA))

rSrtm <- rast('C:\\Users\\estudiante\\Documents\\Projects\\Data\\GIS\\Raster\\demSRTM_clip.tif')
rSrtm <- project(rSrtm,r2)
# rSrtm <- crop(rSrtm,r2,ext=TRUE)
# rSrtm <- mask(rSrtm,r2,inverse=TRUE)

r2 <- merge(r2,rSrtm) 
# rm(rFinal)
# rm(rSrtm)
# r2 <- crop(r2,pr)
rm(rSrtm)
rm(rFinal)
r2 <- classify(r2,cbind(NA,0))
r2 <- crop(r2,pr)
writeRaster(r2, 'C:\\Users\\estudiante\\Documents\\Projects\\Data\\GIS\\Raster\\usgs2024_2.tif',
            overwrite=TRUE)
rm(r2)



