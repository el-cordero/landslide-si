library(terra)

lc <- rast('~/Documents/Projects/PRSN/Hazus/Data/Spatial/Raster/CCAP/pr_2010_ccap_hr_land_cover20170214.img')
tbReclass <- read.csv('~/Documents/Projects/PRSN/Hazus/Data/Tables/ccapClassification.csv')


s <- rast(ext=ext(lc),crs=crs(lc),resolution=150)
lc <- resample(lc,s)

lcReclass <- classify(lc,tbReclass[,c('CCAP.Value','GlobCover.Value')])
lcSI <- classify(lc,tbReclass[,c('CCAP.Value','Landslide.SI')])
lcCoef <- classify(lc,tbReclass[,c('CCAP.Value','Nowicki.Coef')])

lvls <- tbReclass[!duplicated(tbReclass[c('GlobCover.Value')]), 
                  c('GlobCover.Value',"Globcover.Class.Description")]
lvls <- lvls[!is.na(lvls$Globcover.Class.Description),]
levels(lcReclass) <- lvls

lcReclass <- c(lcReclass,lcSI,lcCoef)
names(lcReclass) <- c('Globcover.Desc','SI','Nowicki.Coef')

writeRaster(lcReclass,'~/Documents/Projects/PRSN/Hazus/Data/Spatial/Raster/CCAP_Reclass_PR.tif',
            overwrite=TRUE)


