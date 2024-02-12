fault_1787 <- rbind(c(-65.57, 19.298),c(-66.37, 19.398))
fault_1867 <- rbind(c(-65.66, 18.00),c(-64.36, 18.00))
fault_1918_1 <- rbind(c(-67.34, 19.00),c(-67.35, 18.88)) 
fault_1918_2 <- rbind(c(-67.35, 18.88),c(-67.38, 18.86))
fault_1918_3 <- rbind(c(-67.38, 18.86),c(-67.42, 18.58))
fault_1918_4 <- rbind(c(-67.42, 18.58),c(-67.50, 18.44))
fault_13pr_1 <- rbind(c(-64.80, 19.00),c(-65.40, 19.00))
fault_13pr_2 <- rbind(c(-65.40, 19.00),c(-66.50, 19.25))
fault_13pr_3 <- rbind(c(-66.50, 19.25),c(-67.00, 19.25))
fault_13pr_4 <- rbind(c(-67.00, 19.25),c(-66.50, 19.25))

l <- rbind(cbind(object=1, part=1, fault_1787), 
           cbind(object=2, part=1, fault_1867),
           cbind(object=3, part=1, fault_1918_1),
           cbind(object=3, part=2, fault_1918_2),
           cbind(object=3, part=3, fault_1918_3),
           cbind(object=3, part=4, fault_1918_4),
           cbind(object=4, part=1, fault_13pr_1),
           cbind(object=4, part=2, fault_13pr_2),
           cbind(object=4, part=3, fault_13pr_3),
           cbind(object=4, part=4, fault_13pr_4)
           )
colnames(l)[3:4] <- c('x', 'y')
l <- vect(l, "lines")

l$Scenario <- c('1787PRT','1867VIB','1918MC','13PR')
l$Type <- c('Reverse','Normal', 'Normal','Sinistral')
l$Source <- c('Huérfano (2003)', 'Zahibo et al. (2003)','Mercado and McCann (1998)','PRSN/FEMA; Ramirez-Rivera (2016)')
crs(l) <- 'epsg:4236'

writeVector(l,'~/Documents/Projects/PRSN/Hazus/Data/Spatial/Vector/fault_segments.shp',
            overwrite=TRUE)

faults <- data.frame(
  rbind(c('1787PRT',1,-65.57, 19.298,-66.37, 19.398,91,	45,	2.3,	5.00,	85,	23, 'Huérfano (2003)'),
      c('1867VIB',1,-65.66, 18.00,-64.36, 18.00,90,	70,	8.00,	3.00,	120,	23, 'Zahibo et al. (2003)'),
      c('1918MC',1,-67.34, 19.00,-67.35, 18.88,185,	85,	4.00,	4.67,	13,	23, 'Mercado and McCann (1998)'),
      c('1918MC',2,-67.35, 18.88,-67.38, 18.86,236, 34,	4.00,	4.71,	4,	23,'Mercado and McCann (1998)'),
      c('1918MC',3,-67.38, 18.86,-67.42, 18.58,188,	82,	4.00,	4.34,	31,	23,'Mercado and McCann (1998)'),
      c('1918MC',4,-67.42, 18.58,-67.50, 18.44,210,	60,	4.00,	2.31,	18,	23,'Mercado and McCann (1998)'),
      c('13PR',1,-64.80, 19.00,-65.40, 19.00,109,	45,	5.473,	10,	66.92,	72.5, 'PRSN/FEMA; Ramirez-Rivera (2016)'),
      c('13PR',2,-65.40, 19.00,-66.50, 19.25,90,	45,	5.473,	10,	63.02,	72.59,'PRSN/FEMA; Ramirez-Rivera (2016)'),
      c('13PR',3,-66.50, 19.25,-67.00, 19.25,103,	45,	5.473,	10,	118.90,	72.5,'PRSN/FEMA; Ramirez-Rivera (2016)'),
      c('13PR',4,-67.00, 19.25,-66.50, 19.25,90,	45,	 5.473,	10,	52.49,	72.59,'PRSN/FEMA; Ramirez-Rivera (2016)')
  ))
names(faults) <- c("Scenario",	"Segment", "Lon_DD_start",	"Lat_DD_start", 
                   "Lon_DD_end",	"Lat_DD_end",	"Strike_D",	"Dip_D",	"Slip_m",	
                   "Depth_km",	"Length_km", "Width_km","Source")

write.csv(faults,'~/Documents/Projects/PRSN/Hazus/Documentation/Written/Tables/faults.csv')










