shinyUI(
  
  fluidPage(
    tags$head(includeScript("google-analytics.js")),
    titlePanel("Happiness Report"),

    sidebarLayout(

      sidebarPanel( 
        textInput(inputId="text1", label = "Enter your code here"),
        actionButton('Submit','Submit'),
        textOutput("code_error"),
        h4(textOutput("hello")),
        h5(textOutput("per_act")),
        br(),
        h5(textOutput("per_loc"))

        
                
    ),

    mainPanel(
	  h3('Happiness Survey Summary Statistics'),
  	  tableOutput("summary_table"),
	  br(),
	  p("'Average Respondent'(AR) responded about 20 times to our emails. We sent around 65 emails to each user, so this is an average response rate slightly under 33%, or 1 out of every 3 emails. AR has an average happiness score of 68.65, with a standard deviation of 8.84. AR's median score is 69; observing the Lower/Upper quartile, we know that 50% of AR's responses fell between 63 and 74. Something interesting here: AR can supply a score between 1 and 100, but AR's minimum score = 50, and AR's maximum score = 81. This means most people don't use the entire range (1-100). "),
      h3('Happiness Score Distribution: You vs. all Users'),
      plotOutput("Q1_Dist"),
      p("*For users with more than 5 responses"),
      p("If your peak is right to the overall users' distribution, you may be happier than most people (in this survey anyway)"),
      br(),
      br(),
      
      h3('Happiness Swings'),
      plotOutput("Var_Dist"),
      br(),
	  p("Each bar is a person. The y-axis is the variance of each person's happiness score. Variance is a measure of how much the score deviates from the mean."),
      textOutput("happiness_swings_text"),
      br(),
      br(),
      h3('True to yourself: When in doubt, do something else'),
      h5("Answer to Question 4: Would you rather be doing something other than what you're doing right now?"),
      plotOutput("preference_hist"),
      br(),
      p("The Y-axis is the normalized happiness score. Therefore, the average happiness is 0.0. For most people (gray bars), when they answer 'No', you can see that people report scores significantly higher than the group mean. Intuitively, that makes sense. If you'd rather not be doing something else, you're probably a little happier than if you answered 'Yes'. When people answer 'Not Sure', their happiness is usually below the group mean. So, most people are slightly unhappier when reporting 'Not Sure', So ... when you feel like this, (if you can afford to do so), do something else :)"),
	  br(),
	  br(),
	  h3('Happiest Time'),
	  h5('By how much does your self reported happiness score vary depending on the day of the week? Time of the day? And, how do you compare to other people?'),
      plotOutput("Var_Time_Dist"),
      p("People report higher scores on Friday, Saturday, and Sunday (Go figure)! Check out that change between Thursday and Friday. It's like a switch is flipped and people are just happier. "),
      p("Mondays are the worst. By a lot. People dislike Mondays more than they like Friday/Saturday/Sunday!"),
	  p("As for the time of day: Mornings are pretty nuetral, right? Nope. If you aren't one, haven't you ever come across 'Morning People'? They do exist :). Here's how we know this: A slightly closer look at the data reveals that there's three groups of people in our data: One really likes mornings, Another is indifferent, and the Third dislikes mornings. All of this averages out to a nuetral feeling (around 0.0 mean variation for the group), so it's hard to see the disparity here."),
	  br(),
      br(),
      h3("Shopping makes you smile, work does not (surprise, surprise)"),
      h4("Exercising feels better than eating? could it be?... "),
      br(),
      plotOutput("loc_act_text",height=500),
      h5("Top to bottom, from happy to unhappy decsending, blue font means below average unhappy.."),
      br(),
      br(),
      h3("Happiest location + activity combo"),
      h4("If you are slacking off at work, you are way better off chatting with someone than browsing internet. hell, browsing internet is in the negative, it doesn't matter where you are"),
      h4("Exercising tops eating again, talk to my tummy"),
      h4("Stay home and cook people, eating out does not agree with you"),
      plotOutput("loc_act_p",height=600),
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
