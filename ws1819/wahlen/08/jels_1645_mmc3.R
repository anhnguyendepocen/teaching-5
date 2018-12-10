###
###Electoral Studies article on electoral manipulation patterns in Russia 2011
###Code for main text
###Cole J. Harvey
###2015
rm(list=ls())  #Clear environment''

###Load packages###
library(lme4)
library(arm)
library(gplots)
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


########Main paper models########
#### Extra-legal mobilization models (absentee voting)####
##Model 1 (controls only)
model.1a<-lmer(urpercent.abs ~ percent.absentee + agemploy2010 +
    logpop + logincome + POVERTY2010 + GOVEMPLOY2010 + PENSION2010 +
    CONCENTRATION2010 + INTERNET2010 + HIGHERED2010 + NEWSPAPER2010 +
    percent.absentee : logpop + percent.absentee : logincome +
    percent.absentee : POVERTY2010 + percent.absentee : GOVEMPLOY2010 +
    percent.absentee : PENSION2010 +
    percent.absentee : CONCENTRATION2010 +
    percent.absentee : INTERNET2010 + percent.absentee : HIGHERED2010 +
    percent.absentee : NEWSPAPER2010 + percent.absentee : agemploy2010 +
    (1 + percent.absentee | ID),
    data=newdata,
    REML=FALSE
)
summary(model.1a)

##Model 2 (Percent margin)
model.2a<-lmer(urpercent.abs~percent.absentee+percentmargin+agemploy2010+logpop+logincome+
                 POVERTY2010+GOVEMPLOY2010+PENSION2010+CONCENTRATION2010+INTERNET2010+
                 HIGHERED2010+NEWSPAPER2010+percent.absentee:percentmargin+
                 percent.absentee:logpop+percent.absentee:logincome+
                 percent.absentee:POVERTY2010+
                 percent.absentee:GOVEMPLOY2010+percent.absentee:PENSION2010+
                 percent.absentee:CONCENTRATION2010+
                 percent.absentee:INTERNET2010+percent.absentee:HIGHERED2010+
                 percent.absentee:NEWSPAPER2010+percent.absentee:agemploy2010+(1+percent.absentee|ID), data=newdata, REML=FALSE)
summary(model.2a)

##Model 3 (Russian ethnicity)
model.3a<-lmer(urpercent.abs~percent.absentee+RUSSIAN+agemploy2010+logpop+logincome+
                 POVERTY2010+GOVEMPLOY2010+PENSION2010+CONCENTRATION2010+INTERNET2010+
                 HIGHERED2010+NEWSPAPER2010+percent.absentee:RUSSIAN+
                 percent.absentee:logpop+percent.absentee:logincome+
                 percent.absentee:POVERTY2010+
                 percent.absentee:GOVEMPLOY2010+percent.absentee:PENSION2010+
                 percent.absentee:CONCENTRATION2010+
                 percent.absentee:INTERNET2010+percent.absentee:HIGHERED2010+
                 percent.absentee:NEWSPAPER2010+percent.absentee:agemploy2010+(1+percent.absentee|ID), data=newdata, REML=FALSE)
summary(model.3a)

##Model 4 (Local comeptitiveness)
model.4a<-lmer(urpercent.abs~percent.absentee+competitive+agemploy2010+logpop+logincome+
                 POVERTY2010+GOVEMPLOY2010+PENSION2010+CONCENTRATION2010+INTERNET2010+
                 HIGHERED2010+NEWSPAPER2010+percent.absentee:competitive+
                 percent.absentee:logpop+percent.absentee:logincome+
                 percent.absentee:POVERTY2010+
                 percent.absentee:GOVEMPLOY2010+percent.absentee:PENSION2010+
                 percent.absentee:CONCENTRATION2010+
                 percent.absentee:INTERNET2010+percent.absentee:HIGHERED2010+
                 percent.absentee:NEWSPAPER2010+percent.absentee:agemploy2010+(1+percent.absentee|ID), data=newdata, REML=FALSE)
summary(model.4a)

##Model 5 (Fraud score)
model.5a<-lmer(urpercent.abs~percent.absentee+fullfraudscore+agemploy2010+logpop+logincome+
                 POVERTY2010+GOVEMPLOY2010+PENSION2010+CONCENTRATION2010+INTERNET2010+
                 HIGHERED2010+NEWSPAPER2010+percent.absentee:fullfraudscore+
                 percent.absentee:logpop+percent.absentee:logincome+
                 percent.absentee:POVERTY2010+
                 percent.absentee:GOVEMPLOY2010+percent.absentee:PENSION2010+
                 percent.absentee:CONCENTRATION2010+
                 percent.absentee:INTERNET2010+percent.absentee:HIGHERED2010+
                 percent.absentee:NEWSPAPER2010+percent.absentee:agemploy2010+(1+percent.absentee|ID), data=newdata, REML=FALSE)
summary(model.5a)


####Ballot-stuffin models (mobile voting)####
##Model 6 (Controls)
model.6<-lmer(urpercent.abs~pct.mobile+agemploy2010+logpop+logincome+
                 POVERTY2010+GOVEMPLOY2010+PENSION2010+CONCENTRATION2010+INTERNET2010+
                 HIGHERED2010+NEWSPAPER2010+
                 pct.mobile:logpop+pct.mobile:logincome+
                 pct.mobile:POVERTY2010+
                 pct.mobile:GOVEMPLOY2010+pct.mobile:PENSION2010+
                 pct.mobile:CONCENTRATION2010+
                 pct.mobile:INTERNET2010+pct.mobile:HIGHERED2010+
                 pct.mobile:NEWSPAPER2010+pct.mobile:agemploy2010+
                 pct.mobile:agemploy2010+(1+pct.mobile|ID), data=newdata, REML=FALSE)
summary(model.6)

##Model 7 (Margin squared)

model.7ms<-lmer(urpercent.abs~pct.mobile+percentmargin+I(percentmargin^2)+agemploy2010+logpop+logincome+
                  POVERTY2010+GOVEMPLOY2010+PENSION2010+CONCENTRATION2010+INTERNET2010+
                  HIGHERED2010+NEWSPAPER2010+
                  pct.mobile:logpop+pct.mobile:logincome+
                  pct.mobile:POVERTY2010+
                  pct.mobile:GOVEMPLOY2010+pct.mobile:PENSION2010+
                  pct.mobile:CONCENTRATION2010+
                  pct.mobile:INTERNET2010+pct.mobile:HIGHERED2010+
                  pct.mobile:NEWSPAPER2010+pct.mobile:agemploy2010+
                  pct.mobile:agemploy2010++pct.mobile:percentmargin+
                  pct.mobile:I(percentmargin^2)+(1+pct.mobile|ID), data=newdata, REML=FALSE)
summary(model.7ms)

##Model 8 (Russian ethnicity)

model.8ms<-lmer(urpercent.abs~pct.mobile+RUSSIAN+I(RUSSIAN^2)+agemploy2010+logpop+logincome+
                  POVERTY2010+GOVEMPLOY2010+PENSION2010+CONCENTRATION2010+INTERNET2010+
                  HIGHERED2010+NEWSPAPER2010+
                  pct.mobile:logpop+pct.mobile:logincome+
                  pct.mobile:POVERTY2010+
                  pct.mobile:GOVEMPLOY2010+pct.mobile:PENSION2010+
                  pct.mobile:CONCENTRATION2010+
                  pct.mobile:INTERNET2010+pct.mobile:HIGHERED2010+
                  pct.mobile:NEWSPAPER2010+pct.mobile:agemploy2010+
                  pct.mobile:agemploy2010+pct.mobile:RUSSIAN+
                  pct.mobile:I(RUSSIAN^2)+(1+pct.mobile|ID), data=newdata, REML=FALSE)
summary(model.8ms)

##Model 9 (Local competitiveness)

model.9ms<-lmer(urpercent.abs~pct.mobile+competitive+I(competitive^2)+agemploy2010+logpop+logincome+
                  POVERTY2010+GOVEMPLOY2010+PENSION2010+CONCENTRATION2010+INTERNET2010+
                  HIGHERED2010+NEWSPAPER2010+
                  pct.mobile:logpop+pct.mobile:logincome+
                  pct.mobile:POVERTY2010+
                  pct.mobile:GOVEMPLOY2010+pct.mobile:PENSION2010+
                  pct.mobile:CONCENTRATION2010+
                  pct.mobile:INTERNET2010+pct.mobile:HIGHERED2010+
                  pct.mobile:NEWSPAPER2010+pct.mobile:agemploy2010+
                  pct.mobile:agemploy2010+pct.mobile:competitive+
                  pct.mobile:I(competitive^2)+(1+pct.mobile|ID), data=newdata, REML=FALSE)
summary(model.9ms)

##Model 10 (Fraud score)

model.10<-lmer(urpercent.abs~pct.mobile+fullfraudscore+agemploy2010+logpop+logincome+
                  POVERTY2010+GOVEMPLOY2010+PENSION2010+CONCENTRATION2010+INTERNET2010+
                  HIGHERED2010+NEWSPAPER2010+
                  pct.mobile:logpop+pct.mobile:logincome+
                  pct.mobile:POVERTY2010+
                  pct.mobile:GOVEMPLOY2010+pct.mobile:PENSION2010+
                  pct.mobile:CONCENTRATION2010+
                  pct.mobile:INTERNET2010+pct.mobile:HIGHERED2010+
                  pct.mobile:NEWSPAPER2010+pct.mobile:agemploy2010+
                  pct.mobile:agemploy2010+pct.mobile:fullfraudscore+
                 (1+pct.mobile|ID), data=newdata, REML=FALSE)
summary(model.10)

######Plots from main paper#####
####Extra-legal mobilization plots (absentee ballots)###

##Model 2 plot (Margins)##
margin<-russiasmall$percentmargin
b.hat.margin<-coef(model.2a)$ID[,2]+coef(model.2a)$ID[,14]*margin
se4<-se.ranef(model.2a)$ID[,2]
upper<-b.hat.margin+1.96*(se4)
lower<-b.hat.margin-1.96*(se4)

p<-ggplot()+
  geom_point(aes(x=margin, y=b.hat.margin))+
  geom_errorbar(aes(x=margin, ymin=lower, ymax=upper))+
  labs(x="UR margin of victory", y="Extra-legal mobilization coefficient")+
  geom_abline(intercept = 3.16, slope = -.98)

p+theme_bw()
p<-p+theme_bw()
p <- p + theme(text = element_text(size = 15))

##Model 3 plot (Russian)##
rus<-russiasmall$RUSSIAN
b.hat.rus<-as.vector(coef(model.3a)$ID[,2]+coef(model.3a)$ID[,14]*rus)
se4<-se.ranef(model.3a)$ID[,2]
upper<-b.hat.rus+1.96*(se4)
lower<-b.hat.rus-1.96*(se4)

p<-ggplot()+
  geom_point(aes(x=rus, y=b.hat.rus))+
  geom_errorbar(aes(x=rus, ymin=lower, ymax=upper))+
  labs(x="Russian ethnicity", y="Extra-legal mobilization coefficient")+
  geom_abline(intercept = 1.16, slope = .7)

p+theme_bw()
p<-p+theme_bw()
p <- p + theme(text = element_text(size = 15))
p


##Model 4 plot (Competitiveness)##
compscores<-russiasmall$competitive
b.hat.test4<-as.vector(coef(model.4a)$ID[,2]+coef(model.4a)$ID[,14]*compscores)
se<-se.ranef(model.4a)$ID[,2]
upper<-b.hat.test4+1.96*(se)
lower<-b.hat.test4-1.96*(se)
p<-ggplot()+
  geom_point(aes(x=compscores, y=b.hat.test4))+
  geom_errorbar(aes(x=compscores, ymin=lower, ymax=upper))+
  labs(x="Local competitiveness", y="Extra-legal mobilization coefficient")+
  geom_abline(intercept = .34, slope = .73)+
  geom_hline(yintercept=0, linetype=2)

p+theme_bw()
p<-p+theme_bw()
p <- p + theme(text = element_text(size = 15))
p

##Model 5 plot (fraud score)##
fraud<-russiasmall$fullfraudscore
jitterfraud<-jitter(fraud, factor=1.1)
b.hat.fraud<-coef(model.5a)$ID[,2]+coef(model.5a)$ID[,14]*fraud
se4<-se.ranef(model.5a)$ID[,2]
upper<-b.hat.fraud+1.96*(se4)
lower<-b.hat.fraud-1.96*(se4)

p<-ggplot()+
  geom_point(aes(x=jitterfraud, y=b.hat.fraud))+
  geom_errorbar(aes(x=jitterfraud, ymin=lower, ymax=upper))+
  labs(x="Fraud score (jittered)", y="Extra-legal mobilization coefficient")+
  geom_abline(intercept = .79, slope = -.18)+
  geom_hline(yintercept=0, linetype=2)

p+theme_bw()
p<-p+theme_bw()
p <- p + theme(text = element_text(size = 15))
p


####Ballot stuffin plots (mobile ballots)####
##Model 7 plot (Margins)##
margins<-russiasmall$percentmargin
b.hat.rus<-as.vector(coef(model.7ms)$ID[,2]+coef(model.7ms)$ID[,25]*margins+coef(model.7ms)$ID[,26]*margins*margins)
se4<-se.ranef(model.7ms)$ID[,2]
upper<-b.hat.rus+1.96*(se4)
lower<-b.hat.rus-1.96*(se4)
margins.out<-seq((min(russiasmall$percentmargin)), (max(russiasmall$percentmargin)), length.out=1000)
yhat<-3.7+.76*margins.out-1.59*margins.out*margins.out  #Pct. mobile  + pct.mobile:russian * rus.out + pct.mobile:russiansq *rus.out*rus.out

p<-ggplot()+
  geom_point(aes(x=margins, y=b.hat.rus))+
  geom_errorbar(aes(x=margins, ymin=lower, ymax=upper))+
  labs(x="UR margin of victory", y="Ballot-stuffing coefficient")+
  geom_line(aes(x=margins.out, y=yhat))

p+theme_bw()
p<-p+theme_bw()
p <- p + theme(text = element_text(size = 15))
p

##Model 8 plot (Russian)##
russian<-russiasmall$RUSSIAN
b.hat.rus<-as.vector(coef(model.8ms)$ID[,2]+coef(model.8ms)$ID[,25]*russian+coef(model.8ms)$ID[,26]*russian*russian)
se4<-se.ranef(model.8ms)$ID[,2]
upper<-b.hat.rus+1.96*(se4)
lower<-b.hat.rus-1.96*(se4)
russian.out<-seq((min(russiasmall$RUSSIAN)), (max(russiasmall$RUSSIAN)), length.out=1000)
yhat<-2.41+1.82*russian.out-1.27*russian.out*russian.out  #Pct. mobile  + pct.mobile:russian * rus.out + pct.mobile:russiansq *rus.out*rus.out

p<-ggplot()+
  geom_point(aes(x=russian, y=b.hat.rus))+
  geom_errorbar(aes(x=russian, ymin=lower, ymax=upper))+
  labs(x="Russian ethnicity", y="Ballot-stuffing coefficient")+
  geom_line(aes(x=russian.out, y=yhat))

p+theme_bw()
p<-p+theme_bw()
p <- p + theme(text = element_text(size = 15))
p


##Model 9 plot (Competitiveness)##
compscores<-russiasmall$competitive
b.hat.rus<-as.vector(coef(model.9ms)$ID[,2]+coef(model.9ms)$ID[,25]*compscores+coef(model.9ms)$ID[,26]*compscores*compscores)
se4<-se.ranef(model.9ms)$ID[,2]
upper<-b.hat.rus+1.96*(se4)
lower<-b.hat.rus-1.96*(se4)
comp.out<-seq((min(russiasmall$competitive)), (max(russiasmall$competitive)), length.out=1000)
yhat<-1.61+2.68*comp.out-2.05*comp.out*comp.out  #Pct. mobile  + pct.mobile:russian * rus.out + pct.mobile:russiansq *rus.out*rus.out

p<-ggplot()+
  geom_point(aes(x=compscores, y=b.hat.rus))+
  geom_errorbar(aes(x=compscores, ymin=lower, ymax=upper))+
  labs(x="Local competitiveness", y="Ballot-stuffing coefficient")+
  geom_line(aes(x=comp.out, y=yhat))

p+theme_bw()
p<-p+theme_bw()
p <- p + theme(text = element_text(size = 15))
p

##Model 10 plot (fraud score)##
fraud<-russiasmall$fullfraudscore
jitterfraud<-jitter(fraud, factor=1.25)
b.hat.rus<-as.vector(coef(model.10)$ID[,2]+coef(model.10)$ID[,24]*fraud)
se4<-se.ranef(model.10)$ID[,2]
upper<-b.hat.rus+1.96*(se4)
lower<-b.hat.rus-1.96*(se4)

p<-ggplot()+
  geom_point(aes(x=jitterfraud, y=b.hat.rus))+
  geom_errorbar(aes(x=jitterfraud, ymin=lower, ymax=upper))+
  labs(x="Fraud score (jittered)", y="Ballot-stuffing coefficient")

p<-p + geom_abline(intercept = 2.23, slope = -.13)

p+theme_bw()
p<-p+theme_bw()
p <- p + theme(text = element_text(size = 15))
p
