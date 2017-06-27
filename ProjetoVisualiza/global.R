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

r <- raster(TP2M_raster,layer=10) #raster("nc/oisst-sst.nc")
pal <- colorNumeric(c("#0C2C84", "#41B6C4", "#FFFFCC"), values(r),
                    na.color = "transparent")

decades <- seq(1960, 2099, by=1)
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

models = c("ETA_MIROC5_RCP4.5_20KM","ETA_MIROC5_RCP8.5_20KM","ETA_HADGEM2-ES_RCP4.5_20KM","ETA_HADGEM2-ES_RCP4.5_5KM","ETA_HADGEM2-ES_RCP8.5_20KM","ETA_HADGEM2-ES_RCP8.5_5KM","ETA_CANESM2-ES_RCP4.5_20KM","ETA_CANESM2-ES_RCP8.5_20KM","ETA_BESM-ES_RCP4.5_20KM","ETA_BESM-ES_RCP8.5_20KM")

#Lista das Variáveis
var.labels <- c("Pressão ao Nível Médio do Mar", "Pressão à Superfície", "Componente Meridional do Vento a 10 m da Superfície", 
                "Componente Zonal do Vento a 10 m da Superfície", "Temperatura a 2 m da Superfície", "Temperatura Máxima", 
                "Temperatura Mínima", "Temperatura do Ponto de Orvalho", "Componente Zonal do Vento a 100 m da Superfície", 
                "Componente Meridional do Vento a 100 m da Superfície", "Precipitação Total", "Precipitação Convectiva",
                "Precipitação Estratiforme", "Neve", "Fluxo de Calor Latente à Superfície", "Fluxo de Calor Sensível à Superfície", 
                "Fluxo de Calor no Solo", "Temperatura à Superfície", "Temperatura do Solo na Camada de 0-10 cm da Superfície", 
                "Temperatura do Solo na Camada de 10-40 cm da Superfície", "Umidade do Solo na Camada de 0-10 cm da Superfície", 
                "Umidade do Solo na Camada de 10-40 cm da Superfície", "Conteúdo de Água Disponível no Solo", "Escoamento Superficial", 
                "Escoamento Subsuperficial", "Evapotranspiração Potencial à Superfície", "Cobertura de Nuvens Baixas", 
                "Cobertura de Nuvens Médias", "Cobertura de Nuvens Altas", "Radiação de Onda Curta Incidente à Superfície", 
                "Radiação de Onda Longa Incidente à Superfície", "Radiação de Onda Curta Emergente à Superfície", 
                "Radiação de Onda Longa Emergente à Superfície", "Radiação de Onda Curta Emergente no Topo da Atmosfera",
                "Radiação de Onda Longa Emergente no Topo da Atmosfera", "Albedo Superficial", "Energia Potencial Disponível para Convecção",
                "Água Precipitável", "Altura Geopotencial", "Componente Zonal do Vento", "Componente Meridional do Vento", "Temperatura Absoluta",
                "Umidade Relativa", "Movimento Vertical", "Umidade Específica")
#Lista das Cidades
cities.labels <- c("Porto Alegre", "Passo Fundo")



#-------
d.gcm <- group_by(d.gcm, RCP, Model, Var) %>% arrange(Var, RCP, Model)
d.cru <- group_by(d.cru, Var)
r <- subset(cru6190$pr, 1)
ext <- c(round(xmin(r), 1), round(xmax(r), 1), round(ymin(r), 1), round(ymax(r), 1))
lon <- (xmin(r)+xmax(r))/2
lat <- (ymin(r)+ymax(r))/2
decades <- seq(2010, 2090, by=10)

season.labels <- names(cru6190[[1]])[13:16]
season.labels.long <- season.labels[c(1,1,2,2,2,3,3,3,4,4,4,1)]
sea.idx <- list(Winter=c(1,2,12), Spring=3:5, Summer=6:8, Fall=9:11)
#Month vai receber a abreviação de todos os meses do ano, executar: month.abb para ver
#Season vai recever os nomes das estações do ano: "Winter" "Spring" "Summer" "Fall"
#Então toy_list terá 2 vetores, um com as estações e outro com os mêses: toy_list$Season e toy_list$Month
#list(Season = ("Inverno", "Primavera", "Verão", "Outono"), Month = ("Jan" "Fev" "Mar" "Abr" "Maio" "Jun" "Jul" "Aug" "Set" "Out" "Nov" "Dez")) -> isso nao funciona...

rcps <- sort(unique(d.gcm$RCP))
rcp.labels <- c("RCP 4.5", "RCP 6.0", "RCP 8.5")
models <- unique(d.gcm$Model)
vars <- rev(sort(unique(d.gcm$Var)))
var.labels <- rev(c("Precipitation", "Temperature"))

maptype_list <- list("Single GCM"=models, Statistic=c("Mean", "Min", "Max", "Spread"))
is_gcm_string <- paste(sprintf("input.mod_or_stat == '%s'", models), collapse=" || ")

colpals <- RColorBrewer::brewer.pal.info
dv <- rownames(colpals)[colpals["category"]=="div"]
sq <- rownames(colpals)[colpals["category"]=="seq"]
colpals_list <- list(Divergent=c(Custom="Custom div", dv), Sequential=c(Custom="Custom seq", sq))