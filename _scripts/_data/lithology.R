library(terra)
library(tidyverse)
library(tidyterra)

source('~/Documents/Projects/PRSN/Data/R/Hazus/_scripts/_data/func_si_lithology.R')
source('~/Documents/Projects/PRSN/Data/R/Hazus/_scripts/_data/func_reclass_nadim.R')
path.in <- '~/Documents/Projects/PRSN/Hazus/Data/Spatial/Vector/'

lithology <- vect(paste0(path.in,'Geology/PR_geology_proj.shp'))

# write.csv(as.data.frame(sort(unique(lithology$FMATN))), '~/Documents/Projects/PRSN/Hazus/Data/Tables/GeologyFormations.csv')
lithologyData <- read.csv('~/Documents/Projects/PRSN/Hazus/Data/Tables/Geology.csv')
nowickiSusc <- read.csv('~/Documents/Projects/PRSN/Hazus/Data/Tables/NowickiClassification.csv')

lithologyData$symbol
lithology$FMATN

lithology %>% filter(FMATN == 'Tay')
lithology %>% filter(FMATN == 'Tag')
lithology %>% filter(FMATN %in% c('Tay','Tag'))

lithology <- lithology[,c('FMATN','PROV')]


lithology <- lithology %>%
  left_join(lithologyData,
            by=join_by(FMATN == symbol),keep=FALSE)

lithology$Nadim.SI <- si_lithology(lithology$lithology, lithology$age_2)
lithology$Nadim.SI.2 <- reclass_nadim(lithology$Nadim.SI)

lithology <- lithology %>%
  left_join(nowickiSusc[c('Rock.Type','Landslide.SI', 'Nowicki.Coef')],
            by=join_by(lithology_nowicki == Rock.Type),keep=FALSE)

writeVector(lithology,paste0(path.in,'Geology/PRgeology.shp'), overwrite=TRUE)


