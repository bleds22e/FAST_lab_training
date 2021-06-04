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

data2017 <- read_csv("https://raw.githubusercontent.com/bleds22e/FAST_lab_training/master/data/dugout2017.csv")
data2019 <- read_csv("https://raw.githubusercontent.com/bleds22e/FAST_lab_training/master/data/dugout2019.csv")

# DATA PREP #

# Let's make the dataframes more manageable by selecting only the columns we want
# We'll be using Site_ID, Date, pH, DOC, and Landuse
# Check each column for any issues

data2017 <- data2017 %>% 
  select(Site_ID, Date, Surface_pH, CO2.uM, Landuse) %>% 
  mutate(Date = lubridate::dmy(Date)) %>% 
  mutate(Year = lubridate::year(Date))

data2019<- data2019 %>% 
  select(Site_ID = Site, Date, Surface_pH, CO2.uM) %>% 
  mutate(Date = lubridate::dmy(Date)) %>% 
  mutate(Year = lubridate::year(Date))

# add landuse column to 2019 data
# note that data2019 still only has 93 rows
#   - didn't add any additional rows because we left-joined into data2019
#   - any sites not sampled in 2017 have an NA in the landuse column
landuse <- select(data2017, Site_ID, Landuse)
data2019 <- left_join(data2019, landuse)

# bind dataframes together in long format
data_all <- bind_rows(data2017, data2019)
