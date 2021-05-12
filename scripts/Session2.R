# R BASICS #====================================================================

# start in the console #
# follow 'Intro to R' page on Data Carpentry #

# PACKAGES and DATA #===========================================================

# load the tidyverse (mostly for tidyr, dplyr, and ggplot2)
library(tidyverse)

# load in data from URL--you've probably already done this
# download.file(url = "https://raw.githubusercontent.com/bleds22e/FAST_lab_training/master/data/Dugout_master%202017.csv",
#               destfile = "data/dugout2017.csv")
dugouts <- readr::read_csv("data/dugout2017.csv")

# another way to read in your data is by putting the URL directly into the
# read_csv function. This will read the data into your environment but
# will not download the data into your project
# dugouts <- readr::read_csv("https://raw.githubusercontent.com/bleds22e/FAST_lab_training/master/data/Dugout_master%202017.csv")

# you can use a different package (readxl) to read in Excel files:
# I recommend converting all of your Excel files to csv (Save As and then change
# the file format to csv), but when working with other people's data, you might
# have to read in Excel files
# dugouts <- readxl::read_excel("data/Dugout_master 2017.xlsx")


# DATA EXPLORATION #============================================================

summary(dugouts)
colnames(dugouts)
str(dugouts)

# remove rows that are all NA
tail(dugouts)
dugouts <- dugouts[-(103:104),]

# let's select a few columns we do want
dugouts_small <- dugouts[c(1,4, 18:23, 38:57)]

# fix the date
head(dugouts_small) # shows the first 6 rows of the dataframe
unique(dugouts_small$Date) # shows all the unique values in the Date column
dugouts_small[dugouts_small$Date == "24-Jul",] # shows us the row(s) when date is wonky
head(dugouts_small) # note the row number and column number where the wonky date is
dugouts_small[5, 2] <- "24-Jul-17" # reassign date value that includes year
head(dugouts_small) # check that the value changed

# PLOTTING #====================================================================

# histograms
hist(dugouts_small$Surface_pH)
#hist(dugouts_small$DOC.mg.L) # that didn't work! why?

# why is it getting read in as a character?
dugouts_small$DOC.mg.L # note the wonky #N/A value
as.numeric(dugouts_small$DOC.mg.L) # what if we make them numeric instead of characters
dugouts_small$DOC.mg.L <- as.numeric(dugouts_small$DOC.mg.L) # re-assign the column as numeric
hist(dugouts_small$DOC.mg.L) # now it should run!

# scatter plot
plot(dugouts_small$Surface_pH, dugouts_small$DOC.mg.L)

#####

# DATA WRANGLING #==============================================================
# using lubridate, tidyr, dplyr and the pipe

# Packages #
library(tidyverse)

# Data #

# if we use the na argument, the default column changes to double
# we can explore the columns that should be numeric to see what the issues are
data2017 <- readr::read_csv("data/dugout2017.csv", na = c("", "NA", "#N/A", "#VALUE!")) 

# explore some columns that should be numeric but are reading as character

# drop 
data2017 <- data2017[-(103:104),]
data2017[5, 4] <- "24-Jul-17" # reassign date value that includes year


# DPLYR: select, filter, mutate ####

# SELECT #
subset2017 <- select(data2017, Site_ID, Date, Surface_Cond, SO4.mg.L)

# FILTER #


# MUTATE # 
# a lot of things that should be numeric are getting read in as characters
str(subset2017)

# we can use mutate with one column to apply a function to that column
as.numeric(subset2017$SO4.mg.L)

subset2017 %>% 
  mutate(SO4.mg.L = as.numeric(SO4.mg.L))

# LUBRIDATE: easily working with dates and times #
# lubridate is part of the tidyverse and gets installed when you install the tidyverse
# however, it isn't one of the "core" packages that gets loaded into R when you
# use the library function to load tidyverse. Therefore, we need to use the 
# library function to load in lubridate on its own here
# library(lubridate)

?dmy
# we can use lubridate functions with the mutate function
subset2017$Date
subset2017 %>% 
  mutate(Date = lubridate::dmy(Date))

# we can do calculations with mutate and create a new column
subset2017 %>% 
  mutate(log_CH4_ebullition = 8.417 + (-3.201*log10(Surface_Cond)))

# if we look at the structure of data2017, we see that nothing has changed. Why?
str(subset2017)

# we can string multiple statements together using pipes
subset2017 <- subset2017 %>% 
  mutate(SO4.mg.L = as.numeric(SO4.mg.L),
         Date = dmy(Date),
         log_CH4_ebullition = 8.417 + (-3.201*log10(Surface_Cond)))

pH_DOC_2017 <- data2017 %>% 
  select(Site_ID, Date, Surface_pH, DOC.mg.L) %>% 
  mutate(Date = lubridate::dmy(Date)) %>% 
  mutate(Year = lubridate::year(Date))

# GROUP BY and SUMMARIZE #
# just explain group_by? maybe as east/west? urban/rural?
# summarize average pH and DOC

# JOINS #

# 2019 data
data2019 <- readr::read_csv("https://raw.githubusercontent.com/bleds22e/FAST_lab_training/master/data/Dugout_master2019.csv",
                            na = c("", "NA", "#N/A", "#VALUE!"))

# check out Cloud (%) column to see what is going on there
# using stringr
data2019 <- data2019 %>% 
  mutate(Cloud_perc = stringr::str_replace(.$`Cloud (%)`, "%", ""),
         Date = lubridate::dmy(Date))

# joining
pH_2019 <- select(data2019, Site, Date, Surface_pH) %>% 
  arrange(Surface_pH) %>% 
  mutate(Year = lubridate::year(Date))
DOC_2019 <- select(data2019, Site, Date, DOC.mg.L) %>% 
  arrange(DOC.mg.L)

# now we want to combine these two dataframes
# DOC is now no longer in ascending order because the values have been matched 
# up by Site and Date
left_join(pH_2019, DOC_2019)
pH_DOC_2019 <- full_join(pH_2019, DOC_2019)

# let's get a little more complicated now
# explain "by"
# explain why x and y show up
# show why total number of rows is greater than either 2017 or 2019 alone
all_pH_DOC <- full_join(pH_DOC_2017, pH_DOC_2019, by = c("Site_ID" = "Site"))

# this was just for a demonstration
# a better idea would be to bind rows
pH_DOC_2017 <- pH_DOC_2017 %>% 
  select(Site = Site_ID, Year, Surface_pH, DOC.mg.L)
pH_DOC_2019 <- pH_DOC_2019 %>% 
  select(Site, Year, Surface_pH, DOC.mg.L)
all_pH_DOC <- bind_rows(pH_DOC_2017, pH_DOC_2019)

# PIVOT_WIDER and PIVOT_LONGER #

(longer <- all_pH_DOC %>% 
  pivot_longer(Surface_pH:DOC.mg.L,
               names_to = "Measurement",
               values_to = "Value"))

(wider<- longer %>% 
    pivot_wider(names_from = Year,
                values_from = Value))
