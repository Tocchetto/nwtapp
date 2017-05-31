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

shinyUI(bootstrapPage(
  
  tags$style(type = "text/css", "html, body {width:100%;height:100%}"), #tags style para criar estilo css 
  leafletOutput("map", width = "100%", height = "100%"),
  
  absolutePanel(top = 10, right = 10, #Cria um painel cujo conteúdo está posicionado top 10 e right 10.
                sliderInput("range", "Década", min(quakes$mag), max(quakes$mag), #Constrói um widget de controle deslizante
                            value = range(quakes$mag), step = 0.1
                ))


)
)