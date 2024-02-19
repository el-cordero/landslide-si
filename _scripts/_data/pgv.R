library(terra)

pgvReclass <- read.csv('~/Documents/Projects/PRSN/Hazus/Data/Tables/cti.csv')

path.in <- '~/Documents/Projects/PRSN/Hazus/Data/Spatial/Vector/'
scenario <- c('1787','1867','1918')
pgvFile <- '_pgv.shp'

maskLayer <- vect('~/Documents/Projects/PRSN/Hazus/Data/Spatial/Vector/Geology/PRgeology.shp')

pgvList <- c()


for (i in 1:length(scenario)){
  print(scenario[i])
  pgv <- vect(paste0(path.in,scenario[i],pgvFile))
  names(pgv) <- toupper(names(pgv))
  pgv <- pgv[,'PARAMVALUE']
  pgvList <- c(pgvList,pgv)
}

pgv <- svc(pgvList)


pgvRaster <- rast(crs=crs(pgv[1]),ext=ext(pgv[1]), nlyr=length(scenario))

for (i in 1:length(scenario)){
  pgvScenarioRaster <- rasterize(pgv[i],pgvRaster, 'PARAMVALUE')
  names(pgvScenarioRaster) <- scenario[i]
  pgvRaster[[i]] <- pgvScenarioRaster
  rm(pgvScenarioRaster)
}

rm(pgv)

pgvRaster$max <- max(pgvRaster[[1]],pgvRaster[[2]],pgvRaster[[3]],na.rm=TRUE)

maskLayer <- project(maskLayer,pgvRaster)
pgvRaster <- crop(pgvRaster,maskLayer,ext=TRUE)



pgvRasterReclass <- classify(pgvRaster,pgvReclass)

names(pgvRasterReclass) <- paste0('SI.',names(pgvRasterReclass))
pgvRaster <- c(pgvRaster,pgvRasterReclass)

rm(pgvRasterReclass)

writeRaster(pgvRaster,'~/Documents/Projects/PRSN/Hazus/Data/Spatial/Raster/pgv.tif',
            overwrite=TRUE)
