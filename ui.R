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
      #textOutput('oid2'),
      plotOutput("Q1_Dist"),
      p("*For users with more than 5 responses"),
      p("If your peak is right to the overall users' distribution, you may be happier than most people (in this survey anyway)"),
      br(),
      br(),
      
      h4('Happiness Swings'),
      plotOutput("Var_Dist"),
      br(),
      p("If you are more to the left, you've got have a strong heart for the big ups and downs in you life."),
      p("If you are more to the right..your happiness level is so stable..what are you? a rock?"),
      
      br(),
      br(),
      h4('True to yourself: When in double, do something else'),
      plotOutput("preference_hist"),
      br(),
      p("The pink bars are happier than the blue bars, and the green bars in the middle don't know what they want..."),
      p("You are slightly unhappy if you are not sure about whether you'd prefer to do something else or not, so, get up and go do something else")
      
    )
  )
)
)