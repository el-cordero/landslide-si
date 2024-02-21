library(terra)
library(tidyverse)

line_to_poly <- function(vector.data,write.vector=NA){
  eq <- vect(vector.data)
  eq <- as.polygons(eq)
  if (length(names(eq)) > 0){
    eq <- eq[,1]
    return(eq)
    if (is.na(write.vector) == FALSE){
      writeVector(eq,write.vector,overwrite=TRUE)
    }
  }
  else{
    return(eq)
    print(paste0(vector.data,' could not be converted to polygons'))
  }
}

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


# Define the function
doRasterExtentsOverlap <- function(raster1, raster2) {
  # First, check if the CRS of both rasters match
  if (crs(raster1) != crs(raster2)) {
    stop("The CRS (Coordinate Reference Systems) of the two rasters do not match.")
  }
  
  # Get the extents of both rasters
  ext1 <- ext(raster1)
  ext2 <- ext(raster2)
  
  # Check for overlap between the two extents
  # There is an overlap if the maximum of the minimums is less than the minimum of the maximums for both x and y dimensions
  overlap_x <- max(ext1$xmin, ext2$xmin) < min(ext1$xmax, ext2$xmax)
  overlap_y <- max(ext1$ymin, ext2$ymin) < min(ext1$ymax, ext2$ymax)
  
  # Both x and y dimensions must overlap for the rasters to overlap
  is_overlap <- overlap_x & overlap_y
  
  return(is_overlap)
}

rasterize_lines <- function(vector.data,r){
  vector.data <- line_to_poly(vector.data)
  blankRaster <- init(r,NA)
  names(blankRaster) <- 'value'
  if (length(names(vector.data)) > 0){
    vector.data <- project(vector.data,r)
    if (doRasterExtentsOverlap(vector.data,r)==TRUE){
      baseRaster <- rast(ext=ext(vector.data),crs=crs(r),res=res(r))
      rasterized <- rasterize(vector.data,baseRaster,names(vector.data)[1])
      rasterized <- crop(rasterized,r,ext=TRUE)
      return(rasterized)
    }
    else{
      return(blankRaster)
    }
  }
  else{
    return(blankRaster)
  }
}
