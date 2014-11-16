#############################################################
##### Code for RepData_PeerAssessment1                  #####
#####                                                   #####
## setwd("./RepData_PeerAssessment1")                   #####
## library(ggplot2)                                     #####
#############################################################

#############################################################
#####                    begine read_data               #####
#####                                                   #####
activity = read.csv("activity.csv")
daily = aggregate(activity$steps, by=list(activity$date), FUN=sum)
#####                                                   #####
#####                    end read_data                  #####
#############################################################

#############################################################
#####           begin total_daily_steps                 #####
#####                                                   #####
# calculate mean and median
meansteps = mean(daily$x, na.rm=T)
medsteps = median(daily$x, na.rm=T)
# plot data
hist(daily$x, breaks = 25,
     col = "lightblue", border = "black",
     main = "Total number of steps taken each day",
     xlab = "# Steps taken in a day", ylab = "Frequency")
abline(v = meansteps, col = "blue", lwd = 2, lty = 2)
#####                                                   #####
#####                   end total_daily_steps           #####
#############################################################

#############################################################
#####                   begin daily_act                 #####
#####                                                   #####
interval_means <- aggregate(activity$steps, by=list(activity$interval),
                          FUN=mean, na.rm=T)
names(interval_means) <- c("Interval", "Avg.Steps")
with(interval_means, plot(Interval, Avg.Steps, type="l"))

# find interval with largest Avg.Steps
top <- with(interval_means, interval_means[Avg.Steps==max(Avg.Steps),])
#####                                                   #####
#####                   end daily_act                   #####
#############################################################

#############################################################
#####           begin impute_missing_values             #####
#####                                                   #####
# which rows have missing steps values
index <- which(is.na(activity$steps))
# create a new dataset and replace the NAs with mean
# from the interval_means table, matching on the intervall
act2=activity
act2$steps[index] <- interval_means[match(act2[index,"interval"], interval_means$Interval), "Avg.Steps"]
#####                                                   #####
#####           end impute_missing_values               #####
#############################################################



#############################################################
#####             begin impute_histogram                #####
#####                                                   #####
# create and plot data of steps taken each day
daily2 = aggregate(act2$steps, by=list(act2$date), FUN=sum)
meansteps2 = mean(daily2$x, na.rm=T)
medsteps2 = median(daily2$x, na.rm=T)
# plot data
hist(daily$x, breaks = 25,
     col = "lightgreen", border = "black",
     main = "Total number of steps taken each day",
     sub = "with imputed data",
     xlab = "# Steps taken in a day", ylab = "Frequency")
abline(v = meansteps, col = "darkgreen", lwd = 2, lty = 2)
#####                                                   #####
#####              end impute_histogram                 #####
#############################################################


#############################################################
#####           begin weekdays_vs_weekends              #####
#####                                                   #####
# add a column to the imputed data set to indicate
# weekday or weekend, then use it to aggregate the data
wend <- c("Saturday", "Sunday")
act2$when <- ifelse(weekdays(as.Date(act2$date)) %in% wend, "Weekend", "Weekday")

#
# Calculate the average number of steps teken in each
# interval for weekdays and weekends
interval_avg_when <- aggregate(act2$steps,
                            by=list(Interval = act2$interval,
                                    When = act2$when),
                            FUN=mean)
interval_avg_when$When <- as.factor(interval_avg_when$When)
names(interval_avg_when)[3] <- "Avg.Steps"
#####                                                   #####
#####           end weekdays_vs_weekends                #####
#############################################################

#############################################################
#####         begin weekdays_vs_weekends_graph          #####
#####                                                   #####
avgsteps = aggregate(Avg.Steps ~ When, interval_avg_when, mean)
wday_steps <- avgsteps[avgsteps$When == "Weekday", "Avg.Steps"]
wend_steps <- avgsteps[avgsteps$When == "Weekend", "Avg.Steps"]

library(ggplot2)
qplot(data=interval_avg_when, x=Interval, y=Avg.Steps, geom="line", facets=When ~ .)

#####                                                   #####
#####         end weekdays_vs_weekends_graph            #####
#############################################################


