rm(list=ls())
library(ggplot2)
library(GGally)
#library(patchwork)
library(readstata13)

dat<- read.dta13("D:/F/job/nafi/2021/icddrb/amev/data/father_mother1.dta")

dat$ad_diff8<- factor(dat$ad_diff8)

ad_recall<- ggplot(dat, aes(x=ad_dss, y= ad_sur,color=ad_diff8) ) +
  geom_point()+
  xlim(c(20,110))+
  ylim(c(20,110))+
  scale_color_manual(name="Difference in age at death (DSS-Survey)",values=c("red","azure3","azure3", "darkblue","darkblue","cyan","cyan","chartreuse","chartreuse"))+
  facet_grid(d_dur_dss5~parent)+
  theme_test()+
  labs(x="Age at death (DSS)", y="Age at death (Survey)")+
  theme(legend.position = "bottom")+

ad_recall

ggsave("D:/F/job/nafi/2021/icddrb/amev/data/ad_recall.png", units="in", width=10, height=10, dpi=1000)


ad_sex<- ggplot(dat, aes(x=ad_dss, y= ad_sur,color=ad_diff8) ) +
  geom_point()+
  xlim(c(20,110))+
  ylim(c(20,110))+
  scale_color_manual(name="Difference in age at death (DSS-Survey)",values=c("red","azure3","azure3", "darkblue","darkblue","cyan","cyan","chartreuse","chartreuse"))+
  facet_grid(sex~parent)+
  theme_test()+
  labs(x="Age at death (DSS)", y="Age at death (Survey)")+
  theme(legend.position = "bottom")
ad_sex

ggsave("D:/F/job/nafi/2021/icddrb/amev/data/ad_sex.png", units="in", width=10, height=10, dpi=500)




ad_age<- ggplot(dat, aes(x=ad_dss, y= ad_sur,color=ad_diff8) ) +
  geom_point()+
  xlim(c(20,110))+
  ylim(c(20,110))+
  scale_color_manual(name="Difference in age at death (DSS-Survey)",values=c("red","azure3","azure3", "darkblue","darkblue","cyan","cyan","chartreuse","chartreuse"))+
  facet_grid(age~parent)+
  theme_test()+
  labs(x="Age at death (DSS)", y="Age at death (Survey)")+
  theme(legend.position = "bottom")
ad_age
ggsave("D:/F/job/nafi/2021/icddrb/amev/data/ad_age.png", units="in", width=10, height=10, dpi=500)


ad_edu<- ggplot(dat, aes(x=ad_dss, y= ad_sur,color=ad_diff8) ) +
  geom_point()+
  xlim(c(20,110))+
  ylim(c(20,110))+
  scale_color_manual(name="Difference in age at death (DSS-Survey)",values=c("red","azure3","azure3", "darkblue","darkblue","cyan","cyan","chartreuse","chartreuse"))+
  facet_grid(edu~parent)+
  theme_test()+
  labs(x="Age at death (DSS)", y="Age at death (Survey)")+
  theme(legend.position = "bottom")
ad_edu
ggsave("D:/F/job/nafi/2021/icddrb/amev/data/ad_edu.png", units="in", width=10, height=10, dpi=500)



