library(terra)

lithologyReclass <- read.csv('/Users/EC13/Documents/Projects/PRSN/Hazus/Data/Tables/HughesClassification.csv')
lithology <- rast('/Users/EC13/Documents/Projects/PRSN/Hazus/Data/Spatial/Raster/geol_re_utm')

lithology <- project(lithology, 'EPSG:26920',method='near')

names(lithology) <- 'hughes'
lithology$SI <- classify(lithology$hughes,lithologyReclass[,c('Value','Landslide.Susceptibility')])
lithology$NowCoef <- classify(lithology$hughes,lithologyReclass[,c('Value','NowickiCoef')])
# lithology$HughesSI <- classify(lithology$value,lithologyReclass[,c('Value','HughesSI')])

writeRaster(lithology, '/Users/EC13/Documents/Projects/PRSN/Hazus/Data/Spatial/Raster/lithology.tif',
            overwrite=TRUE)
