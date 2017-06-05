#Ambiente Global:

#Functions
getPrefix <- function(variable){ #Tem que ver certinho as unidades de cada valor (pressão, velocidade do vento, altura...)
  if(variable == "Temperatura Máxima")return(" °C")
  if(variable == "Temperatura Mínima")return(" °C")
  if(variable == "Temperatura do Ponto de Orvalho")return(" °C")
  if(variable == "Temperatura Absoluta")return(" °C")
  if(variable == "Temperatura a 2 m da Superfície")return(" °C")
  if(variable == "Temperatura à Superfície")return(" °C")
  if(variable == "Temperatura do Solo na Camada de 0-10 cm da Superfície")return(" °C")
  if(variable == "Temperatura do Solo na Camada de 10-40 cm da Superfície")return(" °C")
}

getMapRaster <- function(variable){
  if(variable == "Temperatura Máxima"){
    r <- raster(TP2M_raster,layer=10)
    crs(r) <- CRS("+init=epsg:4326")
    return(r)
  }else{
    r <- raster(OCIS_raster,layer=10)
    crs(r) <- CRS("+init=epsg:4326")
    return(r)
  }
}

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

#downloadFile('OCIS')
#downloadFile('PREC')
#downloadFile('TP2M')
#downloadFile('UR2M')
#downloadFile('V10M')

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

mostra_raster <- function(n_layer,...){
  r <- raster(OCIS_raster,layer=n_layer) #raster("nc/oisst-sst.nc")
  pal <- colorNumeric(c("#0C2C84", "#41B6C4", "#FFFFCC"), values(r),
                      na.color = "transparent")
  
  crs(r) <- CRS("+init=epsg:4326")
  
  leaflet() %>% addTiles() %>%
    addRasterImage(r, colors = pal, opacity = 0.8) %>%
    addLegend(pal = pal, values = values(r),
              title = "Surface temp")
}

#mostra_raster(10)
#mostra_raster(100)
#mostra_raster(150)
#mostra_raster(200)