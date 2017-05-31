

shinyServer(function(input, output, session) {

  output$map <- renderLeaflet({ #retorna o mapa que é um objeto
    leaflet() %>% setView(lng = -53.9010478, lat = -14.940753, zoom = 4) %>% addTiles()

  })
  
})


