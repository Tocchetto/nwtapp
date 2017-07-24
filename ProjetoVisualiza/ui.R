shinyUI(bootstrapPage(
  
  tags$style(type = "text/css", "html, body {width:100%;height:100%}"), #tags style para criar estilo css
  leafletOutput("Map", width="100%", height="100%"),
  div(class="outer", #Painel esquerdo principal
      tags$head(includeCSS("www/styles.css")),
      #absolutePanel(top=20, left=60, height=20, width=600, h4("Northwest Territories Future Climate Outlook")),
      absolutePanel(id="controls", top=0, right=0, height=200, width=450,
                    sliderInput("dec", "Ano", min=min(decades), max=max(decades), value=max(decades), step=1, sep="", post="", width="100%"),
                    #shpPolyInput("user_shapefile", "Upload polygon shapefile", "btn_modal_shp"),
                    wellPanel(
                      # fluidRow(
                      #   column(6,
                      #          selectInput(inputId = "toy", label = "Época do Ano:", choices = toy_list, selected = toy_list[[1]][1])
                      #   ),
                      #   column(6,
                      #          selectInput(inputId = "month", label = "Meses do Ano:", choices = month_list, selected = month_list[[1]][1])
                      #   )
                      # ),
                      fluidRow(
                        column(12,
                               selectInput(inputId = "model", label = "Modelo:", choices = models, selected = models[1])
                        )
                      ),
                        fluidRow(
                        column(12,
                               selectInput(inputId = "variable", label = "Variável:", choices = var.labels, selected = var.labels[1])
                        ),
                        column(12,
                               radioButtons("variableType", "Tipo do Dado", choices = list("Historical", "RCP4.5", "RCP8.5"), selected = "Historical", inline = TRUE)
                        )
                      ),
                      # fluidRow(
                      #   column(12,
                      #          selectInput("location", "Cidades/Aeroportos", choices = cities.labels, selected="", width="100%")
                      #   )
                      # ),
                      fluidRow(
                      column(12,
                             fileInput('user_input', 'Upload ShapeFile',
                                        accept=c('shp/zip', 
                                                 '.shp', 
                                                 '.zip')) #accept=c('.shp','.dbf','.sbn','.sbx','.shx',".prj"), multiple=TRUE
                            ),
                            uiOutput("user_shp")
                      ),
                      fluidRow(
                        column(12, 
                               actionButton("applyShape", "Apply Uploaded Shape", class="btn-block")
                        )
                      ),
                      fluidRow(
                        # column(6,
                        #        actionButton("uploadShape", "Upload shapefile", class="btn-block"),
                        #        uiOutput("Shp_On")
                        # ),
                        column(12, 
                               downloadButton("rasterDownload", "Get Map (.tif)", class="btn-block")
                        )
                      )
                    ))
      )

  
))