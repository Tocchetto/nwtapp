#Ambiente Global:
downloadFile <- function(cData){
  # ftp-supercomputacao.cptec.inpe.br/public/etaclim/APP/Eta15km_BR/OCIS/eta_15km_OCIS_2016062800-2016070900.tar.gz
  baseURL <- 'http://ftp-supercomputacao.cptec.inpe.br/public/etaclim/APP/Eta15km_BR/'
  mURL <- paste(cData, '/eta_15km_', cData, '_', sep = '')
  sufURL <- '00.tar.gz'
  fURL <- paste(baseURL, mURL, curDate, '00-', fDate, sufURL, sep = '')
  desFile <- paste(cData, '.tar.gz')
  download.file(url = fURL, destfile = desFile, method = 'auto')
  untar(desFile)
  file.remove(desFile)
}

generateDF <- function(cData, curDate, fDate){
  # eta_15km_OCIS_2016062800-2016070900.txt
  fileName <- paste('eta_15km_', cData, '_', curDate, '00-', fDate, '00.txt', sep = '' )
  cptec = read.delim2(fileName, header=FALSE, sep=" ", skip = 9, stringsAsFactors=F)
  cptec_t = t(cptec)
  colnames(cptec_t) <- cptec_t[1,]
  cptec_t <- cptec_t[-1,]
  cptec_t <- as.data.frame(cptec_t,stringsAsFactors=FALSE)
  cptec_t$LONGITUDE <- as.numeric(as.character(cptec_t$LONGITUDE))
  cptec_t$LATITUDE <- as.numeric(as.character(cptec_t$LATITUDE))
  #file.remove(fileName)
  return(cptec_t)
}

date <- Sys.Date()-1 # dia atual / data do sistema
curDate <- format(date, '%Y%m%d')
dateString <- format(date, '%Y/%m/%d')
fDate <- as.Date(dateString) + 11
fDate <- format(fDate, '%Y%m%d')

#TP2M = file("./eta_15km_TP2M_2017060400-2017061500.txt")
#TP2M <- generateDF('TP2M', curDate, fDate)
#TP2M_raster = rasterFromXYZ(TP2M[-75351,])
#OCIS = file("./eta_15km_OCIS_2017060400-2017061500.txt")
#OCIS <- generateDF('OCIS', curDate, fDate)
#OCIS_raster = rasterFromXYZ(OCIS[-75351,])

#Functions
getSuffix <- function(variable){ #Tem que ver certinho as unidades de cada valor (pressão, velocidade do vento, altura...)
  #print(variable)
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
  #decades <- seq(1960, 2005, by=1)
  # if(variableType == "Historical"){
  #   decades <- seq(1960, 2005, by=1)
  # }
  # else{
  #   decades <- seq(2006, 2099, by=1)
  # }
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

#downloadFile('OCIS')
#downloadFile('PREC')
#downloadFile('TP2M')
#downloadFile('UR2M')
#downloadFile('V10M')
#OCIS = file("./eta_15km_OCIS_2017060400-2017061500.txt")
#OCIS <- generateDF('OCIS', curDate, fDate)
#PREC <- generateDF('PREC', curDate, fDate)
#TP2M <- generateDF('TP2M', curDate, fDate)
#UR2M <- generateDF('UR2M', curDate, fDate)
#V10M <- generateDF('V10M', curDate, fDate)

# tirando aquela linha a mais do arquivo!!!
#OCIS_raster = rasterFromXYZ(OCIS[-75351,])
#PREC_raster = rasterFromXYZ(PREC[-75351,])
#TP2M_raster = rasterFromXYZ(TP2M[-75351,])
#UR2M_raster = rasterFromXYZ(UR2M[-75351,])
#V10M_raster = rasterFromXYZ(V10M[-75351,])

# mostra_raster <- function(n_layer,...){
#   r <- raster(OCIS_raster,layer=n_layer) #raster("nc/oisst-sst.nc")
#   pal <- colorNumeric(c("#0C2C84", "#41B6C4", "#FFFFCC"), values(r),
#                       na.color = "transparent")
#   
#   crs(r) <- CRS("+init=epsg:4326")
#   
#   leaflet() %>% addTiles() %>%
#     addRasterImage(r, colors = pal, opacity = 0.8) %>%
#     addLegend(pal = pal, values = values(r),
#               title = "Surface temp")
# }

#mostra_raster(10)
#mostra_raster(100)
#mostra_raster(150)
#mostra_raster(200)