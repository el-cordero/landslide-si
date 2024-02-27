library(terra)

siReclass <- read.csv('~/Documents/Projects/PRSN/Hazus/Data/Tables/si.csv')
pgv <- rast('~/Documents/Projects/PRSN/Hazus/Data/Spatial/Raster/Shakemap/pgv/pgv_grid_si.tif')
lc <- rast('~/Documents/Projects/PRSN/Hazus/Data/Spatial/Raster/CCAP_Reclass_PR.tif')
slope <- rast('~/Documents/Projects/PRSN/Hazus/Data/Spatial/Raster/slope_PR_lowRes.tif')
cti <- rast('~/Documents/Projects/PRSN/Hazus/Data/Spatial/Raster/cti.tif')
lithology <- rast('~/Documents/Projects/PRSN/Hazus/Data/Spatial/Raster/HughesGeol.tif')

lc <- project(lc,slope)
lc <- resample(lc,slope)

pgv <- project(pgv,slope)
pgv <- resample(pgv,slope)

lithology <- project(lithology,slope)
lithology <- resample(lithology,slope)


si <- -6.30 + 1.65 * log(pgv$si.max) + 0.06 * slope$SI + 
  lithology$NowCoef * lithology$SI + lc$SI * lc$Nowicki.Coef + 
  0.03 * cti$SI + 0.01 * log(pgv$si.max) * slope$SI

si <- -6.30 + 1.65 * log(pgv$si.max) + 0.06 * slope$SI + 
  lithology$HughesSI * lithology$SI + lc$SI * lc$Nowicki.Coef + 
  0.03 * cti$SI + 0.01 * log(pgv$si.max) * slope$SI

si$probability <- 1 / (1 + exp(-si))
si$classified <- classify(si$probability,siReclass)
si$classified0to5 <- round((si$classified / 2) + 0.01)
unique(values(si$classified0to5,na.rm=TRUE))

writeRaster(si,'~/Documents/Projects/PRSN/Hazus/Data/Spatial/Raster/landslide_probability.tif',
            overwrite=TRUE)

