library(terra)
library(elevatr)

source('~/Documents/Projects/PRSN/Landslides/_scripts/_func/flow_accumulation.R')

# ctiReclass <- read.csv('~/Documents/Projects/PRSN/Hazus/Data/Tables/cti.csv')
# ctiReclass <- read.csv('~/Documents/Projects/PRSN/Hazus/Data/Tables/cti5.csv')
# slopeReclass <- read.csv('~/Documents/Projects/PRSN/Hazus/Data/Tables/slope.csv',sep='\t')
slopeReclass <- read.csv('~/Documents/Projects/PRSN/Hazus/Data/Tables/slopeNadim.csv')
# dem <- rast('~/Documents/Projects/PRSN/Hazus/Data/Spatial/Raster/demSRTM_30m.tif')
# dem <- rast('~/Documents/Projects/PRSN/Hazus/Data/Spatial/Raster/dem_PR_lowRes.tif')
dem <- rast('/Users/EC13/Documents/Projects/PRSN/Hazus/Data/Spatial/Raster/usgsMerge20m.tif')
# slope <- rast('~/Documents/Projects/PRSN/Hazus/Data/Spatial/Raster/slopeSRTM_30m.tif')
# extent <- rast('~/Documents/Projects/PRSN/Hazus/Data/Spatial/Raster/CCAP_Reclass_PR.tif')
# dem <- get_elev_raster(extent, src='srtm15plus')

# Define flow directions using D8 algorithm
flowDir <- terrain(dem, "flowdir")

# Estimate the flow accumulation
Sys.time()
flowAcc <- flow_accumulation(flowDir)
Sys.time()

# Calculate Slope 
slope <- terrain(dem,'slope') # if not loaded in
slope <- slope$slope * 1
slope$radians <- slope * pi/180
slope$SI <- classify(slope$slope, slopeReclass[1:3])
names(slope) <- c('degrees','radians','SI')

# if the radians is equal to zero, change to second lowest value
if (min(values(slope$radians,na.rm=TRUE)) == 0){
    lowest_two <- sort(unique(values(slope$radians,na.rm=TRUE)))[2]
    slope$radians <- classify(slope$radians,cbind(0,lowest_two))
}

# Calculate Specific Catchment Area (SCA)
sca <- flowAcc / tan(slope$radians)

# Calculate Compound Topographic Index (CTI):
cti <- log(sca)
cti$flowDir <- flowDir
cti$flowAcc <- flowAcc

# remove the rasters
rm(sca, flowDir, flowAcc, dem)


ctiQuantiles <- global(cti[[1]],fun=quantile,na.rm=TRUE)
new_break <- (ctiQuantiles[4] + ctiQuantiles[5]) / 2


CTI.Min <- unlist(c((ctiQuantiles)[1:4],new_break))
CTI.Max <- unlist(c(CTI.Min[-1],ctiQuantiles[5]))

ctiReclass <- data.frame(
  cbind(CTI.Min = c(0,CTI.Min[2:5]),
        CTI.Max = CTI.Max,
        Index = 1:5))

cti$SI <- classify(cti[[1]],ctiReclass)
names(cti) <- c('cti','flowdir','flowacc','SI')

# Save rasters
# writeRaster(dem,'~/Documents/Projects/PRSN/Hazus/Data/Spatial/Raster/dem_PR_lowRes.tif')
# writeRaster(slope,'~/Documents/Projects/PRSN/Hazus/Data/Spatial/Raster/slope_PR_lowRes.tif',
#             overwrite=TRUE)

writeRaster(slope,'~/Documents/Projects/PRSN/Hazus/Data/Spatial/Raster/slope.tif',
             overwrite=TRUE)
writeRaster(cti, "~/Documents/Projects/PRSN/Hazus/Data/Spatial/Raster/cti.tif", 
            overwrite=TRUE)
write.csv(as.data.frame(ctiReclass),'~/Documents/Projects/PRSN/Hazus/Data/Tables/cti5_01m.csv',
          row.names = FALSE)

writeRaster(slope,'~/Documents/Projects/PRSN/Hazus/Data/Spatial/Raster/slope05m.tif',
             overwrite=TRUE)
writeRaster(cti, "~/Documents/Projects/PRSN/Hazus/Data/Spatial/Raster/cti05m.tif", 
            overwrite=TRUE)
write.csv(as.data.frame(ctiReclass),'~/Documents/Projects/PRSN/Hazus/Data/Tables/cti5_05m.csv',
          row.names = FALSE)


writeRaster(slope,'~/Documents/Projects/PRSN/Hazus/Data/Spatial/Raster/slope10m.tif',
             overwrite=TRUE)
writeRaster(cti, "~/Documents/Projects/PRSN/Hazus/Data/Spatial/Raster/cti10m.tif", 
            overwrite=TRUE)
write.csv(as.data.frame(ctiReclass),'~/Documents/Projects/PRSN/Hazus/Data/Tables/cti5_10m.csv',row.names = FALSE)


writeRaster(slope,'~/Documents/Projects/PRSN/Hazus/Data/Spatial/Raster/slope20m.tif',
             overwrite=TRUE)
writeRaster(cti, "~/Documents/Projects/PRSN/Hazus/Data/Spatial/Raster/cti20m.tif", 
            overwrite=TRUE)
write.csv(as.data.frame(ctiReclass),'~/Documents/Projects/PRSN/Hazus/Data/Tables/cti5_20m.csv',row.names = FALSE)

writeRaster(slope,'~/Documents/Projects/PRSN/Hazus/Data/Spatial/Raster/slope30m.tif',
             overwrite=TRUE)
writeRaster(cti, "~/Documents/Projects/PRSN/Hazus/Data/Spatial/Raster/cti30m.tif", 
            overwrite=TRUE)
write.csv(as.data.frame(ctiReclass),'~/Documents/Projects/PRSN/Hazus/Data/Tables/cti5_30m.csv',row.names = FALSE)
