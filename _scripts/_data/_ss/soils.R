library(terra)

inputDataPath <- '~/Documents/Projects/PRSN/Hazus/Data/Spatial/Geodatabase/inputData.gdb'

soil.sj <- vect(inputDataPath,layer='soil_sj')
soil.mayaguez <- vect(inputDataPath,layer='soil_mayaguez')


soilTypes <- c(soil.sj$Type,soil.mayaguez$TYPE)
soil.sj$Location <- 'San Juan'
soil.mayaguez$Location <- 'Mayaguez'

soil <- rbind(soil.sj[,'Location'],soil.mayaguez[,'Location'])
soil$Type <- soilTypes

writeVector(soil, '~/Documents/Projects/PRSN/Hazus/Data/Spatial/Vector/PR_soil.shp')
