library(terra)

lc <- rast('~/Documents/Projects/PRSN/Hazus/Data/Spatial/Raster/CCAP/pr_2010_ccap_hr_land_cover20170214.img')
tbReclass <- read.csv('~/Documents/Projects/PRSN/Hazus/Data/Tables/ccapClassification.csv')

# remove levels because this will increase the size of the dataset
levels(lc) <- NULL

# reproject to NAD83 / UTM zone 20N (EPSG:26920)
lc <- project(lc, 'EPSG:26920',method='near')

names(lc) <- 'CCAP'

# reclassify to globcover, SI, and nowicki coefficient
lc$Globcover <- classify(lc,tbReclass[,c('CCAP.Value','GlobCover.Value')])
lc$SI <- classify(lc,tbReclass[,c('CCAP.Value','SI_0to5')])
lc$NowCoef <- classify(lc,tbReclass[,c('CCAP.Value','Nowicki.Coef')])

# lvls <- tbReclass[!duplicated(tbReclass[c('GlobCover.Value')]), 
#                   c('GlobCover.Value',"Globcover.Class.Description")]
# lvls <- lvls[!is.na(lvls$Globcover.Class.Description),]
# levels(lcReclass) <- lvls


writeRaster(lc,'~/Documents/Projects/PRSN/Hazus/Data/Spatial/Raster/CCAP_Reclass_PR.tif',
            overwrite=TRUE)

rm(lc)
