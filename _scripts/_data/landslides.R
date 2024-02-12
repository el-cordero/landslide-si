library(terra)

inputDataPath <- '~/Documents/Projects/PRSN/Hazus/Data/Spatial/Geodatabase/inputData.gdb'

ls.sj <- vect(inputDataPath,layer='landslide_sj')
ls.m <- vect('~/Documents/Projects/PRSN/Hazus/Data/Spatial/Vector/landslide_mayaguez.shp')

ls.sj[ls.sj$Susc == "NONE", 'Susc'] <- NA

ls.sj$Location <- 'San Juan'; ls.m$Location <- 'Mayaguez'

landslides <- rbind(ls.sj[,'Location'],ls.m[,'Location'])

landslides$Susceptibility <- c(ls.sj$Susc,ls.m$risk_lev)
landslides$Type <- c(ls.sj$Type,ls.m$TYPE)

writeVector(landslides, '~/Documents/Projects/PRSN/Hazus/Data/Spatial/Vector/PR_landslides.shp',
            overwrite=TRUE)
