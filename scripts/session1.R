# R BASICS ####

# in the console #

3 + 5
12/7

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

# remove columns we don't want
tail(dugouts)
dugouts <- dugouts[-(103:104),]

# let's select a few columns we do want
dugouts_small <- dugouts[c(1,4, 18:23, 38:57)]

# fix the date
head(dugouts_small)
unique(dugouts_small$Date)
dugouts[dugouts_small$Date == "24-Jul",]

# PLOTTING #

# histograms
hist(dugouts_small$Surface_pH)
hist(dugouts_small$DOC.mg.L) 

# why is it getting read in as a character?
dugouts_small$DOC.mg.L
as.numeric(dugouts_small$DOC.mg.L)
dugouts_small$DOC.mg.L <- as.numeric(dugouts_small$DOC.mg.L)

# scatter plot
plot(dugouts_small$Surface_pH, dugouts_small$DOC.mg.L)
