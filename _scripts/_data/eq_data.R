library(terra)
library(tidyverse)

source('~/Documents/Projects/PRSN/Landslides/_scripts/_functions/eq_raster_grids.R')

r <- rast('~/Documents/Projects/PRSN/Hazus/Data/Spatial/Raster/demSRTM_30m.tif')

pgv_file_paths <- list.files('~/Documents/Projects/PRSN/Hazus/Data/Spatial/Vector/Shakemap/pgv',
                        full.names = TRUE, pattern = '*json')
pgv_filenames <- list.files('~/Documents/Projects/PRSN/Hazus/Data/Spatial/Vector/Shakemap/pgvShapefiles',
                             pattern = '*.shp')
pgv_out_path <- '~/Documents/Projects/PRSN/Hazus/Data/Spatial/Vector/Shakemap/pgvPolygons/'



eqMax <- init(r,NA)
for (i in 1:length(pgv_file_paths)){
  eqRaster <- rasterize_lines(pgv_file_paths[i],r)
  eqMosaic <- mosaic(eqMosaic,eqRaster,fun='max')
  rm(eqRaster)
  print(i)
  print(pgv_file_paths[i])
}

eqMedian <- init(r,NA)
for (i in 1:length(pgv_file_paths)){
  eqRaster <- rasterize_lines(pgv_file_paths[i],r)
  eqMedian <- mosaic(eqMedian,eqRaster,fun='median')
  rm(eqRaster)
  print(i)
  print(pgv_file_paths[i])
}

pgv <- c(eqMax,eqMedian)
names(pgv) <- c('max','median')

writeRaster(pgv,'/Users/EC13/Documents/Projects/PRSN/Hazus/Data/Spatial/Raster/Shakemap/pgv/pgv_grid.tif',
            overwrite=TRUE)


