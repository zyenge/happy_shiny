library(datasets)
library(shiny)
library(ggplot2) 


df <- read.csv('mvp_exported.csv', na.strings = "NULL")
df_nok <- df[df$code!=4060,]
Q1_dist <- as.data.frame(df_nok$Q1, names='Q1')
Q1_dist$code <- 'All Users'
colnames(Q1_dist) <- c("Q1", "code")
#data <- Q1_personal
  

shinyServer(function(input, output) {

	formulaText <- reactive({
    input$text1
  	})
  	output$text2 <- renderText({
    formulaText()
  	})
	

	formulaplot <- reactive({
   #one user 
    Q1_p <- subset(df, code==input$text1, select=c(Q1,code))
	Q1_p$code<- factor(Q1_p$code)
	Q1_personal <- rbind(Q1_p, Q1_dist)
  	})
	

  

  output$featurePlot <- renderPlot({
  	
    
    p<-ggplot(formulaplot() , aes(Q1, fill = code)) + geom_density(alpha = 0.2)+
        xlab("Happiness Score 1~100") + ylab("Density")

    print(p)
	
  })
}) 
