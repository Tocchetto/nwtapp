library(raster)
library(rgdal)

str_name <- 'Tsifs/Eta_MIROC5/Eta_MIROC5_20_Historical_climate_annually_GHFL_20050101_0000_v1.tif'
mapRaster <- paste('Eta_MIROC5_20_Historical_climate_annually_','NEVE','_', '2005', '0101_0000_v1.tif', sep = "")

imported_raster=raster(str_name)

plot(imported_raster)

#getwd()
#setwd("/Users/Guilherme/TCC/Projeto Definitivo/nwtapp/ProjetoVisualiza/Tifs/Eta_MIROC5")

mostra_raster <- function(n_layer,...){
  if(exists("r")){
    remove(r)
  }
  if(file.exists('Tsifs/Eta_MIROC5/Eta_MIROC5_20_Historical_climate_annually_GHFL_20050101_0000_v1.tif')){
    print("gg")
  }else{
    print("err")
  }
  r <- raster(str_name,layer=10) #raster("nc/oisst-sst.nc")
  if(exists("r")){
    print("gg")
  }else{
    print("err")
  }
  pal <- colorNumeric(c("#0C2C84", "#41B6C4", "#FFFFCC"), values(r),
                      na.color = "transparent")
  
  crs(r) <- CRS("+init=epsg:4326")
  
  leaflet() %>% addTiles() %>%
    addRasterImage(r, colors = pal, opacity = 0.8) %>%
    addLegend(pal = pal, values = values(r),
              title = "Surface temp")
}

mostra_raster(10)
