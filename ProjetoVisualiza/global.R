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

decades <- seq(1960, 2099, by=1)
lon = -53.9010478
lat = -14.940753
#Month vai receber a abreviação de todos os meses do ano, executar: month.abb para ver
#Season vai recever os nomes das estações do ano: "Winter" "Spring" "Summer" "Fall"
#Então toy_list terá 2 vetores, um com as estações e outro com os mêses: toy_list$Season e toy_list$Month
#list(Season = ("Inverno", "Primavera", "Verão", "Outono"), Month = ("Jan" "Fev" "Mar" "Abr" "Maio" "Jun" "Jul" "Aug" "Set" "Out" "Nov" "Dez")) -> isso nao funciona...
season.labels <- c("Inverno","Primavera","Verão","Outono")
toy_list <- list(Season=season.labels, Month=month.abb)

#Lista das Variáveis
var.labels <- c("Temperatura", "Pressão", "Umidade")
cities.labels <- c("Porto Alegre", "Passo Fundo")