library(rgee)
library(terra)

# upgrade rgee if required
rgee::ee_install_upgrade()

# Initialize just Earth Engine
ee_clean_user_credentials()
ee_Authenticate()
ee_Initialize(drive = TRUE)
# Earth Engine account: users/ecordero 
# Python Path: /Users/EC13/.virtualenvs/rgee/bin/python 

# AOI
aoi <- vect('~/Documents/Projects/PRSN/Hazus/Data/Spatial/Vector/Geology/PRgeology.shp')
aoi <- ee$Geometry$Rectangle(c(xmin(aoi),ymin(aoi),xmax(aoi),ymax(aoi)))

# extract elevation data
elevation <- ee$Image('USGS/SRTMGL1_003') %>%
  ee$Image$select('elevation')

flowAcc <- ee$Terrain$flowAccumulation(elevation)

# calculate slope and clip to aoi extent
slope <- ee$Terrain$slope(elevation) %>% ee$Image$clip(aoi)

# clip elevation to aoi extent
elevation <- elevation %>% ee$Image$clip(aoi)

# set visualization parameters
elevationVis = list(min = 0, max = 4000)
slopeVis = list(min = 0, max = 60)

# view data
Map$centerObject(elevation)
Map$addLayer(elevation, elevationVis,'Elevation')
Map$addLayer(slope, slopeVis, 'slope')

# export elevation data to file
elevationFile <- '~/Documents/Projects/PRSN/Hazus/Data/Spatial/Raster/demSRTM_30m.tif'
elevation <- ee_as_rast(elevation,region=aoi,dsn=elevationFile)

# export elevation data to file
slopeFile <- '~/Documents/Projects/PRSN/Hazus/Data/Spatial/Raster/slopeSRTM_30m.tif'
slope <- ee_as_rast(slope,region=aoi,dsn=slopeFile)

# remove temp files
rm(elevation)
rm(slope)



