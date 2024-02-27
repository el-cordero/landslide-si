library(terra)

source('/Users/EC13/Documents/Projects/PRSN/Landslides/_scripts/_func/circle_points.r')
source('/Users/EC13/Documents/Projects/PRSN/Landslides/_scripts/_func/extent_points.r')

center.loc <- data.frame(x = -66.5901, y = 18.2208)
center <- vect(center.loc,geom=c('x','y'),crs='EPSG:4326')

buffer_dist <- 180*1000
circle <- circle_points(center, distance = buffer_dist)
extra.points <- extent_points(circle)

extra.points2 <- buffer(circle,buffer_dist)
extra.points2 <- extent_points(extra.points2)

extra.points <- data.frame(
        x = c(extra.points[,1],extra.points2[,1]),
        y = c(extra.points[,2],extra.points2[,2])
)

data.points <- rbind(center.loc,extra.points)

write.csv(data.points,'/Users/EC13/Documents/Projects/PRSN/Hazus/Data/Tables/earthquake_center.csv',
            row.names=FALSE)

