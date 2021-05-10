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
hist(dugouts_small$DOC.mg.L) # that didn't work! why?

# why is it getting read in as a character?
dugouts_small$DOC.mg.L # note the wonky #N/A value
as.numeric(dugouts_small$DOC.mg.L) # what if we make them numeric instead of characters
dugouts_small$DOC.mg.L <- as.numeric(dugouts_small$DOC.mg.L) # re-assign the column as numeric
hist(dugouts_small$DOC.mg.L) # now it should run!

# scatter plot
plot(dugouts_small$Surface_pH, dugouts_small$DOC.mg.L)

# DATA WRANGLING #==============================================================
# using lubridate, tidyr, dplyr and the pipe

# Packages #
# library(tidyverse)

# Data #
data2017 <- dugouts_small
#data2017 <- readr::read_csv("data/dugout2017.csv")
data2019 <- readr::read_csv("https://raw.githubusercontent.com/bleds22e/FAST_lab_training/master/data/Dugout_master2019.csv")

# DPLYR: select, filter, mutate ####

# a lot of things that should be numeric are getting read in as characters
str(data2017)

# we can use mutate with one column to apply a function to that column
data2017 %>% 
  mutate(DOC.uM = as.numeric(DOC.uM))

# we can also use mutate across multiple columns with the across function
# this is fairly advanced--I had to look up how it works!
# I did that by typing ?mutate in my console and scrolling down to the examples
# at the bottom of the help page.
data2017 %>% 
  mutate(across(NH3.mg.N.L:DIC.uM, as.numeric))

# LUBRIDATE: easily working with dates and times #
# lubridate is part of the tidyverse and gets installed when you install the tidyverse
# however, it isn't one of the "core" packages that gets loaded into R when you
# use the library function to load tidyverse. Therefore, we need to use the 
# library function to load in lubridate on its own here
library(lubridate)

?dmy
# we can use lubridate functions with the mutate function
data2017 %>% 
  mutate(Date = lubridate::dmy(Date))

# if we look at the structure of data2017, we see that nothing has changed. Why?
str(data2017)

# we can string multiple statements together using pipes
data2017 <- data2017 %>% 
  mutate(DOC.uM = as.numeric(DOC.uM),
         Date = dmy(Date)) %>% 
  mutate(across(NH3.mg.N.L:DIC.uM, as.numeric))


