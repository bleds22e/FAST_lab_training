# R BASICS ####






# PACKAGES and DATA ####

# load the tidyverse (mostly for tidyr, dplyr, and ggplot2)
library(tidyverse)

# load in data from URL
download.file(url = "https://raw.githubusercontent.com/bleds22e/FAST_lab_training/master/data/Dugout_master%202017.csv",
              destfile = "data/dugout2017.csv")
dugouts <- readr::read_csv("data/dugout2017.csv", skip_empty_rows = TRUE)
#dugouts <- read_csv("https://raw.githubusercontent.com/bleds22e/FAST_lab_training/master/data/Dugout_master%202017.csv")

# DATA EXPLORATION #

summary(dugouts)
colnames(dugouts)
str(dugouts)
head(dugouts)
tail(dugouts)

# remove extra two rows
dugouts <- dugouts[-(103:104),]

# plotting 
hist(dugouts$Surface_pH)
hist(dugouts$DOC.mg.L) # why is it getting read in as a character?

dugouts$DOC.mg.L
unique(dugouts$Date) # replace 24-Jul?

dugouts[dugouts$Date == '24-Jul',]

dugouts$DOC.mg.L <- as.numeric(dugouts$DOC.mg.L)

plot(dugouts$Surface_pH, dugouts$DOC.mg.L)
