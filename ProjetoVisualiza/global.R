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

#Exemplo https://rstudio.github.io/leaflet/legends.html
countries <- readOGR("countries.geojson", "OGRGeoJSON")
pal <- colorNumeric(
  palette = "YlGnBu",
  domain = countries$gdp_md_est
)

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