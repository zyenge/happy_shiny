shinyUI(

  fluidPage(

    titlePanel("Happiness Score Distribution"),

    sidebarLayout(

      sidebarPanel(
          
        textInput(inputId="text1", label = "email address"),
        submitButton('Submit')
        
                
    ),

    mainPanel(
      p('Your email address'),
      textOutput('text2'),
      plotOutput("featurePlot")
    )
  )
)
)