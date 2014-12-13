library(shiny)
library(ggplot2) 
library(grid)
library(gridExtra) #needed for arrow head
#library(RODBC)
library(sqldf)
library(plyr)

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
    best_p <- best_p+annotate("text", x = xy_max/2, y = xy_max-i*nrow(local_df), color=txt_clr,size=12-j,label = local_df[attr][i,1])
  }
  return(best_p) 
}



#Time
day_labels <- c('Sunday','Monday','Tuesday','Wednesday','Thursday','Friday','Saturday')
day_labels_short <- c("Sun","Mon","Tue","Wed","Thu","Fri","Sat")
period_labels <- c('morning','afternoon','evening')

weekday_score_df <- sqldf("
		SELECT 
			code,
			week_day,
 		   	avg(Z_q1) Z_Q1,
			count(*) resp_count
		FROM 
			df 
		Group By code,week_day
		having resp_count>=5
 	    ")
period_score_df <- sqldf("
		SELECT 
			code,
			period,
 		   	avg(Z_q1) Z_Q1,
			count(*) resp_count
			
		FROM 
			df 
		Group By code,period  
		having resp_count >=5
 	    ")

weekday_score_all_df <- sqldf("
		SELECT 
			week_day,
 		   	avg(Z_q1) Z_Q1 
		FROM 
			df_nok 
		Group By week_day  
 	    ")

period_score_all_df <- sqldf("
		SELECT 
			period,
 		   	avg(Z_q1) Z_Q1 
		FROM 
			df_nok 
		Group By period  
 	    ")



################### preference 
preference_all_df <- sqldf("
		SELECT
			User,
			perfer_not,
			Z_Q1
		FROM
			(SELECT
				0 as User,
				perfer_not,
				avg(Z_Q1) Z_Q1,
				count(*) resp_count
			from
				df_nok		
			group by
				perfer_not
			Union
			SELECT
				code as User,
				perfer_not,
				avg(Z_Q1) Z_Q1,
				count(*) resp_count
			from
				df		
			group by
				code,perfer_not
			having 
				resp_count >= 5) S1")
preference_all_df$User <- factor(preference_all_df$User)

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
   
   period_all_plot <- reactive({
   	   period_score_all_df
   	   })
   
   #preference
   sub_preference_df <- reactive({
		 	  sub_preference_df <- subset(preference_all_df, User %in% c(0,codename()),select=c(User,perfer_not,Z_Q1))
			  
	  	   	  sub_preference_df$to_clr<- sub_preference_df$User==codename()
			  
			  sub_preference_df
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
	  
	  week_day_all_plot <- week_day_all_plot()
	  week_day_all_plot$week_day <- factor(week_day_all_plot$week_day,levels = day_labels)
	  week_day_all_p <- ggplot(na.omit(week_day_all_plot), aes(x=week_day,y=Z_Q1,fill=week_day)) + 
			scale_y_continuous(limits = c(-1, 1)) +
	 		theme(axis.text.x=element_text(color = "black", angle=0)) +
			geom_bar(stat="identity") +
			scale_fill_discrete("Week Day") +
			labs(x = "Week Day",y = "Happiness Score Normalized",title="People's Happiest Day of the Week") +
		    scale_x_discrete(labels=day_labels_short)
	
	  period_all_plot <- period_all_plot()
	  period_all_plot$period <- factor(period_all_plot$period,levels = period_labels) 
	  period_all_p<- ggplot(na.omit(period_all_plot), aes(x=period, y=Z_Q1, fill=period)) + 
			scale_y_continuous(limits = c(-1, 1)) +
	  		theme(axis.text.x=element_text(color = "black", angle=0)) +
			geom_bar(stat="identity") +
			labs(x = "Period",y = "Happiness Score Normalized",title="People's Happiest Day of Week") +
			scale_fill_discrete("Period") +
		    scale_x_discrete(labels=period_labels)
			
			
  	  if (codename()>1) {
		    week_day_plot <- week_day_plot()
			week_day_plot$week_day <- factor(week_day_plot$week_day,levels=day_labels)
  			week_day_user_p<- ggplot(na.omit(week_day_plot), aes(x=week_day, y=Z_Q1, fill=week_day)) + 
					scale_y_continuous(limits = c(-1.2, 1.2)) +
					theme(axis.text.x=element_blank())+ 
					geom_bar(stat="identity") +
  					labs(x = "Week Day",y = "Happiness Score Normalized",title="Your Happiest Day of the Week")+
					scale_fill_discrete("Week Day") 
					#+ scale_x_discrete(labels=day_labels_short)

    	  	
			period_plot <- period_plot()
			period_plot$period <- factor(period_plot$period,levels = period_labels) 	
  			period_user_p<- ggplot(na.omit(period_plot), aes(x=period, y=Z_Q1, fill=period)) + 
					scale_y_continuous(limits = c(-1, 1)) +
					theme(axis.text.x=element_blank())+ 
  					geom_bar(stat="identity") +
  					labs(x = "Period",y = "Happiness Score Normalized",title="Your Happiest Time of Day")+
					scale_fill_discrete("Period")  #+ scale_x_discrete(labels=period_labels)
					
  			print(grid.arrange(week_day_user_p,period_user_p,week_day_all_p,period_all_p,nrow=2,ncol=2))
  	  } else {
	  	  print(grid.arrange(week_day_all_p,period_all_p,nrow=1,ncol=2))
  	  }

  })

  output$preference_hist <- renderPlot({
	  preference_p <- ggplot(na.omit(sub_preference_df()), aes(x=perfer_not, y =Z_Q1,fill=to_clr)) + 
	  					scale_fill_manual(values=c("#999999", "#E69F00"), 
	                         name="",
	                         breaks=c("FALSE","TRUE"),
							 labels=c("Other Users", "Your Variance")) +
	  					geom_bar(stat="identity",position="dodge") +
	  					xlab("Would you rather be doing something other than what you're doing right now?") + 
						ylab("Happiness Score Normalized")
	  print(preference_p)
  })
	
  output$loc_act_text <- renderPlot({
    p_act <- best_plot('act')
    p_loc <- best_plot('loc')
    print(grid.arrange(p_act,p_loc,nrow=1))
    })
  output$loc_act_p <- renderPlot(print(loc_act))
  

}) 
