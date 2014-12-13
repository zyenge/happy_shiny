shinyUI(

  fluidPage(

    titlePanel("Happiness Report"),

    sidebarLayout(

      sidebarPanel( 
        textInput(inputId="text1", label = "Enter your code here"),
        actionButton('Submit','Submit'),
        textOutput("error_test"),
        textOutput("code_error")
        
                
    ),

    mainPanel(
      h3('Happiness Score Distribution: You vs. all Users'),
      #textOutput('text2'),
      plotOutput("Q1_Dist"),
      p("*For users with more than 5 responses"),
      p("If your peak is right to the overall users' distribution, you may be happier than most people (in this survey anyway)"),
      br(),
      br(),
      
      h3('Happiness Swings'),
      plotOutput("Var_Dist"),
      br(),
      p("If you are more to the left, you've got have a strong heart for the big ups and downs in you life."),
      p("If you are more to the right..your happiness level is so stable..what are you? a rock?"),      
      br(),
      br(),
      h3('True to yourself: When in doubt, do something else'),
      h5("Answer to Question 4: Would you rather be doing something other than what you're doing right now?"),
      plotOutput("preference_hist"),
      br(),
      p("X-axis is normalized happiness score with average happiness at 0. Pink bars: people who prefer not to do something else; Blue bars: People who prefer to do something else. Green bars: People who aren't sure..."),
      p("Dotted lines show the average within each group. Intuitively, Pink group is happier than the Blue group. As for the times that are 'not sure', it's left to the 0. So you are slightly unhappy when you are not sure, so.. get up and go do something else :)"),
	    br(),
	     br(),
	     h3('Happiest Day of Week'),
      plotOutput("Var_Time_Dist"),
      br(),
      br(),
      h3("Shopping makes you smile, work does not (surprise, surprise)"),
      h4("Exercising feels better than eating? could it be?... "),
      br(),
      plotOutput("loc_act_text"),
      h5("Top to bottom, from happy to unhappy decsending, blue font means below average unhappy.."),
      br(),
      br(),
      h3("Happiest location + activity combo"),
      h4("If you are slacking off at work, you are way better off chatting with someone than browsing internet. hell, browsing internet is in the negative, it doesn't matter where you are"),
      h4("Exercising tops eating again, talk to my tummy"),
      h4("Stay home and cook people, eating out does not agree with you"),
      plotOutput("loc_act_p"),
      p(" **TODO**  "),
      p(" **Happiest time of the day**  "),



      p("*Note in the end:
          For all happiest rankings by location and activity, we filtered out the options with less than 5 users. 
          E.g. if there is only one entry for 'Grooming' at 'work', and for some odd reason it's scored really high happiness, it won't be counted because there are no other 'Grooming' at 'work' activity. We will need same entries from at least 5 different users to calcualte the normalized mean, and rank them.
          For the average comparisons above, unless addressed otherwise, we have ran ANOVA tests, the means are different, with a significant p value")
       
	  
    )
  )
)
)