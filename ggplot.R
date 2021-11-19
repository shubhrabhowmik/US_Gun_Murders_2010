#Plots in ggplot2 consist of 3 main components:
#Data: The dataset being summarized
#Geometry: The type of plot (scatterplot, boxplot, barplot, histogram, qqplot, smooth density, etc.)
#Aesthetic mapping: Variables mapped to visual cues, such as x-axis and y-axis values and color
#There are additional components: Scale, Labels, Title, Legend, Theme/Style

library(tidyverse)
library(dslabs)
data(murders)
View(murders)

murders %>% ggplot()+
  geom_point(aes(x=population/10^6, y=total))

# add points layer to predefined ggplot object
p = ggplot(data = murders)
p + geom_point(aes(population/10^6, total))

# add text layer to scatterplot
p + geom_point(aes(population/10^6, total)) +
  geom_text(aes(population/10^6, total, label = abb, nudge_x=1))


###
##
# Tinkering
# change the size of the points
p + geom_point(aes(population/10^6, total), size = 3) +
  geom_text(aes(population/10^6, total, label = abb))

# move text labels slightly to the right
p + geom_point(aes(population/10^6, total), size = 2) +
  geom_text(aes(population/10^6, total, label = abb), nudge_x = 2.5)

# simplify code by adding global aesthetic
p = murders %>% ggplot(aes(population/10^6, total, label = abb))
p + geom_point(size = 3) +
  geom_text(nudge_x = 1.5)

# local aesthetics override global aesthetics
p + geom_point(size = 3) +
  geom_text(aes(x = 10, y = 800, label = "Hello there!"))

# log base 10 scale the x-axis and y-axis
p + geom_point(size = 3) +
  geom_text(nudge_x = 0.05) +
  scale_x_continuous(trans = "log10") +
  scale_y_continuous(trans = "log10")

# efficient log scaling of the axes
p + geom_point(size = 3) +
  geom_text(nudge_x = 0.075) +
  scale_x_log10() +
  scale_y_log10()

# Add labels and title
p + geom_point(size = 3) +
  geom_text(nudge_x = 0.075) +
  scale_x_log10() +
  scale_y_log10() +
  xlab("Population in millions (log scale)") +
  ylab("Total number of murders (log scale)") +
  ggtitle("US Gun Murders in 2010")

# Change color of the points
# redefine p to be everything except the points layer
p = murders %>%
  ggplot(aes(population/10^6, total, label = abb)) +
  geom_text(nudge_x = 0.075) +
  scale_x_log10() +
  scale_y_log10() +
  xlab("Population in millions (log scale)") +
  ylab("Total number of murders (log scale)") +
  ggtitle("US Gun Murders in 2010")

# make all points blue
p + geom_point(size = 3, color = "blue")

# color points by region
p + geom_point(aes(col = region), size = 3)

#Change color of the points
# redefine p to be everything except the points layer
p <- murders %>%
  ggplot(aes(population/10^6, total, label = abb)) +
  geom_text(nudge_x = 0.075) +
  scale_x_log10() +
  scale_y_log10() +
  xlab("Population in millions (log scale)") +
  ylab("Total number of murders (log scale)") +
  ggtitle("US Gun Murders in 2010")

# make all points blue
p + geom_point(size = 3, color = "blue")

# color points by region
p + geom_point(aes(col = region), size = 3)

# Add a line with average murder rate
# define average murder rate
r = murders %>%
  summarize(rate = sum(total) / sum(population) * 10^6) %>%
  pull(rate)

# basic line with average murder rate for the country
p = p + geom_point(aes(col = region), size = 3) +
  geom_abline(intercept = log10(r))    # slope is default of 1

# change line to dashed and dark grey, line under points
p + 
  geom_abline(intercept = log10(r), lty = 2, color = "darkgrey") +
  geom_point(aes(col = region), size = 3)

# Change legend title
p = p + scale_color_discrete(name = "Region")    # capitalize legend title

# Adding themes
# theme used for graphs
library(dslabs)
ds_theme_set()
# themes for ggthemes
install.packages("ggrepel")
library(ggrepel)
install.packages("ggthemes")
library(ggthemes)
p + theme_economist() #style of the Economist magazine
p + theme_fivethirtyeight() #style of the FiveThirtyEight website



# Putting it all together 
library(tidyverse)
library(ggrepel)
library(ggplot2)
library(dslabs)
data("murders")

# define the intercept
r = murders %>%
  summarise(rate=sum(total)/sum(population)* 10^6) %>%
  .$rate
# make the plot, combining all elements
murders %>%
  ggplot(aes(population/10^6, total, label=abb))+
  geom_abline(intercept = log10(r), lty=2, color = 'darkgrey')+
  geom_point(aes(col=region), size = 3)+
  geom_text_repel()+
  scale_x_log10()+
  scale_y_log10()+
  xlab("Population in millions (log scale)")+
  ylab("Total number of Murders (log scale)")+
  ggtitle("US Gun Murders in 2010")+
  scale_color_discrete(name = "Region")+
  theme_economist()
  
  


