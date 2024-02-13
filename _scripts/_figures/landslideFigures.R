library(terra)
library(tidyverse)
library(tidyterra)
library(ggplot2)

path.in <- '~/Documents/Projects/PRSN/Hazus/Data/Spatial/Vector/'

lithology <- vect(paste0(path.in,'Geology/PRgeology.shp'))

lithology <- lithology %>% filter(!is.na(FMATN))
lithology$susc_nadim <- as.factor(lithology$susc_nadim)


file.output <- '~/Documents/Projects/PRSN/Hazus/Documentation/Written/Markdown/media/lithology_Nadim.png'
png(filename=file.output, height=12,width=15,units="in",res=500)
nadim <- aggregate(lithology,'lithology')
nadim %>% ggplot() +
  geom_spatvector(aes(fill=lithology) ) +
  labs(title='Lithology - Nadim et al. (2006) Classification', fill='') + 
  scale_fill_whitebox_d(palette = "bl_yl_rd") +
  theme_bw() +
  theme(legend.position='bottom')

invisible(dev.off())

file.output <- '~/Documents/Projects/PRSN/Hazus/Documentation/Written/Markdown/media/age_Nadim.png'
png(filename=file.output, height=12,width=15,units="in",res=500)
age <- aggregate(lithology,'age_2') 
age %>% ggplot() +
  geom_spatvector(aes(fill=age_2)) +
  labs(title='Age - Nadim et al. (2006) Classification',fill='') + 
  scale_fill_whitebox_d(palette = "bl_yl_rd") +
  theme_bw() +
  theme(legend.position='bottom')
invisible(dev.off())

file.output <- '~/Documents/Projects/PRSN/Hazus/Documentation/Written/Markdown/media/landslide_susc_Nadim.png'
png(filename=file.output, height=12,width=15,units="in",res=500)
suscNadim <- aggregate(lithology,'susc_nadim')
suscNadim %>% ggplot() +
  geom_spatvector(aes(fill=susc_nadim)) +
  labs(title='Landslide Susceptibility - Nadim et al. (2006) Classification',fill='') + 
  scale_fill_whitebox_d(palette = "bl_yl_rd") +
  theme_bw() +
  theme(legend.position='bottom')
invisible(dev.off())

file.output <- '~/Documents/Projects/PRSN/Hazus/Documentation/Written/Markdown/media/landslide_Nowicki.png'
png(filename=file.output, height=12,width=15,units="in",res=500)
nowicki <- aggregate(lithology,'lithology_')
nowicki %>% ggplot() +
  geom_spatvector(aes(fill=lithology_)) +
  labs(title='Lithology - Nowicki Jesse et al. (2018) Classification',fill='') + 
  scale_fill_whitebox_d(palette = "bl_yl_rd") +
  theme_bw() +
  theme(legend.position='bottom')
invisible(dev.off())

