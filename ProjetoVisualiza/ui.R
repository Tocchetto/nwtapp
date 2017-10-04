shinyUI(bootstrapPage(
  
  tags$style(type = "text/css", "html, body {width:100%;height:100%}"), #tags style para criar estilo css
  leafletOutput("Map", width="100%", height="100%"),
  div(class="outer", #Painel esquerdo principal
      tags$head(includeCSS("www/styles.css")),
      absolutePanel(id="controls", top=0, right=0, height=200, width=450,
                    sliderInput("dec", "Ano", min=min(decades), max=max(decades), value=max(decades), step=1, sep="", post="", width="100%"),
                    wellPanel(
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
                      fluidRow(
                      column(12,
                             fileInput('user_input', 'Upload ShapeFile', multiple = TRUE, accept = c('zip', '.zip')) # ,accept=c('shp/zip', '.shp', '.zip') #accept=c('.shp','.dbf','.sbn','.sbx','.shx',".prj"), multiple=TRUE
                            ),
                            uiOutput("user_shp")
                      ),
                      fluidRow(
                        column(12, 
                               downloadButton("rasterDownload", "Get Map (.tif)", class="btn-block")
                        )
                      )
                    ))
      )

  
))