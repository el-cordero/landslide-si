library(terra)
library(tidyverse)

pgv_files <- list.files('~/Documents/Projects/PRSN/Hazus/Data/Spatial/Vector/Shakemap/pgv',full.names = TRUE)

r <- rast('~/Documents/Projects/PRSN/Hazus/Data/Spatial/Raster/demSRTM_30m.tif')

pgv_outpath <- '/Users/EC13/Documents/Projects/PRSN/Hazus/Data/Spatial/Raster/Shakemap/csv_pgv/'

eq <- vect(pgv_files[1])
eq <- as.polygons(eq)
eq <- project(eq,r)
names(eq)[1] <- 'VALUE'
names(eq)[1]
baseRaster <- rast(ext=ext(eq),crs=crs(r),res=0.01)
eqRaster <- rasterize(eq,baseRaster,names(eq)[1])
eqdf <- as.data.frame(eqRaster,xy=TRUE,na.rm=TRUE)

eq_parameter_rast <- function(eqData,r){#,filepath, datatype){
  # eqdf.all <- data.frame('x'=NA,'y'=NA,'VALUE'=NA)
  eqdf.all <- as.data.frame(init(r,NA),xy=TRUE,na.rm=TRUE)
  names(eqdf.all)[3] <- 'value'
  
  
  for (i in 1:length(eqData)){
    eq <- vect(eqData[i])
    eq <- as.polygons(eq)
    eq <- project(eq,r)
    names(eq)[1] <- 'value'
    baseRaster <- rast(ext=ext(eq),crs=crs(r),res=0.01)
    eqRaster <- rasterize(eq,baseRaster,names(eq)[1])
    eqdf <- as.data.frame(eqRaster,xy=TRUE,na.rm=TRUE)
    
    eqdf.all <- eqdf.all %>%
      left_join(eqdf,by=c("x","y")) %>%
      mutate(value = pmax(value.x, value.y,na.rm=TRUE)) %>%
      select(-c(value.x,value.y))

    rm(eq); rm(eqRaster); rm(baseRaster); rm(eqdf)
  }
  return(eqdf.all)
}

Sys.time()
pgv <- eq_parameter_rast(pgv_files,r)


write.csv(pgv,paste0(pgv_outpath,range(1:5)[1],'to',range(1:5)[2],'pgv.csv'))

pgv <- eq_parameter_rast(pgv_files[1:5],r)
write.csv(pgv,paste0(pgv_outpath,range(1:5)[1],'to',range(1:5)[2],'pgv.csv'))

Sys.time()



#

# Define the function
isRasterWithinAnother <- function(raster1, raster2) {
  # First, check if the CRS of both rasters match
  if (!crs(raster1) == crs(raster2)) {
    stop("The CRS (Coordinate Reference Systems) of the two rasters do not match.")
  }
  
  # Get the extents of both rasters
  ext1 <- ext(raster1)
  ext2 <- ext(raster2)
  
  # Check if raster1 is within raster2 by comparing extents
  is_within <- ext1$xmin >= ext2$xmin & ext1$xmax <= ext2$xmax &
    ext1$ymin >= ext2$ymin & ext1$ymax <= ext2$ymax
  
  return(is_within)
}

isRasterWithinAnother(project(vect(pgv_files[1]),crs(r)),r)














outside_studyArea <- c()
eq_parameter_rast <- function(eqData,r){#,filepath, datatype){
  eqRasterStack <- c()

  for (i in 1:length(eqData)){
    eq <- vect(eqData[i])
    eq <- as.polygons(eq)
    eq <- project(eq,r)
    baseRaster <- rast(ext=ext(eq),crs=crs(r),res=0.01)
    eqRaster <- rasterize(eq,baseRaster,'value')
    eqRasterStack <- c(eqRasterStack,eqRaster)
    rm(eq); rm(eqRaster); rm(baseRaster)
  }
  
  return(eqRasterStack)
  # }
}

pgv <- eq_parameter_rast(pgv_files,r)

eq <- vect(pgv_files[1])
eq <- as.polygons(eq)
eq <- project(eq,r)

baseRaster <- rast(ext=ext(eq),crs=crs(r),res=res(r)*4)

eqRaster <- rasterize(eq,baseRaster,'value')

for (i in 1:length(pgv_files)){
  eq <- vect(pgv_files[i])
  eq <- as.polygons(eq)
  eq <- project(eq,r)
  
  baseRaster <- rast(ext=ext(eq),crs=crs(r),res=0.01)
  eqRaster <- rasterize(eq,baseRaster,'value')
  plot(eqRaster)
  # writeRaster(eqRaster,paste0(pgv_outpath,'pgv','_',i,'.tif'),overwrite=TRUE)
  # # eqRasterStack <- mosaic(eqRasterStack,eqRaster,fun='max')
  # rm(eq); rm(eqRaster); rm(baseRaster)
}

eq <- vect(pgv_files[6])
eq <- as.polygons(eq)
eq <- project(eq,r)

baseRaster <- rast(ext=ext(eq),crs=crs(r),res=0.01)
eqRaster <- rasterize(eq,baseRaster,'value')
plot(eqRaster)

Sys.time()
pgv <- eq_parameter_rast(pgv_files,r,pgv_outpath,'pgv')
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


