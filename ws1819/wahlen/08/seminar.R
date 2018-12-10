###
###Electoral Studies article on electoral manipulation patterns in Russia 2011
###Code for main text
###Cole J. Harvey
###2015
rm(list=ls())  #Clear environment''

###Load packages###
library(ggplot2)

#####Loading data####
bigdata <- read.csv("./1-s2.0-S0261379415002073-mmc4.csv")  # precint
russiasmall <- read.csv("1-s2.0-S0261379415002073-mmc5.csv")  # region

compsquare <- russiasmall$competitive ^ 2  # create square & log
russiasmall <- cbind(russiasmall, compsquare)
log.income <- log(russiasmall$INCOME2010)
income.scale <- scale(russiasmall$INCOME2010)
logpop <- log(russiasmall$POPULATION2010)
log.income <- log(russiasmall$INCOME2010)
russiasmall <- cbind(  # Gather in small dataset
    russiasmall, log.income, income.scale, logpop, log.income
)


newdata <- merge(bigdata, russiasmall, by="ID")  # Merge data

percent.absentee <- newdata$number.of.voters.by.absentee / (newdata$valid + newdata$invalid)
pct.mobile <- newdata$mobile / (newdata$valid + newdata$invalid)
newdata <- cbind(newdata, percent.absentee, pct.mobile)     #Creates percent.absentee and pct.mobile DVs

ggplot(
    data = newdata,
    aes(x = reorder(ID, urpercent.abs, FUN = mean, na.rm = TRUE), y = urpercent.abs)
) +
    stat_summary(fun.data = "mean_cl_normal")

ggplot(
    data = newdata,
    aes(x = percent.absentee, y = urpercent.abs)
) +
    geom_point(alpha = .4)

ggplot(  # completely pooled
    data = newdata,
    aes(x = percent.absentee, y = urpercent.abs)
) +
    geom_point(alpha = .4) +
    geom_smooth(method='lm', se=FALSE)

ggplot(  # completely separated
    data=newdata,
    aes(x=percent.absentee, y=urpercent.abs)
) +
    geom_point(alpha = .4) +
    geom_smooth(aes(group=factor(ID)), method='lm', se=FALSE)
