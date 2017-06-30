source("./BusinessLogic.R")
shinyServer(function(input, output, session) {
  # output$dec <- renderPlot({
  #   print(input$variableType)
  #   if(input$variableType == "Historical"){
  #     decades <- seq(1960, 2005, by=1)
  #   }
  #   else{
  #     decades <- seq(2006, 2099, by=1)
  #   }
  # })
  # output$variableType <- renderPlot({
  #   print(input$variableType)
  #   if(input$variableType == "Historical"){
  #     decades <- seq(1960, 2005, by=1)
  #   }
  #   else{
  #     decades <- seq(2006, 2099, by=1)
  #   }
  # })
  observe({
    if(input$variableType != "Historical"){
      decades <- seq(2006, 2099, by=1)
    }else{
      decades <- seq(1960, 2005, by=1)
    }
    updateSliderInput(session, "dec", "Década", min=min(decades), max=max(decades), value=max(decades), step=1)
  })
  # Initialize map
  output$Map <- renderLeaflet({
    pal = getMapPal(input$variable, input$dec, input$variableType)
    rasterToPlot = getMapRaster(input$variable, input$dec, input$variableType)
    leaflet() %>% addTiles() %>% setView(lng = -60.316671, lat = -15.377004, zoom = 4) %>%
      addRasterImage(rasterToPlot, colors = pal, opacity = 0.8) %>% #Fazer função getRaster
      addLegend("bottomleft", pal = pal, values = values(rasterToPlot),
                          title = input$variable,
                          labFormat = labelFormat(suffix = getPrefix(input$variable)),
                          opacity = 1
                )
  })
  # output$rasterDownload <- downloadHandler(
  #   filename="raster.tif",
  #   content=function(file){
  #     writeRaster(rasterToPlot, file, format="GTiff", overwrite=TRUE)
  #   }
  # )
  
  shp <- callModule(shpPoly, "user_shapefile", r=r)
  
  # Shp_plot_ht <- reactive({
  #   if(is.null(shp())) return(0)
  #   e <- extent(shp()$shp_original)[]
  #   round(100*(e[4]-e[3])/(e[2]-e[1]))
  # })
  # 
  # output$Shp_Plot <- renderPlot({
  #   if(!is.null(shp())){
  #     cl <- class(shp()$shp_original)
  #     if(cl=="SpatialPointsDataFrame"){
  #       d <- data.frame(shp()$shp_original@coords, group=1)
  #       names(d) <- c("long", "lat", "group")
  #     } else d <- fortify(shp()$shp_original)
  #     g <- ggplot(d, aes(x=long, y=lat, group=group)) + coord_equal() + theme_blank
  #     if(cl=="SpatialPolygonsDataFrame"){
  #       g <- g + geom_polygon(fill="steelblue4") + geom_path(colour="gray20")
  #       if("hole" %in% names(d)) g <- g + geom_polygon(data=filter(d, hole==TRUE), fill="white")
  #     } else if(cl=="SpatialLinesDataFrame"){
  #       g <- g + geom_path(colour="steelblue4", size=2)
  #     } else {
  #       g <- g + geom_point(colour="steelblue4", size=2)
  #     }
  #   }
  #   g
  # }, height=function() Shp_plot_ht(), bg="transparent")
  # 
  # output$Mask_in_use <- renderUI({ if(is.null(shp())) h4("None") else plotOutput("Shp_Plot", height="auto") })
  # 
  # output$Shp_On <- renderUI({ if(is.null(shp())) br() else checkboxInput("shp_on", "Shapefile active", TRUE) })
  # 
  # # prepping GCM/CRU, raw/deltas, months/seasons, models/stats, temp/precip
  # CRU_ras <- reactive({
  #   idx <- match(input$toy, names(cru6190[[Variable()]]))
  #   subset(cru6190[[Variable()]], idx) %>% crop(Extent())
  # })
  # 
  # ras <- reactive({
  #   #dec.idx <- seq_along(unique(rv$d$Decade)) #which(decades==input$dec)
  #   mon.idx <- switch(input$toy, Winter=c(1,2,12), Spring=3:5, Summer=6:8, Fall=9:11)
  #   mo <- if(Monthly()) mon_index() else mon.idx
  #   p <- input$mod_or_stat
  #   if(p %in% models){
  #     x <- filter(rv$d, Model==p)$Maps[[1]][[1]] %>% subset(mo) %>% crop(Extent())
  #     if(!Monthly()) x <- calc(x, sea_func()) %>% round(1)
  #     if(input$deltas & Variable()=="pr"){
  #       x <- round(x / CRU_ras(), 2)
  #       x[is.infinite(x)] <- NA
  #     }
  #     if(input$deltas & Variable()=="tas") x <- x - CRU_ras()
  #   } else {
  #     x <- group_by(rv$d, Model, add=T) %>% do(., Maps=subset(.$Maps[[1]][[1]], mo) %>% crop(Extent()) %>% calc(sea_func()))
  #     x <- stat_func()(brick(x$Maps))
  #     if(p=="Spread") x <- calc(x, function(x) x[2]-x[1])
  #     x <- round(x, 1)
  #   }
  #   if(!is.null(shp()) && (is.null(input$shp_on) || input$shp_on)){
  #     if(!is.null(raster::intersect(extent(x), extent(shp()$shp)))){
  #       x.masked <- try(crop(x, shp()$shp) %>% mask(shp()$shp), TRUE)
  #       if(!(class(x.masked)=="try-error") && length(which(!is.na(x.masked[]))) > 2) x <- x.masked
  #     }
  #   }
  #   x[is.nan(x)] <- NA
  #   x
  # })
  # 
  # # store raster values once, separate from raster object
  # ras_vals <- reactive({ values(ras()) })
  # 
  # output$dl_raster <- downloadHandler(
  #   filename="rasterLayer.tif",
  #   content=function(file){
  #     rasfile <- writeRaster(ras(), file, format="GTiff", overwrite=TRUE)
  #     file.rename(rasfile@file@name, file)
  #   }
  # )
  # 
  # # Colors and color palettes
  # Colors <- reactive({
  #   req(input$colpal)
  #   pal <- input$colpal
  #   custom.colors <- c(input$col_low, input$col_med, input$col_high)
  #   if(pal %in% sq) custom.colors <- custom.colors[c(1,3)]
  #   if(pal %in% c("Custom div", "Custom seq")) custom.colors else pal
  # })
  # 
  # # tooltips
  # observe({
  #   if(length(input$ttips) && input$ttips){
  #     addTooltip(session, "dec", "Maps show decadal averages of projected climate.", "left", options=list(container="body"))
  #     addTooltip(session, "toy", "3-month seasons or specific months. Winter is Dec-Feb and so on.", "left", options=list(container="body"))
  #     addTooltip(session, "rcp", "Representative Concentration Pathways, covering a range of possible future climates based on atmospheric greenhouse gas concentrations.", "left", options=list(container="body"))
  #     addTooltip(session, "mod_or_stat", "Individual climate models or a statistic combining all five.", "left", options=list(container="body"))
  #     addTooltip(session, "location", "Enter a community. Menu filters as you type. Or select a community on map.", "left", options=list(container="body"))
  #     addTooltip(session, "deltas", "Display projected change from 1961-1990 baseline average instead of raw climate values.", "right", options=list(container="body"))
  #     addTooltip(session, "show_communities", "Clickable locations reveal special app-provided community data.
  #       These are different from map markers showing user-uploaded shapefile points.", "right", options=list(container="body"))
  #     addTooltip(session, "lat_range", "If cropped to a rectangle with insufficient data, the map will revert to its full extent.", "left", options=list(container="body"))
  #     addTooltip(session, "btn_modal_shp", "Upload a polygon shapefile for arbitrary masking.
  #       Once uploaded, the mask can be toggled on or off and may be combined with lon/lat sliders. Using a mask adds some delay.", "bottom", options=list(container="body"))
  #   } else {
  #     removeTooltip(session, "dec")
  #     removeTooltip(session, "toy")
  #     removeTooltip(session, "rcp")
  #     removeTooltip(session, "mod_or_stat")
  #     removeTooltip(session, "location")
  #     removeTooltip(session, "deltas")
  #     removeTooltip(session, "show_communities")
  #     removeTooltip(session, "lat_range")
  #     removeTooltip(session, "btn_modal_shp")
  #   }
  # })
})


