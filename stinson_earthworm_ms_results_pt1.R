#################################
#Name: Michelle R. Jackson
#Date: July 8, 2018
#R version: 3.5.0 "Joy in Playing"
#Purpose: GLMs (ANOVAs) investigating the effects of treatment and site on,
#soil pH, N concentrations, & moisture (Table 1)
#eradication treatment & site on earthworm biomass  (Table 2)
#mean earthworm biomass in experimental plots (Figure 1)
#################################
if (!require("ggplot2")) install.packages("ggplot2")
if (!require("car")) install.packages("car")
if (!require("effects")) install.packages("effects")
if (!require("agricolae")) install.packages("agricolae")
if (!require("multcomp")) install.packages("multcomp")
if (!require("visreg")) install.packages("visreg")
if (!require("margins")) install.packages("margins")
if (!require("emmeans")) install.packages("emmeans")
#read csv file
#NOTE: you have to set the working directory from within Rstudio
env<-read.csv('gm_ew_env_values.csv',header=TRUE)
#display the beginning of the .csv file
head(env)
#looking at earthworm biomass as a factor of treatment & site
ewmodel1<-aov(ew~site+Treatment, data=env)
#install 'car' package to perform type II ANOVAs https://cran.r-project.org/web/packages/car/index.html
library(car)
#run type II ANOVA -- treatment has a significant effect on earthworm biomass p=0.01532
Anova(ewmodel1, type="II")
#look at the variance inflation factors of the model 
vif(ewmodel1)
#Tukey test on Treatment - invaded is different than control/marginally significantly different than eradicated
TukeyHSD(ewmodel1)
#install 'effects' package to look at treatment effects https://cran.r-project.org/web/packages/effects/index.html
library(effects) 
#plot effects of the model - RESULTS CORRESPOND WITH TABLE 2
plot(allEffects(ewmodel1)) 
#run 'agricolae' package to get additional information for tukey tests https://cran.r-project.org/web/packages/agricolae/index.html
library(agricolae)
(HSD.test(ewmodel1, "Treatment"))
#run 'multcomp' package to get additional information for tukey tests https://cran.r-project.org/web/packages/multcomp/index.html
library(multcomp)
mc = glht(ewmodel1,
          mcp(Treatment = "Tukey"))
summary(mc)
#run 'visreg' package to visualize regression https://cran.r-project.org/web/packages/visreg/index.html
library(visreg)
visreg(ewmodel1)
summary(visreg(ewmodel1))
#run 'margins' package to calculate marginal or patial effects of the model https://cran.r-project.org/web/packages/margins/index.html
library(margins)
margins(ewmodel1)
plot(margins(ewmodel1))
#run 'emmeans' package for least-squares means of the model - previously lsmeans package, but that's being phased out of R https://cran.r-project.org/web/packages/emmeans/vignettes/transition-from-lsmeans.html
library(emmeans)
#run 'ggplot2' package to create figure of the model https://cran.r-project.org/web/packages/ggplot2/README.html
library(ggplot2)
#calculate emmeans of the treatment of the model 
emmeans(ewmodel1,"Treatment")
#create data frame for the model fitted with emmeans
fig1<-summary(emmeans(ewmodel1,"Treatment"))
fig1
names(fig1)
#Data frame for the figure with code for ggplot parameters - CREATES FIGURE 1
library(ggplot2)
#Data frame for the figure with code for ggplot parameters 
myfig1<-transform(fig1,Treatment=reorder(Treatment,-emmean))
ggplot(myfig1,aes(x = Treatment, y = emmean)) + 
  geom_bar(position=position_dodge(), stat="identity") +
  geom_errorbar(aes(ymax=emmean+SE, ymin=emmean-SE),
                width=0.1, size=0.5, color="black", position=position_dodge(.9))+  labs(x = "Treatment",
                                                                                        y = "Earthworm Biomass (g)")  +
  theme_bw()+
  theme(axis.text = element_text(size=12,colour = "black"))+
  theme(axis.title.x = element_text(size=12,face="bold")) +
  theme(axis.title.y = element_text(size=12,face="bold")) +
  theme(legend.title = element_text(size=12, face="bold"))+
  theme(legend.text = element_text(size = 12))+
  scale_y_continuous(expand = c(0,0)) +
  expand_limits(y=7) +
  theme(legend.position = "none")+
  theme(panel.border = element_blank(), panel.grid.major = element_blank(), panel.grid.minor = element_blank(),axis.line = element_line(colour = "black"))
############################# Exporting the plot #######################################
figure1<-ggplot(myfig1,aes(x = Treatment, y = emmean)) + 
  geom_bar(position=position_dodge(), stat="identity") +
  geom_errorbar(aes(ymax=emmean+SE, ymin=emmean-SE),
                width=0.1, size=0.5, color="black", position=position_dodge(.9))+  labs(x = "Treatment",
                                                                                        y = "Earthworm Biomass (g)")  +
  theme_bw()+
  theme(axis.text = element_text(size=12,colour = "black"))+
  theme(axis.title.x = element_text(size=12,face="bold")) +
  theme(axis.title.y = element_text(size=12,face="bold")) +
  theme(legend.title = element_text(size=12, face="bold"))+
  theme(legend.text = element_text(size = 12))+
  scale_y_continuous(expand = c(0,0)) +
  expand_limits(y=7) +
  theme(legend.position = "none")+
  theme(panel.border = element_blank(), panel.grid.major = element_blank(), panel.grid.minor = element_blank(),axis.line = element_line(colour = "black"))

ggsave("myfig1.tiff", figure1, units="in", width=5, height=5, dpi=300)
tiff("myfig1.tiff", width=5, height=5)
ggplot(myfig1,aes(x = Treatment, y = emmean)) + 
  geom_bar(position=position_dodge(), stat="identity") +
  geom_errorbar(aes(ymax=emmean+SE, ymin=emmean-SE),
                width=0.1, size=0.5, color="black", position=position_dodge(.9))+  labs(x = "Treatment",
                                                                                        y = "Earthworm Biomass (g)")  +
  theme_bw()+
  theme(axis.text = element_text(size=12,colour = "black"))+
  theme(axis.title.x = element_text(size=12,face="bold")) +
  theme(axis.title.y = element_text(size=12,face="bold")) +
  theme(legend.title = element_text(size=12, face="bold"))+
  theme(legend.text = element_text(size = 12))+
  scale_y_continuous(expand = c(0,0)) +
  expand_limits(y=7) +
  theme(legend.position = "none")+
  theme(panel.border = element_blank(), panel.grid.major = element_blank(), panel.grid.minor = element_blank(),axis.line = element_line(colour = "black"))
#Test of effects of Treatment on environmental variables
head(env)
#ANOVA of pH as a factor of treatment with site accounted for - RESULTS FOR TABLE 1
PHtest<-aov(ph~Treatment+site,data=env)
#summary of aforementioned ANOVA
summary(PHtest)
#plot the effects of the ANOVA 
plot(allEffects(PHtest))
#ANOVA of N as a factor of treatment with site accounted for
Ntrest<-aov(nitrogen~Treatment+site,data=env)
#summary of N ANOVA - RESULTS FOR TABLE 1
summary(Ntrest)
#ANOVA of plot moisture as a factor of treatment with site accounted for
moisturetest<-aov(moisture~Treatment+site,data=env)
#summary of moisture ANOVA - RESULTS FOR TABLE 1
summary(moisturetest)
#looking at stem counts
#read in csv file
stemcounts<-read.csv('stemcounts.csv',header=TRUE)
head(stemcounts)
#ANOVA of stem counts as a factor of site with treatment accounted for 
stemeffects<-aov(stem~site+treatment,data=stemcounts)
#summary of stem counts
summary(stemeffects)
#Figure 2/ANOVA table 1- looking at treatment effects on earthworms
#read in csv file
allvariables<-read.csv('spp_abundance_diversity_fxnl_group_values.csv',header=TRUE)
#show head of data frame
head(allvariables)
#test of fit with shannon diversity as a factor of earthworm biomass,treatment & site
shandiv<-lm(nativeShannon~mass+site+treatment,data=allvariables)
#type II ANOVA of this fit
Anova(shandiv, type="II")
#summary of ANOVA
summary(shandiv)
#new test of fit with shannon diversity as a factor of an interaction between earthworm biomass*treatment and site
shandiv2<-lm(nativeShannon~site+treatment*mass, data=allvariables)
#type II ANOVA of new fit
Anova(shandiv2, type="II")
#summary of ANOVA
summary(shandiv2)
#plot the effects of this new model fit
plot(allEffects(shandiv2))
#install 'jtools' package https://cran.r-project.org/web/packages/jtools/index.html
library(jtools)
#summary of the model reported
summ(shandiv2)
summ(shandiv2, scale = TRUE)
#list of hex codes for colors associated with color-blind palette "cbPalette"
cbPalette <- c("#000000", "#E69F00", "#56B4E9", "#009E73", "#F0E442", "#0072B2", "#D55E00", "#CC79A7")
#command for interaction plot
interact_plot(shandiv2, pred = "mass", modx = "Treatment", plot.points = TRUE)
#revised model with 'eradicated' sites excluded
shandiv3<-lm(nativeShannon~site+mass, data=allvariables[allvariables$Treatment=="Eradicated",])
#summary of the new model
summary(shandiv3)
#interaction plot of the original model with code for ggplot parameters 
interact_plot(shandiv2, pred = "mass", modx ="Treatment", plot.points = TRUE, x.label = "Earthworm Biomass (g)", y.label = "Native Plant Diversity", legend.main = "Treatment") +
  theme(axis.text = element_text(size=12))+
  theme(axis.title.x = element_text(size=12,face="bold")) +
  theme(axis.title.y = element_text(size=12,face="bold")) +
  theme(legend.text = element_text(size = 12))+
  scale_colour_manual(values=cbPalette)