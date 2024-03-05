library(terra)

mediaFolder <- '~/Documents/Projects/PRSN/Landslides/_docs/_media/'
source('~/Documents/Projects/PRSN/Landslides/_scripts/_func/flow_accumulation.R')

png(filename=paste0(mediaFolder,'flow_accumulation_calc.png'), height=3.5,width=15,units="in",res=300)

par(mfcol=c(1,5))

n = 5

flowgrid <- c(32,64,128,16,NA,1,8,4,2)
flowgrid <- matrix(flowgrid,nrow=3,ncol=3,byrow = TRUE)
flowgrid <- rast(flowgrid)
plot(flowgrid,legend=FALSE,main='(a) Flow Direction Values',
    axes=FALSE, box=TRUE)
text(flowgrid)

labels <- letters[1:(n*n)]
labels <- matrix(labels,ncol = n,nrow = n,byrow = TRUE)
labels <- rast(labels)
plot(labels,legend=FALSE, main='(b) Cell Labels',
    axes=FALSE, box=TRUE)
text(labels)

set.seed(98)
r <- runif(n*n,21,35)
r <- matrix(r,nrow=n,ncol=n)
r <- rast(r)
plot(r,legend=FALSE,main='(c) Elevation',
    axes=FALSE, box=TRUE)
text(r)

# slope <- terrain(r,'slope')
# plot(slope,legend=FALSE,main='(d) Slope',
#     axes=FALSE, box=TRUE)
# text(slope)

flowdir <- terrain(r,'flowdir')
plot(flowdir,legend=FALSE, main='(e) Flow Direction Calculation',
    axes=FALSE, box=TRUE)
text(flowdir)

flowacc <- flow_accumulation(flowdir)
flowacc[1,] <- NA
flowacc[n,] <- NA
flowacc[,1] <- NA
flowacc[,n] <- NA
plot(flowacc,legend=FALSE, main='(f) Flow Accumulation',
    axes=FALSE, box=TRUE)
text(flowacc)

invisible(dev.off())

par(mfcol=c(1,1))