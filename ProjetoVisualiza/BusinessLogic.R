getSuffix <- function(variable){ 

  if(variable == "CAPE")return(" J/kg")
  if(variable == "CLSF" || variable == "GHFL" || variable == "CSSF" || variable == "OCES" || variable == "OCIS" || 
     variable == "OLES" || variable == "OLIS")return(" W/m2")
  if(variable == "RNSG" || variable == "RNOF" || variable == "EVTP" || variable == "EVPP" || variable == "NEVE" || 
     variable == "PREC")return(" mm/ano")
  if(variable == "PSLC" || variable == "PSLM")return(" hPa")
  if(variable == "TP2M" || variable == "TSFC" || variable == "DP2M" || variable == "TGSC" || variable == "TGRZ" || 
     variable == "MXTP" || variable == "MNTP")return(" °C")
  if(variable == "USSL" || variable == "UZRS" || variable == "MDNV" || variable == "LWNV" || variable == "HINV")return(" 0-1")
  if(variable == "UZRS")return(" %")
  if(variable == "W100" || variable == "W10M")return(" m/s")
  if(variable == "D100" || variable == "D10M")return(" graus meteorológicos")
}

getMapRaster <- function(variable, dec, variableType){
  mapRaster <- paste('Tifs/Eta_MIROC5/Eta_MIROC5_20_',variableType,'_climate_annually_',variable,'_', dec, '0101_0000_v1.tif', sep = "")
  print("getMapRaster")
  print(mapRaster)
  r <- raster(mapRaster,layer=10)
  crs(r) <- CRS("+init=epsg:4326")
  return(r)
}

getMapPal <- function(variable, dec, variableType){
  if(variable == "MDNV" || variable == "LWNV" || variable == "HINV"){
    mapRaster <- paste('Tifs/Eta_MIROC5/Eta_MIROC5_20_',variableType,'_climate_annually_',variable,'_', dec, '0101_0000_v1.tif', sep = "")
    print("getMapPal")
    print(mapRaster)
    r <- raster(mapRaster,layer=10)
    pal <- colorNumeric(c("#066867", "#31BFC1", "#78D0DC", "#ACE0EB", "#FDDEBF", "#FBAA6B", "#CF6028", "#5E260F"), values(r),
                        na.color = "transparent")
    return(pal)
  }
  if(variable == "RNSG" || variable == "RNOF" || variable == "EVTP" || variable == "EVPP" || variable == "NEVE" || 
     variable == "PREC"){
      mapRaster <- paste('Tifs/Eta_MIROC5/Eta_MIROC5_20_',variableType,'_climate_annually_',variable,'_', dec, '0101_0000_v1.tif', sep = "")
      print("getMapPal")
      print(mapRaster)
      r <- raster(mapRaster,layer=10)
      pal <- colorNumeric(c("#FEFBDE", "#E4F1FA", "#CCFFFF", "#99FFFF", "#66CCCC", "#66CCCC"), values(r),
                          na.color = "transparent")
      return(pal)
  }
  if(variable == "CLSF" || variable == "GHFL" || variable == "CSSF" || variable == "OCES" || variable == "OCIS" || variable == "OLES" || 
     variable == "OLIS"){
       mapRaster <- paste('Tifs/Eta_MIROC5/Eta_MIROC5_20_',variableType,'_climate_annually_',variable,'_', dec, '0101_0000_v1.tif', sep = "")
       print("getMapPal")
       print(mapRaster)
       r <- raster(mapRaster,layer=10)
       pal <- colorNumeric(c("#9999CC", "#9999CC", "#9966CC", "#9966CC", "#9966CC", "#663399"), values(r),
                           na.color = "transparent")
       return(pal)
   }
  if(variable == "W100" || variable == "W10M" || variable == "D10M" || variable == "D100"){
    mapRaster <- paste('Tifs/Eta_MIROC5/Eta_MIROC5_20_',variableType,'_climate_annually_',variable,'_', dec, '0101_0000_v1.tif', sep = "")
    print("getMapPal")
    print(mapRaster)
    r <- raster(mapRaster,layer=10)
    pal <- colorNumeric(c("#6699FF", "#66FF99", "#FFFF99", "#FFCC66", "#FF0000", "#990099"), values(r),
                        na.color = "transparent")
    return(pal)
  }
  if(variable == "TP2M" || variable == "TSFC" || variable == "DP2M" || variable == "TGSC" || variable == "TGRZ" || 
     variable == "MXTP" || variable == "MNTP"){
    mapRaster <- paste('Tifs/Eta_MIROC5/Eta_MIROC5_20_',variableType,'_climate_annually_',variable,'_', dec, '0101_0000_v1.tif', sep = "")
    print("getMapPal")
    print(mapRaster)
    r <- raster(mapRaster,layer=10)
    pal <- colorNumeric(c("#FFFFFF", "#E1F6FB", "#BCEEFB", "#B9ECD8", "#CADB92", "#FFEB88", "#FBC25E", "#FF9933", 
                          "#FF7B33", "#CD5B12", "#FF3C1C"), values(r),
                        na.color = "transparent")
    return(pal)
  }
  if(variable == "UZRS" || variable == "USSL" || variable == "UR2M"){
    mapRaster <- paste('Tifs/Eta_MIROC5/Eta_MIROC5_20_',variableType,'_climate_annually_',variable,'_', dec, '0101_0000_v1.tif', sep = "")
    print("getMapPal")
    print(mapRaster)
    r <- raster(mapRaster,layer=10)
    pal <- colorNumeric(c("#00CC00", "#339933", "#339933", "#006600", "#006600", "#000000"), values(r),
                        na.color = "transparent")
    return(pal)
  }
  else{
    mapRaster <- paste('Tifs/Eta_MIROC5/Eta_MIROC5_20_',variableType,'_climate_annually_',variable,'_', dec, '0101_0000_v1.tif', sep = "")
    print("getMapPal")
    print(mapRaster)
    r <- raster(mapRaster)
    pal <- colorNumeric(c("#ffffff", "#000000"), values(r),
                        na.color = "transparent")
    return(pal)
  }
}

getUserShapeColor <- function(variable){
  if(variable == "MDNV" || variable == "LWNV" || variable == "HINV"){
    return(c("#066867", "#31BFC1", "#78D0DC", "#ACE0EB", "#FDDEBF", "#FBAA6B", "#CF6028", "#5E260F"))
  }
  if(variable == "RNSG" || variable == "RNOF" || variable == "EVTP" || variable == "EVPP" || variable == "NEVE" || 
     variable == "PREC"){
    return(c("#FEFBDE", "#E4F1FA", "#CCFFFF", "#99FFFF", "#66CCCC", "#66CCCC"))
  }
  if(variable == "CLSF" || variable == "GHFL" || variable == "CSSF" || variable == "OCES" || variable == "OCIS" || variable == "OLES" || 
     variable == "OLIS"){
    return(c("#9999CC", "#9999CC", "#9966CC", "#9966CC", "#9966CC", "#663399"))
  }
  if(variable == "W100" || variable == "W10M" || variable == "D10M" || variable == "D100"){
    return(c("#6699FF", "#6699FF", "#66FF99", "#FFFF99", "#FFCC66", "#FFCC66", "#FF0000", "#FF0000", "#990099", "#990099"))
  }
  if(variable == "TP2M" || variable == "TSFC" || variable == "DP2M" || variable == "TGSC" || variable == "TGRZ" || 
     variable == "MXTP" || variable == "MNTP"){
    return(c("#E2F2FA", "#BCEEFB", "#BCEEFB", "#B9ECD8", "#CADB92", "#FFEB88", "#FBC25E", "#FF7B33", 
             "#CD5B12", "#FF3C1C", "#663399"))
  }
  if(variable == "UZRS" || variable == "USSL" || variable == "UR2M"){
    return(c("#00CC00", "#339933", "#339933", "#006600", "#006600", "#000000"))
  }
  else{
    return(c("#ffffff", "#000000"))
  }
}