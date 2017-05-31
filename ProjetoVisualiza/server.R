shinyServer(function(input, output, session) {

  # Initialize map
  output$Map <- renderLeaflet({
    leaflet() %>% setView(lon, lat, 4) %>% addTiles() #%>% #Centraliza o mapa
  })
  
  
})


