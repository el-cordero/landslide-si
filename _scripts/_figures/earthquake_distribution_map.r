library(lubridate)
library(terra)
library(tidyterra)
library(tidyverse)
library(ggplot2)
library(maptiles)
library(gridExtra)
library(ggtext)

center <- read.csv('/Users/EC13/Documents/Projects/PRSN/Hazus/Data/Tables/earthquake_center.csv')
eqdf <- read.csv('~/Documents/Projects/PRSN/Hazus/Data/Tables/earthquake_data.csv')


eqdf <- vect(eqdf,geom=c('lon','lat'),crs='EPSG:4326')
center <- vect(center,geom=c('x','y'),crs=crs(eqdf))

eqdf$time <- ymd_hms(eqdf$time)
eqdf$year <- year(eqdf$time)
eqdf <- eqdf[eqdf$mag >= 6,c('place','year','mag','magType')]
eqdf$ID <- 1:nrow(eqdf)
names(eqdf) <- c('Location','Year','Magnitude','Type','ID')
eqdf <- eqdf[,c('ID','Location','Year','Magnitude','Type')]


# Convert the data frame to a table grob
table_grob <- tableGrob(as.data.frame(eqdf),rows=NULL)

# Plot the table grob
ggsave('/Users/EC13/Documents/Projects/PRSN/Landslides/_docs/_media/eq_datatable.png', 
        table_grob, width = 7, height = 11, dpi = 300)

tile1 <- get_tiles(ext(eqdf), provider = "Esri.OceanBasemap", zoom = 7, cachedir = ".")
# writeRaster(tile1, '~/Documents/Projects/GIS/Raster/PR/osj_zoom16.tif')
# tile1 <- rast(paste0(path.in,'Raster/OpenStreetMap/PR/osj_zoom16.tif'))
ext_buffer <- buffer(eqdf,5*1000)

ggm <- ggplot() +
    geom_spatraster_rgb(data=tile1) +
    geom_spatvector(data= eqdf,aes(color=Magnitude), cex=5) + 
    scale_colour_whitebox_c(palette='bl_yl_rd',name='Magnitude')+
    geom_spatvector_text(data = eqdf, 
                       aes(label = ID),
                       size=3,color='black') +
    coord_sf(crs=4326,xlim=ext(ext_buffer)[1:2],ylim=ext(ext_buffer)[3:4]) +
    xlab('') +
    ylab('') +
    theme_light() +
    theme(legend.position = 'right') 


png(filename='/Users/EC13/Documents/Projects/PRSN/Landslides/_docs/_media/eq_locations.png',
    units="in", width=9, height=6, res=300)
ggm
invisible(dev.off())


kmdist <- buffer(center[1],600*1000)
plot(kmdist)
plot(eqdf,add=TRUE)
