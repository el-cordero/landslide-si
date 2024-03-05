library(terra)
library(ggplot2)
library(tidyterra)
library(ggpubr)
library(maptiles)

mediaFolder <- '~/Documents/Projects/PRSN/Landslides/_docs/_media/'
si <- rast('/Users/EC13/Documents/Projects/PRSN/Hazus/Data/Spatial/Raster/landslide_si_5m.tif')
dem <- rast('/Users/EC13/Documents/Projects/PRSN/Hazus/Data/Spatial/Raster/usgsMerge_20m.tif')
slope <- rast('~/Documents/Projects/PRSN/Hazus/Data/Spatial/Raster/slope_20m.tif')

aspect <- terrain(dem,'aspect',unit='radians')
hillshade <- shade(slope$radians,aspect)
si <- resample(si,hillshade)
hillshade <- mask(hillshade,si[[1]])

susceptibility <- c('None','Low','Moderate','High','Very High','Extreme')
susceptibility <- data.frame(val = 0:5, susceptibility)
levels(si$classified0to5) <- susceptibility

susceptibility <- c('None','I','II','III','IV','V','VI','VII','VIII','IX','X')
susceptibility <- data.frame(val = 0:10, susceptibility)
levels(si$classified) <- susceptibility

p_si_0to5 <- ggplot() +
  # geom_spatraster(data=hillshade*300, show.legend = FALSE) +
  # scale_fill_gradient(low = "black", high = "white") +
  geom_spatraster(data=si$classified0to5, maxcell=9*10^7) +
  scale_fill_hypso_d(palette='meyers',direction=-1) +
  theme_void() +
  labs(title = '') +
  theme(#legend.title = element_blank(),
        legend.position = 'bottom',
        legend.justification = 'center',
        legend.direction = "horizontal",
        legend.text = element_text(size = 8),
        legend.key.size = unit(0.5, "cm"),
        legend.spacing.y = unit(0.1, "cm"),
        # legend.box.background = element_rect(color="black", linewidth=0.5),  
        plot.title = element_text(hjust = 0.5, size = 12,face = "bold")
  ) +
  guides(color = guide_legend(nrow = 1, override.aes = list(size = 5)),
         fill = guide_legend(title='Landslide Susceptibility'))

png(filename=paste0(mediaFolder,'ls_si_0to5_map.png'), height=6.8,width=16,units="in",res=300)
p_si_0to5
invisible(dev.off())

p_si_0to10 <- ggplot() +
  # geom_spatraster(data=hillshade*300, show.legend = FALSE) +
  # scale_fill_gradient(low = "black", high = "white") +
  geom_spatraster(data=si$classified, maxcell=9*10^7) +
  scale_fill_hypso_d(palette='meyers',direction=-1) +
  theme_void() +
  labs(title = '') +
  theme(#legend.title = element_blank(),
    legend.position = 'bottom',
    legend.justification = 'center',
    legend.direction = "horizontal",
    legend.text = element_text(size = 8),
    legend.key.size = unit(0.5, "cm"),
    legend.spacing.y = unit(0.1, "cm"),
    # legend.box.background = element_rect(color="black", linewidth=0.5),  
    plot.title = element_text(hjust = 0.5, size = 12,face = "bold")
  ) +
  guides(color = guide_legend(nrow = 1, override.aes = list(size = 5)),
         fill = guide_legend(title='Landslide Susceptibility'))

png(filename=paste0(mediaFolder,'ls_si_0to10_map.png'), height=6.8,width=17,units="in",res=300)
p_si_0to10
invisible(dev.off())




png(filename=paste0(mediaFolder,'ls_si_prob_map.png'), height=4,width=11,units="in",res=300)
plot(hillshade*300,legend=FALSE,col=grey(0:100/100),box=FALSE,axes=FALSE)
plot(si$probability,alpha=0.6,add=TRUE)#,breaks=6)
invisible(dev.off())


