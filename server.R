library(datasets)
library(shiny)
library(ggplot2) 


df <- read.csv('mvp_exported.csv', na.strings = "NULL")
df_nok <- df[df$email!=' ',]
Q1_dist <- as.data.frame(df_nok$Q1, names='Q1')
Q1_dist$email <- 'all'
colnames(Q1_dist) <- c("Q1", "email")
#data <- Q1_personal
  

shinyServer(function(input, output) {

	formulaText <- reactive({
    input$text1
  	})
  	output$text2 <- renderText({
    formulaText()
  	})
	

	formulaplot <- reactive({
    
    Q1_p <- subset(df_nok, email ==input$text1, select=c(Q1,email))
	Q1_p$email<- factor(Q1_p$email)
	Q1_personal <- rbind(Q1_p, Q1_dist)
  	})
	
	
  # Return the formula text for printing as a caption
  

  output$featurePlot <- renderPlot({
  	
    
    p<-ggplot(formulaplot() , aes(Q1, fill = email)) + geom_density(alpha = 0.2)

    print(p)
	
  })
}) 
