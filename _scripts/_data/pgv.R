library(terra)

path.in <- '~/Documents/Projects/PRSN/Hazus/Data/Spatial/Vector/'
scenario <- c('1787','1867','1918')
pgvFile <- '_pgv.shp'

maskLayer <- rast('~/Documents/Projects/PRSN/Hazus/Data/Spatial/Raster/CCAP_Reclass_PR.tif')

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
}

pgvRaster$max <- max(pgvRaster[[1]],pgvRaster[[2]],pgvRaster[[3]],na.rm=TRUE)

maskLayer <- project(maskLayer,pgvRaster)
pgvRaster <- mask(pgvRaster,maskLayer)
pgvRaster <- crop(pgvRaster,maskLayer,ext=TRUE)

breaks <- c(0,5,10,15,20,25,30,35,40,45,50)
pgvRaster2 <- classify(pgvRaster,breaks)

names(pgvRaster2) <- paste0('SI.',names(pgvRaster2))
pgvRaster <- c(pgvRaster,pgvRaster2 *1)

writeRaster(pgvRaster,'~/Documents/Projects/PRSN/Hazus/Data/Spatial/Raster/pgv.tif',
            overwrite=TRUE)
