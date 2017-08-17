source("./BusinessLogic.R")
shinyServer(function(input, output, session) {
  
  observeEvent(input$user_input,{
    aux = unzip(input$user_input$data, exdir=tempdir())
    userShapeFileName = sub(pattern = "(.*)\\..*$", replacement = "\\1", basename(aux[1]))
    print(input$user_input$name)
    #print(input$header)
    userShape <- readOGR(tempdir(), userShapeFileName, encoding='UTF-8')
    #print(userShape)
    
    leafletProxy('Map') %>%
     addPolygons(
       data = userShape, 
       stroke = TRUE, fillOpacity = 0.5, smoothFactor = 0.5,
       color = "black")
    
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


