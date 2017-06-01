shinyUI(bootstrapPage(
  
  tags$style(type = "text/css", "html, body {width:100%;height:100%}"), #tags style para criar estilo css
  leafletOutput("Map", width="100%", height="100%"),
  div(class="outer", #Painel esquerdo principal
      tags$head(includeCSS("www/styles.css")),
      #absolutePanel(top=20, left=60, height=20, width=600, h4("Northwest Territories Future Climate Outlook")),
      absolutePanel(id="controls", top=0, right=0, height=200, width=400,
                    sliderInput("dec", "Década", min=min(decades), max=max(decades), value=max(decades), step=10, sep="", post="s", width="100%"),
                    wellPanel(
                      fluidRow(
                        column(6,
                               selectInput(inputId = "toy", label = "Época do Ano:", choices = toy_list, selected = toy_list[[1]][1])
                        ),
                        column(6,
                               selectInput(inputId = "month", label = "Meses do Ano:", choices = month_list, selected = month_list[[1]][1])
                        )
                      ),
                      fluidRow(
                        column(12,
                               selectInput(inputId = "modelo", label = "Modelo:", choices = modelos, selected = modelos[1])
                        )
                      ),
                        fluidRow(
                        column(12,
                               selectInput(inputId = "variable", label = "Variável:", choices = var.labels, selected = var.labels[1])
                        )
                      ),
                      fluidRow(
                        column(12,
                               selectInput("location", "Cidades", choices = cities.labels, selected="", width="100%")
                               )
                      ),
                      fluidRow(column(12, downloadButton("dl_raster", "Get Map (.tif)", class="btn-block")))
                    ))
      )

  
))