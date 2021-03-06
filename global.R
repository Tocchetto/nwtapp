#pkgs <- list("shiny", "shinyBS", "shinyjs", "leaflet", "rgdal", "raster", "data.table", "dplyr", "tidyr", "ggplot2")
#suppressMessages(lapply(pkgs, function(x) library(x, character.only=T)))

suppressMessages({
  library(shiny)
  library(shinyBS)
  library(shinyjs)
  library(leaflet)
  library(DT)
  library(rgdal)
  library(raster)
  library(data.table)
  library(dplyr)
  library(tidyr)
  library(ggplot2)
})

source("mod_shpPoly.R")

options(warn = -1) # # haven't figured out how to suppress warning from colors(.)

load("nwt_communities.RData")
load("nwt_data_pr_tas_CRU32_1961_1990_climatology.RData")
load("nwt_locations.RData")

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
toy_list <- list(Season=season.labels, Month=month.abb)

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




