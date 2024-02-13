library(terra)

pgv <- rast('~/Documents/Projects/PRSN/Hazus/Data/Spatial/Raster/pgv.tif')
lc <- rast('~/Documents/Projects/PRSN/Hazus/Data/Spatial/Raster/CCAP_Reclass_PR.tif')
slope <- rast('~/Documents/Projects/PRSN/Hazus/Data/Spatial/Raster/slope_PR_lowRes.tif')
cti <- rast('~/Documents/Projects/PRSN/Hazus/Data/Spatial/Raster/cti.tif')
lithology <- vect('~/Documents/Projects/PRSN/Hazus/Data/Spatial/Vector/Geology/PRgeology.shp')

lithology <- project(lithology,lc)
lc <- crop(lc,lithology,ext=TRUE)

lithology$SI <- lithology$Landslide. * lithology$Nowicki.Co
lithoRaster <- rasterize(lithology,lc,'SI')


pgv <- project(pgv,lithoRaster)
pgv <- resample(pgv,lithoRaster)

slope <- project(slope,lithoRaster)
slope <- resample(slope,lithoRaster)

cti <- project(cti,lithoRaster)
cti <- resample(cti, lithoRaster)



si <- -6.30 + 1.65 * log(pgv$SI.max) + 0.06 * slope$SI + lithoRaster$SI + (lc$SI * lc$Nowicki.Coef) + 
  0.03 * cti$SI + 0.01 * log(pgv$SI.max) * slope$SI

rg <- range(values(si,na.rm=TRUE))
seq(-40,5,5)
breaks <- seq(-40,5,5)
si2 <- classify(si,breaks)
si <- c(si,si2)

names(si) <- c('si','si.reclass')

writeRaster(si,'~/Documents/Projects/PRSN/Hazus/Data/Spatial/Raster/landslide_si.tif',
            overwrite=TRUE)

# si <- rast('~/Documents/Projects/PRSN/Hazus/Data/Spatial/Raster/landslide_si.tif')
