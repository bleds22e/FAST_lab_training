##### INTRO TO PLOTTING WITH GGPLOT2 #####
# ggplot2 overview: https://ggplot2.tidyverse.org/
# ggplot2 extensions: https://exts.ggplot2.tidyverse.org/gallery/
# Data Carpentry ggplot lesson: 
#     https://datacarpentry.org/R-ecology-lesson/04-visualization-ggplot2.html

# PACKAGES AND DATA #
library(tidyverse)

data2017 <- read_csv("https://raw.githubusercontent.com/bleds22e/FAST_lab_training/master/data/dugout2017.csv")
data2019 <- read_csv("https://raw.githubusercontent.com/bleds22e/FAST_lab_training/master/data/dugout2019.csv")

# usedata from 2 different years for faceting
# lots of things to use for scatter plots...
# can use year and/or landuse for categorical variable for box/violin plots
#   - will need to merge landuse data from 2017 with 2019

# DATA PREP ####

# Let's make the dataframes more manageable by selecting only the columns we want
# We'll be using Site_ID, Date, pH, CO2, and Landuse
# Check each column for any issues

data2017 <- data2017 %>% 
  select(Site_ID, Date, Surface_pH, pCO2, Landuse) %>% 
  mutate(Date = lubridate::dmy(Date)) %>% 
  mutate(Year = as.factor(lubridate::year(Date)))

data2019<- data2019 %>% 
  select(Site_ID = Site, Date, Surface_pH, pCO2) %>% 
  mutate(Date = lubridate::dmy(Date)) %>% 
  mutate(Year = as.factor(lubridate::year(Date)))

# add landuse column to 2019 data
# note that data2019 still only has 93 rows
#   - didn't add any additional rows because we left-joined into data2019
#   - any sites not sampled in 2017 have an NA in the landuse column
landuse <- select(data2017, Site_ID, Landuse)
data2019 <- left_join(data2019, landuse)

# bind dataframes together in long format
data_all <- bind_rows(data2017, data2019) %>% 
  drop_na()

# PLOTTING WITH GGPLOT2 ####

# general structure:
# ggplot(data = <DATA>, mapping = aes(<MAPPINGS>)) +  
# <GEOM_FUNCTION>()

# check axes -- but where are the data?
ggplot(data = data_all, mapping = aes(x = Surface_pH, y = pCO2)) 

# add in geoms
ggplot(data = data_all, mapping = aes(x = Surface_pH, y = pCO2)) + 
  geom_point()

# build plots iteratively -- demonstrate + functionality
pH_CO2 <- ggplot(data = data_all, 
                 mapping = aes(x = Surface_pH, y = pCO2))
pH_CO2 +
  geom_point()

# can start modifying the plot
ggplot(data = data_all, mapping = aes(x = Surface_pH, y = pCO2)) + 
  geom_point(alpha = 0.5)

# change colors
ggplot(data = data_all, mapping = aes(x = Surface_pH, y = pCO2)) + 
  geom_point(alpha = 0.5, color = "dark green")

# if we want to specify that something (color, point shape, etc.) changes with 
# a certain variable, we specify that within the aes() function
ggplot(data = data_all, mapping = aes(x = Surface_pH, y = pCO2)) + 
  geom_point(alpha = 0.5, aes(color = Landuse))

ggplot(data = data_all, mapping = aes(x = Surface_pH, y = pCO2)) + 
  geom_point(alpha = 0.5, aes(color = Landuse)) +
  scale_y_log10() # can adjust axes within the plot

ggplot(data = data_all, mapping = aes(x = Surface_pH, y = pCO2)) + 
  geom_point(aes(color = Landuse)) +
  geom_hline(yintercept = 400) + # can add lines for annotating plots (but also data)
  scale_y_log10()
  
# OTHER GEOMS #

# boxplot
ggplot(data = data_all, mapping = aes(x = Landuse, y = pCO2)) + 
  geom_boxplot()

# add points to give a better idea of distribution
ggplot(data = data_all, mapping = aes(x = Landuse, y = pCO2)) + 
  geom_boxplot() +
  geom_point()

# change alphas
ggplot(data = data_all, mapping = aes(x = Landuse, y = pCO2)) + 
  geom_boxplot(alpha = 0) +
  geom_point(alpha = 0.5)

# change to jitter (and tomato to show that order matters)
ggplot(data = data_all, mapping = aes(x = Landuse, y = pCO2)) + 
  geom_boxplot(alpha = 0) +
  geom_jitter(color = "tomato")

# re-order
ggplot(data = data_all, mapping = aes(x = Landuse, y = pCO2)) + 
  geom_jitter(color = "tomato") +
  geom_boxplot(alpha = 0)

# can change axes 
ggplot(data = data_all, mapping = aes(x = Landuse, y = pCO2)) + 
  geom_jitter(color = "tomato") +
  geom_boxplot(alpha = 0) +
  scale_y_log10()

# violin 
ggplot(data = data_all, mapping = aes(x = Landuse, y = pCO2)) + 
  geom_jitter(color = "tomato") +
  geom_violin(alpha = 0)

### CHALLENGE ###
# Make a box plot (with or without points) of pH by year
ggplot(data_all, aes(Year, Surface_pH)) +
  geom_jitter(width = 0.1) +
  geom_boxplot(alpha = 0)
###


# very quick demonstration of geom_line
# not an ideal example but 
site10 <- data_all %>% 
  filter(Site_ID %in% c("10A", "10B", "10C", "10D"))

ggplot(data = site10, aes(x = Date, y = Surface_pH)) + 
  geom_line(aes(color = Site_ID))

# FACETING #
# splits one plot into multiple panels based on a variable

ggplot(data_all, aes(x = Surface_pH, y = pCO2)) +
  geom_point() +
  facet_wrap(facets = vars(Landuse)) # facet wrap for 1 variable

# split by year within a single plot
ggplot(data_all, aes(x = Surface_pH, y = pCO2)) +
  geom_point(aes(color = Year)) +
  facet_wrap(facets = vars(Landuse)) 

# we can convey the same thing by faceting by both variables
# with 2 variables, we have to use facet_grid
# can also rows or cols argument alone
ggplot(data_all, aes(x = Surface_pH, y = pCO2)) +
  geom_point() +
  facet_grid(rows = vars(Year), cols = vars(Landuse)) 
  # old syntax that you might see is facet_grid(Year ~ Landuse)

# if you want to keep the separate colors, you can
ggplot(data_all, aes(x = Surface_pH, y = pCO2)) +
  geom_point(aes(color = Year)) +
  facet_grid(Year ~ Landuse)

# THEMES #
# adjusting other parts of the plots

ggplot(data_all, aes(x = Surface_pH, y = pCO2)) +
  geom_point() +
  facet_wrap(facets = vars(Landuse)) + 
  theme_bw()

# many others, like theme_minimal, theme_light, theme_void

# adjust labels
ggplot(data_all, aes(x = Surface_pH, y = pCO2)) +
  geom_point() +
  facet_wrap(facets = vars(Landuse)) + 
  labs(title = "Relationship between pH and CO2 by Land Type",
       x = "pH") +
  theme_bw()

# changing size, etc. using theme()
ggplot(data_all, aes(x = Surface_pH, y = pCO2)) +
  geom_point() +
  facet_wrap(facets = vars(Landuse)) + 
  labs(title = "Relationship between pH and CO2 by Land Type",
       x = "pH") +
  theme_bw() +
  theme(text = element_text(size = 16))
# or can be more specific with theme(axis...)
ggplot(data_all, aes(x = Surface_pH, y = pCO2)) +
  geom_point() +
  facet_wrap(facets = vars(Landuse)) + 
  labs(x = "pH") +
  theme_bw() +
  theme(axis.title = element_text(size = 16))

# can save theme as it's own thing
my_theme <- theme()

# go into patchwork? depending on time
plot1 <- ggplot(data = data_all, mapping = aes(x = Landuse, y = pCO2)) + 
  geom_jitter(color = "tomato") +
  geom_violin(alpha = 0)

plot2 <- ggplot(data_all, aes(x = Surface_pH, y = pCO2)) +
  geom_point() +
  facet_wrap(facets = vars(Landuse)) + 
  theme_bw()

library(patchwork)

plot1 + plot2
plot1 / plot2 + plot_layout(heights = c(3, 1))

# ggsave!