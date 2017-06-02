#source("./BusinessLogic.R")
shinyServer(function(input, output, session) {

  # Initialize map
  output$Map <- renderLeaflet({
    leaflet(countries) %>% setView(lon, lat, 4) %>% addTiles() %>% #Centraliza o mapa
    #Adiciona os polygonos do shp/geojson
    addPolygons(stroke = FALSE, smoothFactor = 0.2, fillOpacity = 1,
                color = ~pal(gdp_md_est)
    ) %>%
    addLegend("bottomright", pal = pal, values = ~gdp_md_est,
              title = input$variable,
              labFormat = labelFormat(suffix = getPrefix(input$variable)),
              opacity = 1
    )

  })
  
  
})


