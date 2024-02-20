library(terra)

pgv_files <- list.files('~/Documents/Projects/PRSN/Hazus/Data/Spatial/Vector/Shakemap/pgv',full.names = TRUE)

r <- rast('~/Documents/Projects/PRSN/Hazus/Data/Spatial/Raster/demSRTM_30m.tif')

pgv_outpath <- '/Users/EC13/Documents/Projects/PRSN/Hazus/Data/Spatial/Raster/Shakemap/pgv/'

eq_parameter_rast <- function(eqData,r,filepath, datatype){
  # eqRasterStack <- c()
  for (i in 1:length(eqData)){
    eq <- vect(eqData[i])
    eq <- as.polygons(eq)
    eq <- project(eq,r)

    eqRaster <- rast(ext=ext(eq),crs=crs(r),res=res(r))

    eqRaster <- rasterize(eq,eqRaster,'value')
    
    # writeRaster(eqRaster,paste0(filepath,datatype,'_',i,'.tif'),overwrite=TRUE)
    
    # eqRasterStack <- c(eqRasterStack,eqRaster)
    # rm(eqRaster)
    print(eqData[i])
  }
  
  # return(eqRasterStack)
  
  # }
}




Sys.time()
eq_parameter_rast(pgv_files,r,pgv_outpath,'pgv')
Sys.time()

eqRasterStack <- sprc(eqRasterStack)

eqData <- pgv_files[1]
eqRasterStack <- c()
for (i in 1:length(eqData)){
  eq <- vect(eqData[i])
  eq <- as.polygons(eq)
  eq <- project(eq,r)
  eqRaster <- rast(ext=ext(eq),crs=crs(r),res=res(r))
  eqRaster <- rasterize(eq,eqRaster,'value')
  eqRasterStack <- c(eqRasterStack,eqRaster)
  rm(eqRaster)
}


