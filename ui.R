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
	  h3('1. Summary and Statistics'),
	  br(),
	  p("On average, each person responded about 20 times to our emails. We sent around 65 emails to each person, so this is an average response rate of 1 out of every 3 emails. The overall average happiness score is 68.6, with a standard deviation of 8.8. Assuming people scores follow a normal distribution, about 66% of all scores fall between 60 and 76."),
      div("People score their happiness differently. For example, an 80 could be someone's mean, or it could be someone else's maximum score. Therefore, comparing scores by itself does not tell us that one person is happier than another. Instead, we should have a reference point for each person. So, in some of the analyses below, we use a normalized score to compare happiness across users. A normalized score assumes a mean of 0 and a standard deviation of 1. With everyone having a mean happiness of 0, it's easier to tell if one person is relatively happier."),
	  br(),
	  tableOutput("summary_table"),
	  br(),
	  h3('2. Happiness Score Distribution: You vs. all Users'),
      plotOutput("Q1_Dist"),
	  p("In Grey: The average person has a mean of 68.6, and a standard deviation of 8.8. We generated a normal distribution with these values."),
	  p("If your own distribution of responses is to the right of the average persons' distribution, you score yourself happier than most people (in this survey anyway)."),
    br(),      
    h3('3. Happiness Swings'),
    plotOutput("Var_Dist"),
    br(),
    p("Each bar shows a different person's variance in his/her responses. Variance is a measure of how much the score deviates from the mean."),
    textOutput("happiness_swings_text"),
    br(),
    br(),
    h3("4. Would you rather be doing something other than what you're doing right now?"),
    h5("If it's not a 'No', it's probably a 'Yes'."),
	  plotOutput("preference_hist"),
    br(),
    p("When people answer 'No', they are happier (average is at 0). Intuitively, that makes sense. If you'd rather not be doing something else, you're probably a little happier than if you answered 'Yes'. When people answer 'Not Sure', they report lower than average scores."),
	  p("Just like a definite 'Yes', If you're 'Not sure', you'll probably be happier doing something else."),
	  br(),
	  br(),
	  h3('5. Happiest Time'),
	  h5('How much does your happiness change over the week? And, during the day? Also, how do you compare to other people?'),
      plotOutput("Var_Time_Dist"),
      p("People report higher scores on Friday, Saturday, and Sunday (Go figure)! Check out that change between Thursday and Friday. It's like a switch is flipped and people are just happier. "),
      p("Mondays are the worst. By a lot. People dislike Mondays more than they like any other day"),
	  p("As for the time of day: Mornings are pretty nuetral, right? Nope. There are three clusters of responses in the Morning group: one group really likes mornings, another group is indifferent, and the third group really dislikes mornings. All of this averages out to a nuetral feeling (around 0.0 mean variation for the group), so it's hard to see the disparity here."),
	  br(),
    br(),
	  h3("6. Shopping makes you smile, work does not (surprise, surprise)."),
      h4("Exercising feels better than eating? Could it be ... ? "),
	  br(),
    
	  h5("The text is ordered from happiest (top, pink, above average) to unhappiest (bottom, blue, below average)."),

	  plotOutput("loc_act_text",height=500),
	  p("The above charts show the aggregated result from all users. You can see your own activity/location preference summary on the top left panel. If you don't see it, we don't have sufficient data for you*."),
    br(),
    br(),
    h3("7. Happiest Location & Activity Pair"),
    h4("If you are slacking off at work, you are way better off chatting with someone than browsing internet. Heck, browsing internet is in the negative, regardless of where you are."),
    h4("Exercising trumps eating, again!"),
    h4("Stay home and cook people! Eating out does not agree with you."),
    plotOutput("loc_act_p",height=600),
	  p("The above chart shows the aggregated result from all users. We do not have this for individuals due to lack of data."),
	  br(),
	  br(),

      p("*Notes:
	  	  For group happiness rankings by location and activity, we filtered out the options that fewer than 5 users had selected. 
          e.g. if there is only one entry for 'Grooming' at 'work', and for some odd reason it's scored really high, it won't be counted because there are no other 'Grooming' at 'work' responses. We will need the same responses from at least 5 different users to calculate the normalized mean, and include it in the ranking.
          For all analyses comparing means, we have ran ANOVA tests showing that the means are different, with a significant p value.
		  For all analyses, users' data are included only if they have submitted at least 5 responses.")
       
	  
    )
	
  )
)
)
