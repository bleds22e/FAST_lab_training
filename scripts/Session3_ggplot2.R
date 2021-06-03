##### INTRO TO PLOTTING WITH GGPLOT2 #####
# ggplot2 overview: https://ggplot2.tidyverse.org/
# ggplot2 extensions: https://exts.ggplot2.tidyverse.org/gallery/
# Data Carpentry ggplot lesson: 
#     https://datacarpentry.org/R-ecology-lesson/04-visualization-ggplot2.html

# usedata from 2 different years for faceting
# lots of things to use for scatter plots...
# can use year and/or landuse for categorical variable for box/violin plots
#   - will need to merge landuse data from 2017 with 2019

# PACKAGES AND DATA #
library(tidyverse)

data2017 <- read.csv("https://raw.githubusercontent.com/bleds22e/FAST_lab_training/master/data/dugout2017_plotting.csv")
data2019 <- read_csv("https://raw.githubusercontent.com/bleds22e/FAST_lab_training/master/data/dugout2019_plotting.csv")

# DATA PREP #
