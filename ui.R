shinyUI(

  fluidPage(

    titlePanel("Happiness Report"),

    sidebarLayout(

      sidebarPanel( 
        textInput(inputId="text1", label = "Enter your code here"),
        submitButton('Submit')
        
                
    ),

    mainPanel(
      h4('Happiness Score Distribution: You vs. all Users'),
      textOutput('text2'),
      plotOutput("featurePlot")
    )
  )
)
)