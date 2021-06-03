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

data2017 <- read_csv("data/dugout2017.csv")
data2019 <- read_csv("data/Dugout_master2019.csv")

# DATA PREP #
data2017[5,4] <- "24-Jul-17"

data2017_plotting <- data2017 %>% 
  select(Site_ID, Date, Surface_pH, DOC.mg.L, Landuse) %>% 
  drop_na()
write_csv(data2017_plotting, "data/dugout2017_plotting.csv")

data2019_plotting <- data2019 %>% 
  select(Site_ID, Date, Surface_pH, DOC.mg.L)
write_csv(data2019_plotting, "data/dugout2019_plotting.csv")
