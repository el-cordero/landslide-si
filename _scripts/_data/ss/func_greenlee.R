# Define a function for Greenlee's algorithm
greenlee <- function(dem) {
  # Create a flow direction raster with the same extent and resolution as the DEM
  flowdir <- rast(ext(dem), nrow=ncol(dem), ncol=nrow(dem), vals=0)
  
  # Iterate through each cell in the DEM
  for (i in 1:ncell(dem)) {
    # Get elevations of neighboring cells
    elevations <- adjacent(dem, i, 8)
    
    # Calculate slope gradients
    slopes <- ( values(dem)[elevations[!is.na(elevations)]] - values(dem)[i]) / res(dem)[1]  # Assuming square cells
    
    # Find the index of the steepest slope
    max_slope_idx <- which.max(slopes)
    
    
    # Set flow direction based on the steepest slope
    flowdir[i] <- flowdir[max_slope_idx]
    
    
    flowdir[1:nrow(x), 1] <- NA
    flowdir[1:nrow(x),ncol(x)] <- NA
    flowdir[1,1:ncol(x)] <- NA
    flowdir[nrow(x),1:ncol(x)] <- NA
  }  
  return(flowdir)
}