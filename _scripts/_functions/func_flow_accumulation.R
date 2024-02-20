library(terra)

flow_accumulation <- function(flowDir, mask = FALSE) {
  # Initialize flow accumulation raster with zeros
  flowAcc <- init(flowDir, 0)
  
  # Convert the flow direction raster to a matrix for faster access
  flowDirMat <- values(flowDir)
  
  # Preallocate a vector to store flow accumulation results
  flowAccVec <- numeric(length(flowDirMat))
  
  # Iterate through each cell only once
  for (i in 1:length(flowDirMat)) {
    # Compute the flow accumulation directly without accessing neighbors each time
    # Note: This assumes flowDirMat contains flow direction as indices to where the flow goes, which is a simplification
    # You may need a custom logic here to determine how flow accumulates based on your specific flow direction representation
    # Get neighbors of current cell
    neighbors <- adjacent(flowDir, i, 8)
    
    neighbors <- c(neighbors)
    
    flowAccVec[i] <- sum(flowDirMat[neighbors],na.rm = TRUE)
  }
  
  # Update the flow accumulation raster with computed values
  values(flowAcc) <- flowAccVec
  
  if (mask) {
    flowAcc <- mask(flowAcc, flowDir)
  }
  
  return(flowAcc)
}



