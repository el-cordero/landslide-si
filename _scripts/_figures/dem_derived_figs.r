library(terra)
library(ggplot2)
library(tidyterra)

mediaFolder <- '~/Documents/Projects/PRSN/Landslides/_docs/_media/'
dem <- rast('/Users/EC13/Documents/Projects/PRSN/Hazus/Data/Spatial/Raster/usgsMerge20m.tif')
slope <- rast('~/Documents/Projects/PRSN/Hazus/Data/Spatial/Raster/slope20m.tif')
cti <- rast('~/Documents/Projects/PRSN/Hazus/Data/Spatial/Raster/cti20m.tif')

point <- data.frame(x = -66.72630498, y = 18.02091142)
point <- vect(point,geom=c('x','y'),crs='EPSG:4326')
point <- project(point,dem)
point <- buffer(point,5000)


dem <- crop(dem,point,ext=TRUE)
slope <- crop(slope,point,ext=TRUE)
cti <- crop(cti,point, ext=TRUE)
aspect <- terrain(dem,'aspect',unit='radians')
hillshade <- shade(slope$radians,aspect)

# cti$flowdir <- as.factor(cti$flowdir)
flow_direction_val <- sort(unique(values(cti$flowdir,na.rm=TRUE)))
flow_direction <- c('None','E','SE','S','SW','W','NW','N','NE')
flow_direction <- data.frame(val = flow_direction_val, flow_direction)
levels(cti$flowdir) <- flow_direction
# cti <- categories(cti,layer=2,flow_direction) 
# cti$flow_direction

p_dem <- ggplot() +
    geom_spatraster(data=hillshade*100, show.legend = FALSE) +
    scale_fill_gradient(low = "black", high = "white") +
    geom_spatraster(data=dem,alpha=0.4) +
    scale_fill_wiki_c() +
    theme_void()
p_dem

p_flowdir <- ggplot() +
    # geom_spatraster(data=hillshade*100, show.legend = TRUE) +
    # scale_fill_gradient(low = "black", high = "white") +
    geom_spatraster(data=cti$flowdir) +
    scale_fill_hypso_d(palette='etopo1') +
    theme_void()
p_flowdir

p_flowacc <- ggplot() +
    geom_spatraster(data=hillshade*300, show.legend = FALSE) +
    scale_fill_gradient(low = "black", high = "white") +
    geom_spatraster(data=cti$flowacc,alpha=0.6) +
    scale_fill_whitebox_c(palette='deep') +
    theme_void()
p_flowacc

p_cti <- ggplot() +
    geom_spatraster(data=hillshade*100, show.legend = FALSE) +
    scale_fill_gradient(low = "black", high = "white") +
    geom_spatraster(data=cti$cti,alpha=0.4) +
    scale_fill_whitebox_c(palette='deep') +
    theme_void()    




invisible(dev.off())

# par(mfcol=c(1,1))