si_lithology <- function(lithology,age){
  
  si <- NA
  
  for (i in 1:length(lithology)){
    if (is.na(lithology[i]) == TRUE | is.na(age[i]) == TRUE){
      si[i] <- NA
    }
    else{
      if (lithology[i] ==  'Endogenous' & age[i] %in% 
          c('Cenozoic','Mesozoic','Mesozoic, Cenozoic')){
        si[i] <- 3
      }
      if (lithology[i] ==  'Endogenous' & age[i] == 'Paleozoic, Mesozoic'){
        si[i] <- 2
      }
      if (lithology[i] ==  'Endogenous' & age[i] == 'Precambrian, Paleozoic'){
        si[i] <- 1
      }
      if (lithology[i] ==  'Extrusive Volcanic' & age[i] == 'Cenozoic'){
        si[i] <- 5
      }
      if (lithology[i] ==  'Extrusive Volcanic' & age[i] == 'Mesozoic'){
        si[i] <- 3
      }
      if (lithology[i] ==  'Extrusive Volcanic' & age[i] == 'Mesozoic, Cenozoic'){
        si[i] <- 4
      }
      if (lithology[i] ==  'Extrusive Volcanic' & age[i] == 'Paleozoic, Mesozoic'){
        si[i] <- 2
      }
      if (lithology[i] ==  'Extrusive Volcanic' & age[i] == 'Precambrian, Paleozoic'){
        si[i] <- 1
      }
      if (lithology[i] ==  'Sedimentary' & age[i] == 'Quaternary'){
        si[i] <- 4
      }
      if (lithology[i] ==  'Sedimentary' & age[i] == 'Cenozoic'){
        si[i] <- 4
      }
      if (lithology[i] ==  'Sedimentary' & age[i] == 'Mesozoic, Cenozoic'){
        si[i] <- 4
      }
      if (lithology[i] ==  'Sedimentary' & age[i] == 'Mesozoic'){
        si[i] <- 3
      }
      if (lithology[i] ==  'Sedimentary' & age[i] == 'Precambrian, Paleozoic'){
        si[i] <- 2
      }
      if (lithology[i] ==  'Unconsolidated sediments' & age[i] == 'Holocene'){
        si[i] <- 4
      }
      if (lithology[i] ==  'Unconsolidated sediments' & age[i] == 'Quaternary'){
        si[i] <- 4
      }
      if (lithology[i] ==  'Unconsolidated sediments' & age[i] == 'Cenozoic'){
        si[i] <- 4
      }
      
    }
    
  }
  return(si)
}