library(tools)
library(terra)
library(tidyverse)

pgv_files <- list.files('~/Documents/Projects/PRSN/Hazus/Data/Spatial/Vector/Shakemap/pgv',full.names = TRUE)
pgv_names <- list.files('~/Documents/Projects/PRSN/Hazus/Data/Spatial/Vector/Shakemap/pgv')
pgv_names <- file_path_sans_ext(pgv_names)
pgv_out <- '~/Documents/Projects/PRSN/Hazus/Data/Spatial/Vector/Shakemap/pgvShapefiles/'
r <- rast('~/Documents/Projects/PRSN/Hazus/Data/Spatial/Raster/demSRTM_30m.tif')

for (i in 1:length(pgv_files)){
  eq <- vect(pgv_files[i])
  eq <- as.polygons(eq)
  eq <- project(eq,r)
  names(eq)[1] <- 'value'
  writeVector(eq,paste0(pgv_out,pgv_names[i],'.shp'),overwrite=TRUE)
  rm(eq)
}

get_pgv <- function(pgv_files,pgv_out,pgv_names){
  for (i in 1:length(pgv_files)){
    eq <- vect(pgv_files[i])
    eq <- as.polygons(eq)
    eq <- project(eq,r)
    names(eq)[1] <- 'value'
    writeVector(eq,paste0(pgv_out,pgv_names[i],'.geojson'),overwrite=TRUE)
    rm(eq)
  }
}


get_pgv(pgv_files[1:10],pgv_out,pgv_names[1:10])

