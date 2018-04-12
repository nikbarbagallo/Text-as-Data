
options(max.print = 100000000)

library("car")
library(readr)
library(MASS)
library(nnet)
library(ggplot2)

setwd("~/Desktop/Text as data/Report assessment/sermon_central_data")
gay_CSV <- read_csv("gay_CSV.csv", 
                    col_types = cols(`18` = col_number(), 
                                     `19` = col_number(), `20` = col_number(), 
                                     `21` = col_number(),
                                     `9` = col_date(format = "%m/%d/%Y")))
##sum(gay_CSV$`21`)
colnames(gay_CSV) <- c("X1",
                       "id",
                       "URL",
                       "Church_type",
                       "Pastor",
                       "Church_name",
                       "Church_AD",
                       "Age_church",
                       "Congregation",
                       "Size_congregation",
                       "Sermon_posting_date",
                       "Title_sermon",
                       "biblical_versus",
                       "Tags_sermon_comunity",
                       "13",
                       "Community_ranking 1-5",
                       "Keyword",
                       "Extracted_sentences",
                       "Negative", 
                       "Neutral",
                       "Positive",
                       "Compound")
##Recode comunity rankings to numeric
gay_CSV$`Community_ranking 1-5`=car::recode(gay_CSV$`Community_ranking 1-5`,
"'twostar'=2; 
'twohalfstar'=2.5; 
'threestar'=3; 
'threehalfstar'=3.5; 
'onestar'=1; 
'onehalfstar'=1.5; 
'fourstar'=4; 
'fourhalfstar'=4.5; 
'fivestar'=5")

whole_CSV$`14`=car::recode(whole_CSV$`14`,
                                            "'twostar'=2; 
'twohalfstar'=2.5; 
'threestar'=3; 
'threehalfstar'=3.5; 
'onestar'=1; 
'onehalfstar'=1.5; 
'fourstar'=4; 
'fourhalfstar'=4.5; 
'fivestar'=5")

##Binomial <- glm(gay_CSV$`Community_ranking 1-5` ~ gay_CSV$Compound, data = gay_CSV, family = "binomial")
fit1 <- lm(gay_CSV$`Community_ranking 1-5` ~ gay_CSV$Compound)
Binomial <- glm.nb(gay_CSV$`Community_ranking 1-5` ~ gay_CSV$Compound, data = gay_CSV)
Poisson <- glm(gay_CSV$`Community_ranking 1-5` ~ gay_CSV$Compound, data = gay_CSV, family = "poisson")
Multinomial <- multinom(gay_CSV$`Community_ranking 1-5` ~ gay_CSV$Compound, data = gay_CSV)
summary(Multinomial)
summary(fit1)
summary(Binomial)
m1.or=exp(coef(Founding_Fathers_OLS))
m1.or=exp(coef(Founding_Fathers_OLS))
m1.or=exp(coef(Founding_Fathers_OLS))
m1.or=exp(coef(Multinomial))
stargazer::stargazer(fit1, type="html",
                     out="trial.htm")

##stargazer::stargazer(Binomial, type="html",
##                     out="Binomial_trial.htm")
##stargazer::stargazer(Poisson, type="html",
##                     out="Poisson_trial.htm")
##stargazer::stargazer(Multinomial, type="html", apply.coef = exp, apply.se   = exp,
##                     out="Multinomial_trial.htm")

## The model summary does not include p-values this time.
## However, we could obtain confidence intervals relatively easy:


ggplot(gay_CSV, aes(y=gay_CSV$Compound, x=gay_CSV$`Community_ranking 1-5`)) + 
  geom_point(aes(colour = Compound)) +
  geom_smooth(method = lm, col="darkgrey", se=FALSE) +
  ggtitle("Effect of homosexuality and same-sex marriage sentiment on a sermon's ranking")+
  scale_y_continuous(name = "Compound sentiment", breaks = c(-1, -0.5, 0.1, 0.5, 1)) +
  scale_x_continuous(name = "1-5 ranking by SermonCentral community") +
  scale_colour_gradient2(low = "firebrick" , mid = "floralwhite",
                         high = "forestgreen", midpoint = 0.1, space = "Lab",
                         na.value = "white", guide = "colourbar") +
  theme(panel.grid.minor = element_blank(),
        panel.grid.major.x = element_blank(),
        panel.background = element_blank(),
        axis.line = element_line(colour = "grey"))
ggsave(file.path("~/Desktop/Text as data/Report assessment/sermon_central_data",
                 "Gay_LM.jpeg"), width = 8, height = 6)
               
X <- rep(1,2542)
XX <- rep("Negative",2542)
Y <- rep(0,2225)
YY <- rep("Positive",2225)
M <- c(X,Y)
MM <- c(XX,YY)
M <- as.data.frame(M)
MM <- as.data.frame(MM)
L <- cbind(M,MM)

ggplot(L, aes(M, fill=MM)) +
  guides(fill=guide_legend(title="VADER Sentiment")) +
  geom_bar(aes(y = (..count..)/tapply(..count..,..PANEL..,sum)[..PANEL..]))+
  scale_y_continuous(labels = scales::percent, name = "Proportion") +
  scale_x_continuous(labels = c("Positive","Negative"), breaks = c(0,1), name = NULL)+
  theme(axis.text.x = element_text(angle = 25, hjust = 1), 
        legend.position = "right", 
        legend.direction = "vertical")+
  ggtitle("Sermons sentiment towards homosexuality")+
  geom_text(aes(y = ((..count..)/tapply(..count..,..PANEL..,sum)[..PANEL..]), 
                label = scales::percent((..count..)/tapply(..count..,..PANEL..,sum)[..PANEL..])), 
            stat = "count", 
            vjust = -0.25)+
  theme(panel.grid.minor = element_blank(),
        panel.grid.major.x = element_blank(),
        panel.background = element_blank(),
        axis.line = element_line(colour = "darkgrey"))+
  theme(legend.position = "bottom", legend.direction = "horizontal")
ggsave(file.path("~/Desktop/Text as data/Report assessment/sermon_central_data",
                 "VADER_proportion.jpeg"), width = 8, height = 6)

ggplot(gay_CSV, aes(gay_CSV$`Community_ranking 1-5`, colour=`Community_ranking 1-5`))+
  geom_bar(aes(y = (..count..)/tapply(..count..,..PANEL..,sum)[..PANEL..]))+
  scale_y_continuous(labels = scales::percent, name = "Proportion") +
  scale_x_continuous(breaks = c(1,1.5,2,2.5,3,3.5,4,4.5,5), name = NULL)+
  theme(axis.text.x = element_text(angle = 25, hjust = 1), 
        legend.position = "right", 
        legend.direction = "vertical")+
  ggtitle("Sermon Central Community 1-5 ranking (4767 sermons' subset)")+
  geom_text(aes(y = ((..count..)/tapply(..count..,..PANEL..,sum)[..PANEL..]), 
                label = scales::percent((..count..)/tapply(..count..,..PANEL..,sum)[..PANEL..])), 
            stat = "count", 
            vjust = -0.25)+
  theme(panel.grid.minor = element_blank(),
        panel.grid.major.x = element_blank(),
        panel.background = element_blank(),
        axis.line = element_line(colour = "darkgrey"))+
  theme(legend.position = "bottom", legend.direction = "horizontal")
ggsave(file.path("~/Desktop/Text as data/Report assessment/sermon_central_data",
                 "ranking_proportion.jpeg"), width = 10, height = 8)

ggplot(whole_CSV, aes(`14`, colour=`14`))+
  geom_bar(aes(y = (..count..)/tapply(..count..,..PANEL..,sum)[..PANEL..]))+
  scale_y_continuous(labels = scales::percent, name = "Proportion") +
  scale_x_continuous(breaks = c(1,1.5,2,2.5,3,3.5,4,4.5,5), name = NULL)+
  theme(axis.text.x = element_text(angle = 25, hjust = 1), 
        legend.position = "right", 
        legend.direction = "vertical")+
  ggtitle("Sermon Central Community 1-5 ranking (all 134531 sermons)")+
  geom_text(aes(y = ((..count..)/tapply(..count..,..PANEL..,sum)[..PANEL..]), 
                label = scales::percent((..count..)/tapply(..count..,..PANEL..,sum)[..PANEL..])), 
            stat = "count", 
            vjust = -0.25)+
  theme(panel.grid.minor = element_blank(),
        panel.grid.major.x = element_blank(),
        panel.background = element_blank(),
        axis.line = element_line(colour = "darkgrey"))+
  theme(legend.position = "bottom", legend.direction = "horizontal")
ggsave(file.path("~/Desktop/Text as data/Report assessment/sermon_central_data",
                 "whole_ranking_proportion.jpeg"), width = 10, height = 8)

ggplot(gay_CSV, aes(gay_CSV$Church_type, fill=(gay_CSV$Church_type))) +
  guides(fill=guide_legend(title="Church type")) +
  geom_bar(aes(y = (..count..)/tapply(..count..,..PANEL..,sum)[..PANEL..]))+
  scale_y_continuous(labels = scales::percent, name = "Proportion")+
  xlab(NULL)+
  theme(axis.text.x = element_text(angle = 25, hjust = 1), 
        legend.position = "right", 
        legend.direction = "vertical")+
  ggtitle("Proportion of sermons on homosexuality published by each church (4767 sermons' subset)")+
  geom_text(aes(y = ((..count..)/tapply(..count..,..PANEL..,sum)[..PANEL..]), 
                label = scales::percent((..count..)/tapply(..count..,..PANEL..,sum)[..PANEL..])), 
            stat = "count", 
            vjust = -0.25)+
  theme(panel.grid.minor = element_blank(),
        panel.grid.major.x = element_blank(),
        panel.background = element_blank(),
        axis.line = element_line(colour = "darkgrey"))+
  theme(legend.position = "bottom", legend.direction = "horizontal")
ggsave(file.path("~/Desktop/Text as data/Report assessment/sermon_central_data",
                 "Church_proportion.jpeg"), width = 15, height = 10)

whole_CSV <- read_csv("whole_CSV.csv")

ggplot(whole_CSV, aes(whole_CSV$`2`, fill=(whole_CSV$`2`))) +
  guides(fill=guide_legend(title="Church type")) +
  geom_bar(aes(y = (..count..)/tapply(..count..,..PANEL..,sum)[..PANEL..]))+
  scale_y_continuous(labels = scales::percent, name = "Proportion")+
  xlab(NULL)+
  theme(axis.text.x = element_text(angle = 25, hjust = 1), 
        legend.position = "right", 
        legend.direction = "vertical")+
  ggtitle("Proportion of sermons on homosexuality published by each church (all 134531 sermons)")+
  geom_text(aes(y = ((..count..)/tapply(..count..,..PANEL..,sum)[..PANEL..]), 
                label = scales::percent((..count..)/tapply(..count..,..PANEL..,sum)[..PANEL..])), 
            stat = "count", 
            vjust = -0.25)+
  theme(panel.grid.minor = element_blank(),
        panel.grid.major.x = element_blank(),
        panel.background = element_blank(),
        axis.line = element_line(colour = "darkgrey"))+
  theme(legend.position = "bottom", legend.direction = "horizontal")
ggsave(file.path("~/Desktop/Text as data/Report assessment/sermon_central_data",
                 "Whole_Church_proportion.jpeg"), width = 15, height = 10)

CHURCHT <- lm(gay_CSV$Compound ~ gay_CSV$Church_type)
summary(CHURCHT)

stargazer::stargazer(CHURCHT, type="html", apply.coef = exp, apply.se = exp,
                     out="CHURCHT_trial.htm")
levels(gay_CSV$Church_type)
ggplot(gay_CSV, aes(y=gay_CSV$Compound, x=gay_CSV$Church_type)) + 
  geom_point(aes(colour = Compound)) +
  geom_smooth(method = lm, col="darkgrey", se=FALSE)+
  facet_wrap(~Church_type, scales = "fixed")+
  scale_colour_gradient2(low = "firebrick" , mid = "floralwhite",
                         high = "forestgreen", midpoint = 0.1, space = "Lab",
                         na.value = "white", guide = "colourbar") +
  theme(panel.grid.minor = element_blank(),
        panel.grid.major.x = element_blank(),
        panel.background = element_blank(),
        axis.line = element_line(colour = "grey"))
gay_CSV$Church_type
gay_CSV$Church_type = car::recode(gay_CSV$Church_type,
                                 "'Evangelical/Non-Denominational'='Evangelical';
                                 'Evangelical/Non-denominational'='Evangelical';
                                 'Evangelical Free'='Evangelical';
                                 'Independent/Bible'='Independent Bible';
                                 'Independent Bible'='Independent Bible'")
whole_CSV$`2` = car::recode(whole_CSV$`2`,
                                  "'Evangelical/Non-Denominational'='Evangelical';
                                  'Evangelical/Non-denominational'='Evangelical';
                                  'Evangelical Free'='Evangelical';
                                  'Independent/Bible'='Independent Bible';
                                  'Independent Bible'='Independent Bible'")


