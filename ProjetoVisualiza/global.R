library(shiny)
library(leaflet)
library(shinyBS)
library(shinyjs)
library(RColorBrewer)
library(DT)
library(rgdal)
library(raster)
library(data.table)
library(dplyr)
library(tidyr)
library(ggplot2)

source("mod_shpPoly.R")
#Exemplo https://rstudio.github.io/leaflet/legends.html
countries <- readOGR("countries.geojson", "OGRGeoJSON")
# pal <- colorNumeric(
#   palette = "YlGnBu",
#   domain = countries$gdp_md_est
# )

mapRaster <- 'Tifs/Eta_MIROC5/Eta_MIROC5_20_Historical_climate_annually_CAPE_19890101_0000_v1.tif'
print(getwd())
r <- raster(mapRaster,layer=10) #raster("nc/oisst-sst.nc")
 pal <- colorNumeric(c("#0C2C84", "#41B6C4", "#FFFFCC"), values(r),
                     na.color = "transparent")

decades <- seq(1960, 2005, by=1)
lon = -53.9010478
lat = -14.940753
#Month vai receber a abreviação de todos os meses do ano, executar: month.abb para ver
#Season vai recever os nomes das estações do ano: "Winter" "Spring" "Summer" "Fall"
#Então toy_list terá 2 vetores, um com as estações e outro com os mêses: toy_list$Season e toy_list$Month
#list(Season = ("Inverno", "Primavera", "Verão", "Outono"), Month = ("Jan" "Fev" "Mar" "Abr" "Maio" "Jun" "Jul" "Aug" "Set" "Out" "Nov" "Dez")) -> isso nao funciona...
season.labels <- c("Inverno","Primavera","Verão","Outono")
toy_list <- list(Season=season.labels)
#month_list <- list(Month=month.abb)
month_list = c("Jan","Fev","Mar","Abr","Maio","Jun","Jul","Aug","Set","Out","Nov","Dez")

models = c("Eta - 20 km, MIROC5", "Eta - 20km, HADGEM2-ES", "Eta - 5km, HADGEM2-ES", "Eta - 20km, CANESM2-ES", "Eta - 20km, BESM-ES")
#models = c("ETA_MIROC5_RCP4.5_20KM","ETA_MIROC5_RCP8.5_20KM","ETA_HADGEM2-ES_RCP4.5_20KM","ETA_HADGEM2-ES_RCP4.5_5KM","ETA_HADGEM2-ES_RCP8.5_20KM","ETA_HADGEM2-ES_RCP8.5_5KM","ETA_CANESM2-ES_RCP4.5_20KM","ETA_CANESM2-ES_RCP8.5_20KM","ETA_BESM-ES_RCP4.5_20KM","ETA_BESM-ES_RCP8.5_20KM")

#Lista das Variáveis
var.labels <- c("Energia Potencial Disponível para Convecção"="CAPE","Fluxo de Calor Latente à Superfície" = "CLSF", 
                "Fluxo de Calor Sensível à Superfície" = "CSSF", "Direção do vento a 100 m" = "D100", "Direção do vento a 10 m" = "D10M",
                "Temperatura do Ponto de Orvalho a 2 m" = "DP2M", "Evapotranspiração Potencial" = "EVPP", "Evapotranspiração" = "EVTP",
                "Fluxo de Calor no Solo" = "GHFL", "Cobertura de Nuvens Altas" = "HINV", "Cobertura de Nuvens Baixas" = "LWNV",
                "Cobertura de Nuvens Médias" = "MDNV", "Temperatura Minima a 2 m" = "MNTP", "Temperatura Máxima a 2 m" = "MXTP",
                "Neve" = "NEVE", "Radiação de Onda Curta Emergente à Superfície" = "OCES", "Radiação de Onda Curta Incidente à Superfície" = "OCIS", 
                "Radiação de Onda Longa Emergente à Superfície" = "OLES", "Radiação de Onda Longa Incidente à Superfície" = "OLIS", 
                "Precipitação Total" = "PREC", "Pressão à Superfície " = "PSLC", "Pressão ao Nível Médio do Mar" = "PSLM", 
                "Escoamento Superficial" = "RNOF", "Escoamento Subsuperficial" = "RNSG", "Temperatura do Solo na Camada de 10-40 cm" = "TGRZ", 
                "Temperatura do Solo na Camada de 0-10 cm" = "TGSC", "Temperatura a 2 m" = "TP2M", "Temperatura à Superfície (continente e oceano)" = "TSFC",
                "Umidade Relativa a 2 m" = "UR2M", "Umidade do Solo na Camada de 0-10 cm" = "USSL", "Umidade do Solo na Camada de 10-40 cm" = "UZRS", 
                "Vento a 100 m" = "W100", "Vento a 10 m" = "W10M")
# var.labels <- c("Pressão ao Nível Médio do Mar", "Pressão à Superfície", "Componente Meridional do Vento a 10 m da Superfície", 
#                 "Componente Zonal do Vento a 10 m da Superfície", "Temperatura a 2 m da Superfície", "Temperatura Máxima", 
#                 "Temperatura Mínima", "Temperatura do Ponto de Orvalho", "Componente Zonal do Vento a 100 m da Superfície", 
#                 "Componente Meridional do Vento a 100 m da Superfície", "Precipitação Total", "Precipitação Convectiva",
#                 "Precipitação Estratiforme", "Neve", "Fluxo de Calor Latente à Superfície", "Fluxo de Calor Sensível à Superfície", 
#                 "Fluxo de Calor no Solo", "Temperatura à Superfície", "Temperatura do Solo na Camada de 0-10 cm da Superfície", 
#                 "Temperatura do Solo na Camada de 10-40 cm da Superfície", "Umidade do Solo na Camada de 0-10 cm da Superfície", 
#                 "Umidade do Solo na Camada de 10-40 cm da Superfície", "Conteúdo de Água Disponível no Solo", "Escoamento Superficial", 
#                 "Escoamento Subsuperficial", "Evapotranspiração Potencial à Superfície", "Cobertura de Nuvens Baixas", 
#                 "Cobertura de Nuvens Médias", "Cobertura de Nuvens Altas", "Radiação de Onda Curta Incidente à Superfície", 
#                 "Radiação de Onda Longa Incidente à Superfície", "Radiação de Onda Curta Emergente à Superfície", 
#                 "Radiação de Onda Longa Emergente à Superfície", "Radiação de Onda Curta Emergente no Topo da Atmosfera",
#                 "Radiação de Onda Longa Emergente no Topo da Atmosfera", "Albedo Superficial", "Energia Potencial Disponível para Convecção",
#                 "Água Precipitável", "Altura Geopotencial", "Componente Zonal do Vento", "Componente Meridional do Vento", "Temperatura Absoluta",
#                 "Umidade Relativa", "Movimento Vertical", "Umidade Específica")
#Lista das Cidades
cities.labels <- c("Porto Alegre", "Passo Fundo")