library(terra)

# pgvReclass <- read.csv('~/Documents/Projects/PRSN/Hazus/Data/Tables/pgv.csv')
pgvReclass <- read.csv('~/Documents/Projects/PRSN/Hazus/Data/Tables/pgv5.csv')

pgv <- rast('~/Documents/Projects/PRSN/Hazus/Data/Spatial/Raster/Shakemap/pgv/pgv_grid.tif')

pgv$si.max <- classify(pgv$max,pgvReclass)
pgv$si.median <- classify(pgv$median,pgvReclass)


writeRaster(pgv,'~/Documents/Projects/PRSN/Hazus/Data/Spatial/Raster/Shakemap/pgv/pgv_grid_si.tif',
            overwrite=TRUE)
