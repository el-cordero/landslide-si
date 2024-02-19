library(terra)

path.in <- '~/Documents/Projects/PRSN/Hazus/Data/Spatial/Vector/'
scenario <- c('1787','1867','1918','13PR')
psa03 <- '_03_psa.shp'
psa10 <- '_10_psa.shp'
pga <- '_pga.shp'

for (i in 1:length(scenario)){
  print(scenario[i])
  p <- vect(paste0(path.in,scenario[i],psa03))
  names(p) <- toupper(names(p))
  p <- p[,'PARAMVALUE']
  writeVector(p,paste0(path.in,scenario[i],psa03), overwrite=TRUE)
}

for (i in 1:length(scenario)){
  print(scenario[i])
  p <- vect(paste0(path.in,scenario[i],psa10))
  names(p) <- toupper(names(p))
  p <- p[,'PARAMVALUE']
  writeVector(p,paste0(path.in,scenario[i],psa10), overwrite=TRUE)
}

for (i in 1:length(scenario)){
  print(scenario[i])
  p <- vect(paste0(path.in,scenario[i],psa10))
  names(p) <- toupper(names(p))
  p <- p[,'PARAMVALUE']
  writeVector(p,paste0(path.in,scenario[i],psa10), overwrite=TRUE)
}





crsOriginal <- crs(psa03_13pr)
crs <- 'epsg:3920'
psa03_13pr <- project(psa03_13pr,crs)
r <- rast(crs=crs,ext=ext(psa03_13pr), resolution=1500)
r <- rasterize(psa03_13pr,r,'ParamVALUE')
r <- project(r,crsOriginal)

plot(psa03_13pr,'ParamVALUE')               
plot(r)
