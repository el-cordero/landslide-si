library(terra)


obs <- vect('/Users/EC13/Documents/Projects/PRSN/Hazus/Data/Spatial/Vector/Ground Deformation/PR2020_observation_data/Shapefile/PR_observation_pts.shp')

unique(obs$gf_type)
# gf <- c("Lateral spread","Coherent slides","Disrupted slides and falls")
gf <- c("Coherent slides","Disrupted slides and falls")
obs <- obs[obs$gf_type %in% gf,]
obs

plot(slope$degrees,xlim=(ext(project(obs,slope))[1:2]),ylim=(ext(project(obs,slope))[3:4]),clip=TRUE)
plot(project(obs,slope),add=TRUE)
writeVector(obs,'/Users/EC13/Documents/Projects/PRSN/Hazus/Data/Spatial/Vector/landslide_obs.json',
            overwrite=TRUE)
