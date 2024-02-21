library(terra)


obs <- vect('/Users/EC13/Documents/Projects/PRSN/Hazus/Data/Spatial/Vector/Ground Deformation/PR2020_observation_data/Shapefile/PR_observation_pts.shp')

unique(obs$gf_type)
# gf <- c("Lateral spread","Coherent slides","Disrupted slides and falls")
gf <- c("Coherent slides","Disrupted slides and falls")
obs <- obs[obs$gf_type %in% gf,]

writeVector(obs,'/Users/EC13/Documents/Projects/PRSN/Hazus/Data/Spatial/Vector/landslide_obs.json',
            overwrite=TRUE)
