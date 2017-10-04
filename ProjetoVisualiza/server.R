source("./BusinessLogic.R")
shinyServer(function(input, output, session) {
  
  observeEvent(input$user_input,{
    variable = input$variable
    dec = input$dec
    variableType = input$variableType
    
    aux = unzip(input$user_input$data, exdir=tempdir())
    userShapeFileName = sub(pattern = "(.*)\\..*$", replacement = "\\1", basename(aux[1]))
    userShape <- readOGR(tempdir(), userShapeFileName, encoding='UTF-8')
    
    mapRaster = getMapRaster(variable, dec, variableType)
    tabela    = data.frame(coordinates(mapRaster))
    colnames(tabela) <- c("LONGITUDE", "LATITUDE")
    
    tabela["values"] <- values(mapRaster)
    pontos <- tabela[,c(1,2,3)]
    coordinates(pontos) <- c("LONGITUDE", "LATITUDE")
    proj4string(pontos) <- proj4string(userShape)
    
    new_pontos <- tabela[!is.na(over(pontos, as(userShape, "SpatialPolygons"))),]
    #View(new_pontos)
    lon      = new_pontos[,1] 
    lat      = new_pontos[,2] 
    variavel = new_pontos[,3] 
    #View(new_pontos)
    colors = getUserShapeColor(variable)
    print(colors)
    #print(colorNumeric(getUserShapeColor(variable), getShapeValues(variable)))
    brks<-classIntervals(variavel, n=length(colors), style="quantile")
    brks<- brks$brks #plot the map
    
    leafletProxy('Map') %>% clearControls() %>% addTiles() %>% addRectangles(
      lng1=lon-0.098, lat1=lat-0.098,
      lng2=lon+0.098, lat2=lat+0.098,
      color=colors[findInterval(variavel, brks,all.inside=TRUE)],
      weight = 0,
      opacity = 0.8) %>%
    addLegend("bottomleft", pal = colorNumeric(colors, brks,na.color = "transparent"),
                            values = brks,
                            title = variable,
                            labFormat = labelFormat(suffix = getSuffix(variable)),
                            opacity = 1
      )
    
    unlink(paste(tempdir(), "/*", sep=""))
  })
  
  output$Map <- renderLeaflet({
    variable = input$variable
    dec = input$dec
    variableType = input$variableType
    
    #Mudança de Tipo de Dado
    if(variableType == "Historical" && dec > 2005){
      decades <- seq(1961, 2005, by=1)
      updateSliderInput(session, "dec", "Década", min=min(decades), max=max(decades), value=max(decades), step=1)
    }
    if(variableType != "Historical" && dec < 2006){
      decades <- seq(2006, 2099, by=1)
      updateSliderInput(session, "dec", "Década", min=min(decades), max=max(decades), value=max(decades), step=1)
    }
    
    if(variableType == "Historical" && dec < 2006 || variableType == "RCP4.5" && dec > 2005 || variableType == "RCP8.5" && dec > 2005 ){
      pal = getMapPal(variable, dec, variableType)
      rasterToPlot = getMapRaster(variable, dec, variableType)
      leaflet(Map) %>% addTiles() %>% setView(lng = -60.316671, lat = -15.377004, zoom = 4) %>%
        addRasterImage(rasterToPlot, colors = pal, opacity = 0.8) %>% #Fazer função getRaster
        addLegend("bottomleft", pal = pal, values = values(rasterToPlot),
                            title = variable,
                            labFormat = labelFormat(suffix = getSuffix(variable)),
                            opacity = 1
                  )
    }
  })
  
  output$rasterDownload <- downloadHandler(
    filename="raster.tif",
    content=function(file){
      writeRaster(getMapRaster(input$variable, input$dec, input$variableType), file, format="GTiff", overwrite=TRUE)
    }
  )
  
  shp <- callModule(shpPoly, "user_shapefile", r=r)
})


