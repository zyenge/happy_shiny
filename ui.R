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
      h4('True to yourself: When in doubt, do something else'),
      h5("Answer to Question 4: Would you rather be doing something other than what you're doing right now?"),
      plotOutput("preference_hist"),
      br(),
      p("X-axis is normalized happiness score with average happiness at 0. Pink bars: people who prefer not to do something else; Blue bars: People who prefer to do something else. Green bars: People who aren't sure..."),
      p("Dotted lines show the average within each group. Intuitively, Pink group is happier than the Blue group. As for the times that are 'not sure', it's left to the 0. So you are slightly unhappy when you are not sure, so.. get up and go do something else :)"),
	    p("*Note: for your nerds out there, we ran an ANOVA test to compare the means across groups, the means are significantly different, with a <0.005 p value"),
	  br(),
	  br(),
	  h4('Happiness Day'),
      plotOutput("Var_Time_Dist"),
      
      p(" **TODO**  ")
	  
    )
  )
)
)