library(terra)
library(tidyverse)
library(tidyterra)
library(ggplot2)

mediaFolder <- '~/Documents/Projects/PRSN/Data/R/Landslides/_documentation/_media/'
lithology <- vect('~/Documents/Projects/PRSN/Hazus/Data/Spatial/Vector/Geology/PRgeology.shp')
lc <- rast('~/Documents/Projects/PRSN/Hazus/Data/Spatial/Raster/CCAP/pr_2010_ccap_hr_land_cover20170214.img')
lcReclass <- rast('~/Documents/Projects/PRSN/Hazus/Data/Spatial/Raster/CCAP_Reclass_PR.tif')
si <- rast('~/Documents/Projects/PRSN/Hazus/Data/Spatial/Raster/landslide_si.tif')

s <- rast(ext=ext(lc),crs=crs(lc),resolution=150)
lc <- resample(lc,s)
lcReclass <- resample(lcReclass,s)

lithology <- lithology %>% filter(!is.na(FMATN))

png(filename=paste0(mediaFolder,'lithology_Nadim.png'), height=6,width=14.8,units="in",res=300)
nadim <- aggregate(lithology,'lithology')
nadim %>% ggplot() +
  geom_spatvector(aes(fill=lithology) ) +
  labs(title='Lithology - Nadim et al. (2006) Classification', fill='') + 
  scale_fill_whitebox_d(palette = "bl_yl_rd") +
  theme_bw() +
  theme(legend.position='bottom')
invisible(dev.off())

png(filename=paste0(mediaFolder,'lithology_Nowicki.png'), height=6,width=13,units="in",res=500)
nowicki <- aggregate(lithology,'lithology_')
nowicki %>% ggplot() +
  geom_spatvector(aes(fill=lithology_) ) +
  labs(title='Lithology - Nowicki Jessee et al. (2018) Classification', fill='') + 
  scale_fill_whitebox_d(palette = "bl_yl_rd") +
  theme_bw() +
  theme(legend.position='bottom')
invisible(dev.off())


png(filename=paste0(mediaFolder,'age_Nadim.png'), height=6,width=14.8,units="in",res=500)
age <- aggregate(lithology,'age_2') 
age %>% ggplot() +
  geom_spatvector(aes(fill=age_2)) +
  labs(title='Age - Nadim et al. (2006) Classification',fill='') + 
  scale_fill_whitebox_d(palette = "bl_yl_rd") +
  theme_bw() +
  theme(legend.position='bottom')
invisible(dev.off())


lcBackground <- classify(lc, cbind(0,NA))
lcBackground <- as.factor(lcBackground)
# lcCats <- as.data.frame(cats(lc))
# addCats(lcBackground, lcCats)
coltab(lcBackground) <- coltab(lc)
levels(lcBackground) <- levels(lc)
plot(lcBackground)
lcColors <- as.data.frame(coltab(lc))
lcColors$colors <- rgb(lcColors$red,lcColors$green,lcColors$blue,maxColorValue=255, alpha=255)
lcColors <- lcColors[lcColors$value %in% sort(unique(values(lcBackground))),]

png(filename=paste0(mediaFolder,'lc_ccap.png'), height=6,width=14.8,units="in",res=500)
ggplot() +
  geom_spatraster(data=lcBackground) +
  labs(title='Land Cover - C-CAP 2010 (NOAA, 2017)',fill='') + 
  scale_fill_manual(values=lcColors$colors, na.value = NA) +
  theme_bw() +
  theme(legend.position='bottom')
invisible(dev.off())

# lcReclass <- classify(lc, c(0,NA))
reclassLabels <- unique(values(lcReclass$Globcover.Desc,na.rm=TRUE))
reclassLabels <- cats(lcReclass)[[1]]$Globcover.Desc
reclassLabels <- str_wrap(reclassLabels,25)

png(filename=paste0(mediaFolder,'lc_reclass.png'), height=7,width=14,units="in",res=500)
ggplot() +
  geom_spatraster(data=lcReclass, aes(fill=Globcover.Desc)) +
  labs(title='Land Cover Reclassification - C-CAP to GlobCover2009 (Arino et al., 2012)',fill='') + 
  scale_fill_whitebox_d(palette = "bl_yl_rd", na.value = 'transparent',labels=reclassLabels) +
  theme_bw() +
  theme(legend.position='bottom')
invisible(dev.off())

si$si.reclass <- si$si.reclass + 1
si$si.reclass <- as.factor(si$si.reclass)
png(filename=paste0(mediaFolder,'si.png'), height=6,width=14.8,units="in",res=500)
ggplot() +
  geom_spatraster(data=si, aes(fill=si.reclass)) +
  labs(title='Landslide Susceptibility - Nowicki Jessee et al. (2018) Model', fill='') + 
  scale_fill_whitebox_d(palette = "bl_yl_rd", na.value = 'transparent') +
  theme_bw() +
  theme(legend.position='bottom')
invisible(dev.off())

