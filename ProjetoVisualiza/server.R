source("./BusinessLogic.R")
shinyServer(function(input, output, session) {

  # Initialize map
  output$Map <- renderLeaflet({
    leaflet() %>% addTiles() %>%
      addRasterImage(getMapRaster(input$variable), colors = pal, opacity = 0.8) %>% #Fazer função getRaster
      addLegend("bottomright", pal = pal, values = values(getMapRaster(input$variable)),
                          title = input$variable,
                          labFormat = labelFormat(suffix = getPrefix(input$variable)),
                          opacity = 1
                )
  })
  output$rasterDownload <- downloadHandler(
    filename="raster.tif",
    content=function(file){
      writeRaster(getMapRaster(input$variable), file, format="GTiff", overwrite=TRUE)
    }
  )
  
  shp <- callModule(shpPoly, "user_shapefile", r=r)
  
  
})


