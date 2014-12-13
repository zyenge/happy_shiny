library(shiny)
library(ggplot2) 
library(grid)
library(gridExtra) #needed for arrow head
#library(RODBC)
library(sqldf)

#setwd('personal/happy_shiny/')
df <- read.csv('mvp_exported.csv', na.strings = "NULL")
df$code<-as.factor(df$code)
df_nok <- df[df$code!=4060,]
Q1_dist <- as.data.frame(df_nok$Q1, names='Q1')
Q1_dist$code <- 'All Users'
colnames(Q1_dist) <- c("Q1", "code")
variance_df <-data.frame(aggregate(Q1 ~ code, df, sd))

#########
# mysql <-odbcConnect("local_mysql")
# loc_act <- sqlQuery(mysql, "
# SELECT case when location<>'Other' then location else Q2_Other end as Location,
# case when act<>'Other' then act else Q3_Other end as act,
#  count(distinct code) user_cnt,  count(*) cnt, avg(Z_q1) 
# FROM test.mvp_exported group by location, act having user_cnt>5
# ;
# ");
# close(mysql)
###

code_list <- sqldf("select distinct code from df")$code

loc_act_df <- sqldf("SELECT case when location<>'Other' then location else Q2_Other end as loc,
case when act<>'Other' then act else Q3_Other end as act,
 count(distinct code) user_cnt,  count(*) response_cnt, avg(Z_q1) avg_Q1
FROM df_nok group by 1,2  having user_cnt>=5")


best_loc_df <- sqldf("SELECT case when location<>'Other' then location else Q2_Other end as loc,
                    count(distinct code) user_cnt,  count(*)  response_cnt, avg(Z_q1)  avg_Q1
                    FROM df_nok group by 1  having user_cnt>=5
                     order by avg_Q1 desc")

best_act_df <- sqldf("SELECT case when act<>'Other' then act else Q3_Other end as act,
 count(distinct code) user_cnt,  count(*) response_cnt, avg(Z_q1) avg_Q1 
FROM df_nok group by 1  having user_cnt>=5
 order by avg_Q1 desc")


######plot######
loc_act <- ggplot(loc_act_df, aes(x=reorder(avg_Q1,act), y=avg_Q1, fill=loc,label=act)) +
  geom_bar(stat="identity") + coord_flip()+
  geom_text(color='darkorchid4',size=5,fontface='bold',hjust=-0.4, vjust=0.15)+
  annotate("text", x = 17, y = 0.6,  color='white',size=5,fontface='bold',label = "Talking, Conversation")+
  geom_segment(aes(x =0.3  , y =0, xend =17.5 , yend = 0),size=2,color='hotpink2',alpha=0.08)+
  geom_segment(aes(x = 15.5, y = 0.7, xend = 15.5, yend = 0.65), arrow = arrow(length = unit(0.2, "cm")),size=2,color='red')+
  theme(axis.text.y = element_blank())+
  labs(x = "",y = "Average Happiness Score (normalized)")
######plot###########



xy_max=30
best_plot <- function(attr){
  best_p <- ggplot() +  theme( axis.text.x = element_blank(), 
                   axis.text.y = element_blank(),
                   panel.grid.major = element_blank(), 
                   panel.grid.minor = element_blank(), 
                   panel.background = element_rect(fill = "cornsilk2"), 
                   axis.ticks.length = unit(0, "mm"),
                   plot.margin = unit(c(1,1,0,0), "lines")) + labs(x=NULL, y=NULL)+
                  annotate("text", x =0, y = 0, size=0,label = "")+
                  annotate("text", x =xy_max, y =xy_max, size=0,label = "")
  if (attr=='loc'){local_df <- best_loc_df} else {local_df <- best_act_df}
  
  for (i in 1:nrow(local_df) ) {
    if (local_df$avg_Q1[i]>=0) {txt_clr='deeppink1';j<-i}
    else {txt_clr='steelblue4';j<- max(j-1,0)}
    best_p <- best_p+annotate("text", x = xy_max/2, y = xy_max-i*nrow(local_df), color=txt_clr,size=15-j,label = local_df[attr][i,1])
  }
  return(best_p) 
}



#Time
weekday_score_df <- data.frame(aggregate(Z_Q1 ~ code*week_day,df,mean))
period_score_df <- data.frame(aggregate(Z_Q1 ~ code*period,df,mean))
weekday_score_all_df <- data.frame(aggregate(Z_Q1 ~ week_day,df,mean))


########mean  for perference 
mean_df <-data.frame(aggregate(Z_Q1 ~ perfer_not, df_nok, mean))
x1 <-  data.frame(aggregate(Z_Q1 ~ perfer_not, df_nok, mean))[data.frame(aggregate(Z_Q1 ~ perfer_not, df_nok, mean))$perfer_not=="No",]$Z_Q1
x2 <- data.frame(aggregate(Z_Q1 ~ perfer_not, df_nok, mean))[data.frame(aggregate(Z_Q1 ~ perfer_not, df_nok, mean))$perfer_not=="Yes",]$Z_Q1
x3 <- data.frame(aggregate(Z_Q1 ~ perfer_not, df_nok, mean))[data.frame(aggregate(Z_Q1 ~ perfer_not, df_nok, mean))$perfer_not=="Not Sure",]$Z_Q1
preference_p <- ggplot(df_nok, aes(x=Z_Q1, fill=perfer_not)) + geom_histogram(binwidth=.3, alpha=.5, position="identity")+
    scale_fill_discrete(name="Prefer to do something else?")+
    geom_segment(aes(x =0.3454582  , y =60, xend =0.3454582 , yend = 0),linetype="dashed",size=1,color='pink',alpha=.7)+    
    geom_segment(aes(x = -0.381628 , y =60, xend =-0.381628, yend = 0),linetype="dashed",size=1,color='lightblue',alpha=.7)+
    geom_segment(aes(x = -0.1556725, y =60, xend = -0.1556725, yend = 0),linetype="dashed",size=1,color='forestgreen',alpha=.7)+
    xlab("Normalized Happiness ( 0 is the average)")

###################


shinyServer(function(input, output) {

	codename <- reactive({
    input$text1
  	})
  	
  #check codename
	output$code_error <- renderText({
	  if (input$Submit == 0) msg<- "" else if ((input$Submit > 0)& !codename() %in% code_list) msg <- "The code you input is not found, please try again" else msg<- ""
    msg
	})
  
  
  
	#Q1 score 
	Q1_Plot <- reactive({
   #one user 
    Q1_p <- subset(df, code==codename(), select=c(Q1,code))
	 Q1_p$code<- factor(Q1_p$code)
	 Q1_personal <- rbind(Q1_p, Q1_dist)
   
  	})
	
	#Q1 variance
   var_plot <- reactive({
	   	variance_df$to_clr<- variance_df$code==codename()
    	variance_df})
	
	#Q1 score*week_day plot
   week_day_plot <- reactive({
	   weekday_score_df_sub<- subset(weekday_score_df, weekday_score_df$code==codename())
	   weekday_score_df_sub
	   })
   
   #Q1 score*period plot
   period_plot <- reactive({
   	   period_score_df_sub<- subset(period_score_df, period_score_df$code==codename())
   	   period_score_df_sub
   	   })
	   
   week_day_all_plot <- reactive({
	   weekday_score_all_df
   })

  


  output$Q1_Dist <- renderPlot({
  	
    
    p1<-ggplot(Q1_Plot() , aes(Q1, fill = code)) + geom_density(color="grey" ,alpha = 0.6)+
        xlab("Happiness Score 1~100") + ylab("Density")

    print(p1)
	
  })

  output$Var_Dist <- renderPlot({
    
    
    p2<- ggplot(na.omit(var_plot()), aes(x=reorder(code,-Q1), y=Q1, fill=to_clr)) + geom_bar(stat="identity")
    out_p2<- p2+scale_fill_manual(values=c("#999999", "#E69F00"), 
                       name="",
                       breaks=c("FALSE","TRUE"),labels=c("Other Users", "Your Variance"))+
                      theme(axis.text.x = element_blank())+xlab("Users")+ylab("Happinese Score Variance")+
                        annotate("text", x = 4.5, y = 31, label = "High Variance",color="#000099",size=6)+ annotate("text", x = 21.7, y = 31, label = "Low Variance", color="brown",size=6)+
                         geom_segment(aes(x = 18.5, y = 30.8, xend = 8, yend = 30.8), arrow = arrow(length = unit(0.3, "cm")),size=1.3)+
                         geom_segment(aes(x = 8, y = 30.8, xend = 18.5, yend = 30.8), arrow = arrow(length = unit(0.3, "cm")),size=1.3 )

    
    print(out_p2)
  })
  
  output$Var_Time_Dist <- renderPlot({
	  
	  if (codename()>1) {
			p2<- ggplot(na.omit(week_day_plot()), aes(x=reorder(week_day,-Z_Q1), y=Z_Q1, fill=week_day)) + 
					geom_bar(stat="identity") +
					labs(x = "Weekday",y = "Happiness Score Normalized",title="Your Happiest Day")
			p3<- ggplot(na.omit(period_plot()), aes(x=reorder(period,-Z_Q1), y=Z_Q1, fill=period)) + 
					geom_bar(stat="identity") +
					labs(x = "Period",y = "Happiness Score Normalized",title="Your Happiest Time of Day")
			print(grid.arrange(p2,p3,nrow=1))
	  } else {
			p2<- ggplot(na.omit(week_day_all_plot()), aes(x=reorder(week_day,-Z_Q1), y=Z_Q1, fill=week_day)) + 
					geom_bar(stat="identity") +
					labs(x = "Weekday",y = "Happiness Score Normalized",title="People's Happiest Day") +
					scale_fill_discrete("Week Day")
			print(p2)	
	  }
	  
  
  })
  #output$text2<-renderText(names(mean_df))
  #output$text2 <- renderText({names(mean_df)})
  output$preference_hist <- renderPlot(print(preference_p))
	
  output$loc_act_text <- renderPlot({
    p_act <- best_plot('act')
    p_loc <- best_plot('loc')
    print(grid.arrange(p_act,p_loc,nrow=1))
    })
  output$loc_act_p <- renderPlot(print(loc_act))
  

}) 
