

flow_accumulation <- function(flowDir,mask=FALSE){
  # Initialize flow accumulation raster with zeros
  flowAcc <- init(flowDir, 0)
  
  # Iterate through each cell and calculate flow accumulation
  for (i in 1:ncell(flowDir)) {
    # # Get row and column indices of current cell
    # row_col <- xyFromCell(flowDir, i)
  
    # Get neighbors of current cell
    neighbors <- adjacent(flowDir, i, 8)

    neighbors <- c(neighbors)
    
    flowAcc[i] <- sum(flowDir[neighbors],na.rm = TRUE)
  }
  
  if (mask == TRUE){
    flowAcc <- mask(flowAcc,flowDir)  
  }
  
  return(flowAcc)
}

