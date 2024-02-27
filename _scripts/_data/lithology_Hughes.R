library(terra)

lithologyReclass <- read.csv('/Users/EC13/Documents/Projects/PRSN/Hazus/Data/Tables/HughesClassification.csv')
lithology <- rast('/Users/EC13/Documents/Projects/PRSN/Hazus/Data/Spatial/Raster/Hughes GeologicMap/geol_re_utm')

names(lithology) <- 'value'
lithology$SI <- classify(lithology$value,lithologyReclass[,c('Value','Landslide.Susceptibility')])
lithology$NowCoef <- classify(lithology$value,lithologyReclass[,c('Value','NowickiCoef')])
lithology$HughesSI <- classify(lithology$value,lithologyReclass[,c('Value','HughesSI')])

writeRaster(lithology, '/Users/EC13/Documents/Projects/PRSN/Hazus/Data/Spatial/Raster/HughesGeol.tif',
            overwrite=TRUE)


