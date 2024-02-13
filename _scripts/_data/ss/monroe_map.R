library(terra)
library(caret)
library(parallel)
library(doParallel)
library(neuralnet)
library(NeuralNetTools)

# kmeans

## filepaths
raster <- "~/Documents/Projects/PRSN/Hazus/Data/Spatial/Raster/"
vector <- "~/Documents/Projects/PRSN/Hazus/Data/Spatial/Vector/"

r <- rast(paste0(raster, 'landslideSusc_monroe1979_georeferenced.tiff'),lyrs=1:3)
pr <- vect('~/Documents/Projects/PRSN/GIS/Vector/PR/Municips/PR.shp')

# pr<- pr[!pr$Precinct %in% c("Culebra 097","Vieques 096","Mayagüez 042"),] 

plot(pr)
# inspect the dataset
RGB(r) <- 1:3
plot(r)

# crop to extent
pr <- project(pr,r)
r <- mask(r,pr)

## kmeans

# convert the raster to a data.frame
nr <- as.data.frame(r, cell=TRUE, na.rm=TRUE)

# It is important to set the seed generator because `kmeans`
# initiates the centers in random locations
set.seed(99)

# Create 4 clusters, allow 500 iterations,
# start with 50 random sets using "Hartigan-Wong" method. 
# Do not use the first column (cell number).
kmncluster03 <- kmeans(nr[,-1], centers=3, iter.max = 500, 
                       nstart = 50, algorithm="Hartigan-Wong")
kmncluster04 <- kmeans(nr[,-1], centers=4, iter.max = 500, 
                       nstart = 50, algorithm="Hartigan-Wong")

kmr <- rast(r,nlyrs=1); kmr[nr$cell] <- kmncluster$cluster
kmr04 <- rast(r,nlyrs=1); kmr04[nr$cell] <- kmncluster04$cluster



writeRaster(kmr03, paste0(raster,'ls_Monroe03kmeans.tif'),
            overwrite=TRUE)
writeRaster(kmr04, paste0(raster,'ls_Monroe04kmeans.tif'),
            overwrite=TRUE)

# inputed user polygons with observations
userData <- vect(paste0(raster,'LS_trainingData.shp'))
userData <- terra::project(userData, r)

# change userData classes to factor to retain class values
userData$class <- as.factor(userData$id)

# add as a raster layer to raster
r[['class']]  <- rasterize(userData, r, field = "class")


# create dataframe from raster stack
df <- as.data.frame(r, cell=FALSE, na.rm=TRUE)

# transfer the names from df to raster stack
names(r) <- names(df)

# change classes to factor to retain class values
df$class <- as.factor(df$class)

# move class column to the 1st column
df <- df[,c(ncol(df),1:(ncol(df)-1))]

# set the seed
set.seed(9)

# Partition the data for training and testing
# 80% of the data will be used for the training
inTraining <- createDataPartition(df$class, p=0.80,list=FALSE)
training <- df[inTraining,]
testing <- df[-inTraining,]

# set training control parameters
fitControl <- trainControl(method="repeatedcv", number=5, repeats=3)

# set clusters
cl <- makePSOCKcluster(5)

# parallel programming
registerDoParallel(cl)

# train the random forest model for the complete dataframe
rfModel <- train(class~.,data=training, method="rf",
                 trControl=fitControl,
                 prox=TRUE,
                 fitBest = FALSE,
                 returnData = TRUE,
                 threshold=0.3)
Sys.time()

# stop the clusters
stopCluster(cl)

# save the model for future use
pathRF <- "~/Documents/Projects/PRSN/Hazus/Data/Spatial/ML/Models/RF/"
saveRDS(rfModel, file = paste0(pathRF,"rf_model.rds"))

# # create training raster
# df <- as.data.frame(r[['class']], cell=TRUE, na.rm=TRUE)
# df$training <- 0
# df[inTraining,]$training <- 1
# r[['training']] <- NA
# r[['training']][df$cell] <- df[,c('training')]


