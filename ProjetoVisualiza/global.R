#install.packages(c("leaflet", "shiny", "shinyBS", "shinyjs", "RColorBrewer", "DT", "rgdal", "raster", "data.table", "dplyr", "tidyr", "ggplot2"))
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
library(classInt)

source("mod_shpPoly.R")

mapRaster <- 'Tifs/Eta_MIROC5/Eta_MIROC5_20_Historical_climate_annually_CAPE_19890101_0000_v1.tif'
print(getwd())
r <- raster(mapRaster,layer=10) #raster("nc/oisst-sst.nc")

decades <- seq(1961, 2005, by=1)
lon = -53.9010478
lat = -14.940753

models = c("Eta - 20 km, MIROC5", "Eta - 20km, HADGEM2-ES", "Eta - 5km, HADGEM2-ES", "Eta - 20km, CANESM2-ES", "Eta - 20km, BESM-ES")

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

#Lista das Cidades
cities.labels <- c("Porto Alegre", "Passo Fundo")