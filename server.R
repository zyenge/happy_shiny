library(shiny)
library(ggplot2) 
library(grid) #needed for arrow head

#setwd('personal/happy_shiny/')
df <- read.csv('mvp_exported.csv', na.strings = "NULL")
df$code<-as.factor(df$code)
df_nok <- df[df$code!=4060,]
Q1_dist <- as.data.frame(df_nok$Q1, names='Q1')
Q1_dist$code <- 'All Users'
colnames(Q1_dist) <- c("Q1", "code")
variance_df <-data.frame(aggregate(Q1 ~ code, df, sd))
mean_df <-data.frame(aggregate(Z_Q1 ~ perfer_not, df_nok, mean))


preference_p <- ggplot(df_nok, aes(x=Z_Q1, fill=perfer_not)) + geom_histogram(binwidth=.3, alpha=.5, position="identity")+
    scale_fill_discrete(name="Prefer to do something else?")+
    geom_segment(aes(x =  mean_df[mean_df$perfer_not=="No",]$Z_Q1, y =60, xend = mean_df[mean_df$perfer_not=="No",]$Z_Q1, yend = 0),linetype="dashed",size=1,color='pink',alpha=.7)+    
    geom_segment(aes(x =  mean_df[mean_df$perfer_not=="Yes",]$Z_Q1, y =60, xend = mean_df[mean_df$perfer_not=="Yes",]$Z_Q1, yend = 0),linetype="dashed",size=1,color='lightblue',alpha=.7)+
    geom_segment(aes(x =  mean_df[mean_df$perfer_not=="Not Sure",]$Z_Q1, y =60, xend = mean_df[mean_df$perfer_not=="Not Sure",]$Z_Q1, yend = 0),linetype="dashed",size=1,color='forestgreen',alpha=.7)+
    xlab("Normalized Happiness ( 0 is the average)")


shinyServer(function(input, output) {

	codename <- reactive({
   input$text1
    })

  	#output$text2 <- renderText({
    #codename()
  	#})
	
    

	Q1_Plot <- reactive({
   #one user 
    Q1_p <- subset(df, code==codename(), select=c(Q1,code))
	 Q1_p$code<- factor(Q1_p$code)
	 Q1_personal <- rbind(Q1_p, Q1_dist)
   
  	})
	
  var_plot <- reactive({variance_df$to_clr<- variance_df$code==codename()
    variance_df})
  


  output$Q1_Dist <- renderPlot({
  	
    
    p1<-ggplot(Q1_Plot() , aes(Q1, fill = code)) + geom_density(color="grey" ,alpha = 0.6)+
        xlab("Happiness Score 1~100") + ylab("Density")

    print(p1)
	
  })

  output$Var_Dist <- renderPlot({
    
    
    p2<- ggplot(na.omit(var_plot()), aes(x=reorder(code,-Q1), y=Q1, fill=to_clr)) + geom_bar(stat="identity")
    out_p2<- p2+scale_fill_manual(values=c("#999999", "#E69F00"), 
                       name="",
                       breaks=c("FALSE","TRUE"),labels=c("Other Users", "Your Variance"))+theme(axis.text.x = element_blank())+xlab("Users")+ylab("Happinese Score Variance")+
                        annotate("text", x = 4.5, y = 31, label = "High Variance",color="#000099",size=6)+ annotate("text", x = 21.7, y = 31, label = "Low Variance", color="brown",size=6)+
                         geom_segment(aes(x = 18.5, y = 30.8, xend = 8, yend = 30.8), arrow = arrow(length = unit(0.3, "cm")),size=1.3)+
                         geom_segment(aes(x = 8, y = 30.8, xend = 18.5, yend = 30.8), arrow = arrow(length = unit(0.3, "cm")),size=1.3 )

    
    print(out_p2)
  })
  #output$text2<-renderText(names(mean_df))
  output$preference_hist <- renderPlot({print(preference_p)})
  

}) 
