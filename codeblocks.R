## Code for RepData_PeerAssessment1
##
## setwd("RepData_PeerAssessment1")
library(ggplot2)

activity = read.csv("activity.csv")
daily = aggregate(activity$steps, by=list(activity$date), FUN=sum)
meansteps = round(mean(daily$x, na.rm=T),1)
medsteps = median(daily$x, na.rm=T)

qplot(daily$x, main="Total number of steps taken each day",
      xlab="# Steps taken in a day", ylab="Frequency")

p <- ggplot(daily, aes(daily$x))
p + geom_histogram(mapping = aes(daily$x), binwidth = range(daily$x)/15)
p + geom_vline(xintercept = mean(daily$x, na.rm=T), colour="green", linetype = "longdash", show_guide = TRUE)


hist(daily$x, breaks = 15,
     col = "lightblue", border = "black",
     main = "Total number of steps taken each day",
     xlab = "# Steps taken in a day", ylab = "Frequency")
abline(v = meansteps, col = "red", lwd = 2, lty = 2)
abline(v = medsteps, col = "blue", lwd = 2, lty = 2)


format(2^31-1)
format(2^31-1, scientific = TRUE)
