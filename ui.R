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
      p("The Y-axis is the normalized happiness score with average happiness at 0. For the group (gray bars), when people answer 'No', you can see that people report scores >.3 deviations above the group mean. Intuitively, that makes sense. If you'd rather not be doing something else, you're probably a little happier than if you answered 'Yes'. Indeed, we see that this is the case for most people. As for the times that people are 'Not Sure', it's below 0. So, most are slightly unhappier when reporting 'Not Sure', So ... when you feel like this, (if you can afford to do so), do something else :)"),
	  p("*Note: for your nerds out there, we ran an ANOVA test to compare the means across groups, the means are significantly different, with a p value <.0005"),
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
      plotOutput("loc_act_text",height=800),
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
