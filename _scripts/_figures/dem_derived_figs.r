library(terra)
library(ggplot2)
library(tidyterra)
library(ggpubr)
library(maptiles)

mediaFolder <- '~/Documents/Projects/PRSN/Landslides/_docs/_media/'
dem <- rast('/Users/EC13/Documents/Projects/PRSN/Hazus/Data/Spatial/Raster/usgsMerge_20m.tif')
slope <- rast('~/Documents/Projects/PRSN/Hazus/Data/Spatial/Raster/slope_20m.tif')
cti <- rast('~/Documents/Projects/PRSN/Hazus/Data/Spatial/Raster/cti_20m.tif')
location <- rast('~/Documents/Projects/PRSN/Hazus/Data/Spatial/Raster/location.tif')

point <- data.frame(x = -66.72630498, y = 18.02091142)
point <- vect(point,geom=c('x','y'),crs='EPSG:4326')
point <- buffer(point,5000)

# location <- get_tiles(ext(point),"Esri.WorldImagery",zoom=14)
# writeRaster(location,'~/Documents/Projects/PRSN/Hazus/Data/Spatial/Raster/location.tif')
# rm(location)

point <- project(point,dem)

location <- project(location,dem)
location <- crop(location,point,ext=TRUE)

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
p_location <- ggplot() +
    # geom_spatraster(data=hillshade*100, show.legend = FALSE) +
    # scale_fill_gradient(low = "black", high = "white") +
    geom_spatraster_rgb(data=location) +
    theme_void() +
    labs(title='(a) Satellite Imagery') +
    theme(plot.title = element_text(hjust = 0.5, size = 12,
        face = "bold")
        )

p_dem <- ggplot() +
    geom_spatraster(data=hillshade*100, show.legend = FALSE) +
    scale_fill_gradient(low = "black", high = "white") +
    geom_spatraster(data=dem,alpha=0.4) +
    scale_fill_wiki_c() +
    theme_void() +
    labs(title='(b) DEM') +
    theme(legend.title = element_blank(),
        legend.position = c(0.1, 0.1),
        legend.justification = c(0, 0),
        legend.direction = "horizontal",
        legend.text = element_text(size = 8),
        legend.key.size = unit(0.5, "cm"),
        legend.spacing.y = unit(0.1, "cm"),
        legend.box.background = element_rect(color="black", linewidth=0.5),  
        plot.title = element_text(hjust = 0.5, size = 12, face = "bold")
        ) +
    guides(color = guide_legend(nrow = 1, override.aes = list(size = 5)))
    
p_flowdir <- ggplot() +
    geom_spatraster(data=cti$flowdir) +
    scale_fill_hypso_d(palette='etopo1') +
    theme_void() +
    labs(title='(c) Flow Direction') +
    theme(legend.title = element_blank(),
        legend.position = c(0.1, 0.1),
        legend.justification = c(0, 0),
        legend.direction = "horizontal",
        legend.text = element_text(size = 8),
        legend.key.size = unit(0.5, "cm"),
        legend.spacing.y = unit(0.1, "cm"),
        legend.box.background = element_rect(color="black", linewidth=0.5),  
        legend.key = element_rect(fill = "white", colour = "black", size = 0.5),
        plot.title = element_text(hjust = 0.5, size = 12, face = "bold")
        ) +
    guides(color = guide_legend(nrow = 1, override.aes = list(size = 5)))
p_flowdir

p_flowacc <- ggplot() +
    geom_spatraster(data=hillshade*300, show.legend = FALSE) +
    scale_fill_gradient(low = "black", high = "white") +
    geom_spatraster(data=cti$flowacc,alpha=0.6) +
    scale_fill_whitebox_c(palette='deep') +
    theme_void() +
    labs(title = '(d) Flow Accumulation') +
    theme(legend.title = element_blank(),
        legend.position = c(0.1, 0.1),
        legend.justification = c(0, 0),
        legend.direction = "horizontal",
        legend.text = element_text(size = 8),
        legend.key.size = unit(0.5, "cm"),
        legend.spacing.y = unit(0.1, "cm"),
        legend.box.background = element_rect(color="black", linewidth=0.5),  
        plot.title = element_text(hjust = 0.5, size = 12,face = "bold")
        ) +
    guides(color = guide_legend(nrow = 1, override.aes = list(size = 5)))
    

p_cti <- ggplot() +
    geom_spatraster(data=hillshade*100, show.legend = FALSE) +
    scale_fill_gradient(low = "black", high = "white") +
    geom_spatraster(data=cti$cti,alpha=0.4) +
    scale_fill_whitebox_c(palette='deep') +
    theme_void() +
    labs(title = '(e) CTI') +
    theme(legend.title = element_blank(),
        legend.position = c(0.1, 0.1),
        legend.justification = c(0, 0),
        legend.direction = "horizontal",
        legend.text = element_text(size = 8),
        legend.key.size = unit(0.5, "cm"),
        legend.spacing.y = unit(0.1, "cm"),
        legend.box.background = element_rect(color="black", linewidth=0.5),  
        plot.title = element_text(hjust = 0.5, size = 12, face = "bold")
        ) +
    guides(color = guide_legend(nrow = 1, override.aes = list(size = 5)))
    

png(filename=paste0(mediaFolder,'flow_plots.png'), height=4,width=16,units="in",res=300)
ggarrange(p_location,
        p_dem,
        p_flowdir,
        p_flowacc,
        p_cti,
         ncol=5,nrow = 1)
invisible(dev.off())

# par(mfcol=c(1,1))

