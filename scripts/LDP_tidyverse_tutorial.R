#########################################################
#####   Living Data Project -- Data Management      #####
#####   Data Manipulation $ Data Wrangling          #####
#####   Introduction to some useful packages        #####
#########################################################
#####   Self-directed tutorial                      #####
#########################################################



### SET-UP ---------------------------------------------------------------------

## Working Directory ##

## check if working directory is set to current folder
getwd()   
# if it is not the correct folder, use setwd() to set it to the correct folder
# alternatively, in the panel with the "Files" tab, navigate to the correct folder,
# then click "More" (with the gear next to it), and select "Set As Working Directory"


## Packages ##

### import (or install) required packages
library(tidyverse)
library(lubridate)

## to install missing packages, go to "Tools" -> "Install Packages..."  ~or~
## run install.packages() with the package name in quotes inside the parentheses
## after installing via either option, run the code above again (library())


## Import Files ##

## what files are in the BWG database
myfiles = list.files(path = "BWG_database/", pattern = "*.csv", full.names = TRUE)
myfiles

# import all tables as separate data frames, remove file path and file extensions (.csv)
# don't worry about what exactly this code is saying--just run it :)
list2env(lapply(setNames(myfiles, make.names(gsub(".*1_", "", tools::file_path_sans_ext(myfiles)))), 
         read.csv), envir = .GlobalEnv)


### Part 1: DATA MANIPULATION AND JOINING TABLES -------------------------------

## some of this may be review for you (especially if you already took the 
## Synthesis Statistics module). Feel free to just skip over the sections you 
## are already comfortable with (but still run the code).



### The pipe: %>% ###
## keyboard shortcut: Ctrl+shift+m / cmd+shift+m

# the pipe %>% allows for "chaining", which means that you can invoke multiple 
# method calls without needing variables to store the intermediate results.

## Example
# check out the mtcars dataframe that was loaded with tidyverse
head(mtcars)

## Let's calculate the average mpg for each cylinder (cyl)

# Option 1: Store each step in the process sequentially
result_int <- group_by(mtcars, cyl)
result_int

result <- summarise(result_int, meanMPG = mean(mpg))
result

# Option 2: use the pipe %>% to chain the functions together
result <- group_by(mtcars, cyl) %>% 
  summarise(meanMPG = mean(mpg))
result

# using the pipe, we did not have to ceate an intermediate object (result_int)

# remove the two objects from global environment
rm(result)
rm(result_int)



### DPLYR::SELECT ###
## select the columns you want to work with

## first, let's take a look at the structure of the bromeliads data frame
str(bromeliads)

## to select columns by name:
bromeliads %>%
  select(bromeliad_id, species)

## to select columns column number:
bromeliads %>%
  select(1:3, 5)

## Create a new dataframe called bromeliads_selected
# include the columns: bromeliad_id, species, num_leaf, extended_diameter, 
# max_water, and total_detritus
bromeliads_selected <- bromeliads %>%
  select(bromeliad_id, species, num_leaf, extended_diameter, max_water, total_detritus)
head(bromeliads_selected)



### DPLYR::RENAME ###

## we can rename a variable within the select command
bromeliads_selected <- bromeliads %>%
  select(visit_id, bromeliad_id, species, num_leaf, 
         diameter = extended_diameter, 
         volume = max_water, 
         total_detritus)
head(bromeliads_selected)

# or by using DPLYR::RENAME
bromeliads_selected <- bromeliads_selected %>%
  dplyr::rename(detritus = total_detritus)
head(bromeliads_selected)



### DPLYR::ARRANGE ###
## We can sort this dataframe by the values for bromeliad volume
bromeliads_selected %>%
  arrange(volume)


## ARRANGE: descending
## We can also reverse the order, sorting from largest to smallest
bromeliads_selected %>%
  arrange(desc(volume))



### GGPLOT2: plot relationship of volume and detritus
ggplot(bromeliads_selected, aes(x = detritus, y = volume, color = species)) +
  geom_point()

## maybe log-scale is better, and add diameter as size
ggplot(bromeliads_selected, aes(x = detritus, y = volume, 
                                color = species, size = diameter)) +
  geom_point() +
  scale_x_log10() +
  scale_y_log10()

##facet wrap
ggplot(bromeliads_selected, aes(x = detritus, y = volume, size = diameter)) +
  geom_point() +
  scale_x_log10() +
  scale_y_log10() +
  facet_wrap(~ species)



### DPLYR::FILTER ###

## let's subset our data to include only Guzmania_sp
bromeliads_selected %>%
  arrange(volume) %>%
  filter(species == "Guzmania_sp")

## we can also filter for multiple species
bromeliads_selected %>%
  arrange(volume) %>%
  filter(species %in% c("Guzmania_sp", "Vriesea_sp"))

## we may also want all bromeliads in the Vriesea genus
# for that we can use stringr::str_detect 
bromeliads_selected %>%
  arrange(volume) %>%
  filter(str_detect(species, "Vriesea"))

## some species are only found in bromeliads with a maximum volume > 100 ml
# (let's use filter to subset for Guzmania bromeliads > 100 ml only
bromeliads_selected %>%
  arrange(volume) %>%
  filter(species == "Guzmania_sp",
         volume > 100)



### DPLYR::COUNT ###
## Count the number of bromeliads for each species in our dataset
bromeliads_selected %>%
  count(species)

## sort from most to least common
bromeliads_selected %>%
  count(species) %>%
  arrange(desc(n))

## you can also use
bromeliads_selected %>%
  count(species, sort = TRUE)



### DPLYR::MUTATE ###

## Bromeliads contain little wells that are formed in the axils of their leaves.
## Let's create a new column (av_well_volume) that represents the average volume 
## of a bromeliad leaf well
bromeliads_selected %>%
  mutate(av_well_volume = volume / num_leaf)


### MUTATE in combination with ifelse
## let's categorize bromeliads based on their water holding capacity
## small: < 50 mL
## medium: 50 - 100 mL
## large: > 100 mL
bromeliads_selected %>%
  mutate(bromeliad_size = ifelse(volume < 50, "small",
                                 ifelse(volume <= 100, "medium",
                                        ifelse(volume > 100, "large", NA))))

## let's visualize how many bromeliads we have in each size category by piping this into count and ggplot
bromeliads_selected %>%
  mutate(bromeliad_size = ifelse(volume < 50, "small",
                                 ifelse(volume <= 100, "medium",
                                        ifelse(volume > 100, "large", NA)))) %>%
  count(bromeliad_size) %>%
  ggplot(aes(x=bromeliad_size, y=n)) +
  geom_bar(stat = "identity")



#### EXERCISE 1: #### (All exercise answers are at the bottom of the script)
## Combine what you have learned so far.
## Create a new dataframe (Guzmania_selected) from the bromeliads_selected table
## only include bromeliads > 100 ml. Add a column for the average well volume 
## (av_well_volume), and sort by this column from largest to smallest.

#Guzmania_selected <- bromeliads_selected %>%
#  ---

#####



### DPLYR::TRANSMUTE ###
## maybe we are only interested in the average well volume, without wanting the 
## volume column and the num_leaf column
bromeliads_selected %>%
  transmute(bromeliad_id, species, av_well_volume = volume / num_leaf)



### DPLYR::SUMMARIZE ###

## what is the mean volume across all bromeliads (use bromeliads_selected)
bromeliads_selected %>%
  summarize(mean_volume = mean(volume))

## oh no! This gives us NA
bromeliads_selected$volume
# that is because there are NAs in our data

## let's try again
bromeliads_selected %>%
  summarize(mean_volume = mean(volume, na.rm = TRUE))

## we can also summarize several columns at once
bromeliads_selected %>%
  summarize(mean_volume = mean(volume, na.rm = TRUE),
            max_volume = max(volume, na.rm = TRUE),
            med_leaves = median(num_leaf, na.rm = TRUE),
            n = n())



### DPLYR::GROUP_BY - AGGREGATE WITHIN GROUPS ###

# we can also summarize for each species
bromeliads_selected %>%
  group_by(species) %>%
  summarize(mean_volume = mean(volume, na.rm = TRUE),
            max_volume = max(volume, na.rm = TRUE),
            med_leaves = median(num_leaf, na.rm = TRUE),
            n = n()) %>%
  arrange(desc(n))



### TIDYR::SEPARATE ###

## we may also want to group by genus
## for that, we need to create a new column (Genus)
head(bromeliads_selected)
head(separate(data = bromeliads_selected, col = species,
                    into = c("Genus", "Species"),
                    sep = "_", remove = FALSE))

## pipe into group_by and summarize to get summary statistics for the genera
separate(data = bromeliads_selected, col = species,
         into = c("Genus", "Species"),
         sep = "_", remove = FALSE) %>%
  group_by(Genus) %>%
  summarize(mean_volume = mean(volume, na.rm = TRUE),
            max_volume = max(volume, na.rm = TRUE),
            med_leaves = median(num_leaf, na.rm = TRUE),
            n = n()) %>%
  arrange(desc(n))



#### EXERCISE 2: #### 
## Which bromeliad genus has a higher fraction of large bromeliads (> 100 ml)?
## use what you have learned to create a table that lists the number of small 
## and large bromeliads for each genus. Use this table to calculate the fraction
## of large (>100 mL) bromeliads by hand. If you feel ambitions, calculate the 
## fractions in R (TIDYR:PIVOT_WIDER will come handy here)

# Genus_sizes <- bromeliads_selected %>%
# ---


#####



#### PART 2: Joining Tables #### -----------------------------------------------

## We may want to find out when these bromeliads were sampled.
## However, this information is not in the bromeliad table.
names(bromeliads)

# Having a look at our BWG database diagram, we can see that sampling dates are 
# stored in the "visits" table, which is connected to the "bromeliads" table via 
# the key "visit_id"

# lets check out visits (click on visits in your global environment)
str(visits)

## let's convert the dates to the right format so we can work with them
visits$date
visits$date <- as_date(visits$date) # convert to date-times format


### DPLYR::LEFT_JOIN ###
# lets join visits to bromeliads to extract the sampling dates

head(bromeliads_selected %>%
  left_join(visits, by = "visit_id") )

# but we don't really want all these columns, as this get's way to busy
# let's use join in combination with select
names(visits)
select(visits, visit_id, dataset_id, date, latitude, longitude)

bromeliad_visits <- bromeliads_selected %>%
  left_join(select(visits, visit_id, dataset_id, date, latitude, longitude), 
            by = "visit_id")
head(bromeliad_visits)

## NOTE: using left_join (as opposed to inner_join) ensures that all rows in the 
## bromeliad table are preserved. However, in this case this does not make a 
## difference, as all visit_id keys are represented in both tables.


### JOINING MULTIPLE TABLES ###

# What countries were the bromeliads sampled in?
# the country data is in the "datasets" table (two tables away)

# join bromeliads_selected table with the countries column of the datasets table
bromeliads_selected %>%
  left_join(select(visits, visit_id, dataset_id), by = "visit_id") %>%
  left_join(select(datasets, dataset_id, country), by = "dataset_id")

# all bromeliads were sampled in Costa Rica!


#### EXERCISE 3: add two new columns to the bromeliad_selected table that lists 
## the name and affiliation of the dataset owner

# bromeliads_owners <- bromeliads_selected %>%
#    ---


## QUESTION: this increased the number of rows from 76 to 114. Why do you think 
## this happened?
dim(bromeliads_selected)
dim(bromeliads_owners)



### PART 3: A VERY BRIEF INTRODUCTION TO SOME MORE USEFUL PACKAGES ### ---------
## the purpose is not to give you a detailed tutorial, but to make you aware 
## that these packages exist and what you can use them for


### STRINGR: working with strings ###

## Let's look at the abundance table
head(abundance)
str(abundance)


## How many morphospecies are there in the species pool?
# (since R is case sensitive, it is advised to always convert everything to lower case when working with strings)
morphospecies <- str_to_lower(levels(as.factor(abundance$bwg_name)))
morphospecies # these are all the morphospecies
length(morphospecies) # there are 40 morphospecies


### How many morphospecies belong to the family Diptera?
# we can use the str_match function to extract all diptera
str_match(morphospecies, "diptera")

# we can use PLYR::COUNT (note: do not import plyr from your library, as some functions conflict with dplyr)
plyr::count(str_match(morphospecies, "diptera"))

# alternatively, use STR_COUNT and take the sum
sum(str_count(morphospecies, "diptera"))

#####


### LUBRIDATE: working with dates and times ###
## Let's look at the visits table
head(visits)
str(visits)

# we already converted the dates column to the right format above
# visits$date <- as_date(visits$date) # convert to date-times format
class(visits$date) # this should be "Date"

# check out the date column
visits$date

# extract year / month / day
year(visits$date)
month(visits$date)
month(visits$date, label = TRUE, abbr = FALSE)
day(visits$date)

max(visits$date) # the oldest date
min(visits$date) # the newest date

# what was the maximum timespan?
max(visits$date) - min(visits$date)

#####


### RGDAL: dealing with spatial data ###

## Let's look at the visits table again
head(visits)
str(visits)

# note that we have columns for longitude and latitude
xy <- visits[c("longitude", "latitude")]
xy

## we may want to convert those to UTM

## first, convert coordinates to "SpatialPoints"
coordinates(xy) <- c("longitude", "latitude")
proj4string(xy) <- CRS("+proj=longlat +datum=WGS84")
xy

# transform to UTM coordinate system
xy_utm <- spTransform(xy, CRS("+proj=utm +zone=16 +datum=WGS84"))
xy_utm

#####


### TAXIZE and MYTAI: extracting taxonomic data ###

# extract the taxonomic classification for bromeliad-dwelling damselflies (M. modesta)
#taxize::classification
classification("Mecistogaster modesta", db = 'ncbi')

# what other species are in the Mecistogaster genus?
# myTAI::taxonomy
taxonomy(organism = "Mecistogaster" , db = "ncbi", output = "children" )



###### EXERCISE SOLUTIONS ###### -----------------------------------------------

### EX 1 SOLUTION ####
Guzmania_selected <- bromeliads_selected %>%
  filter(species == "Guzmania_sp",
         volume > 100) %>%
  mutate(av_well_volume = volume / num_leaf) %>%
  arrange(desc(av_well_volume))
head(Guzmania_selected)

## if we want to remove this last column from our table again, we can do this with
Guzmania_selected <- Guzmania_selected %>%
  select(-av_well_volume)
head(Guzmania_selected)
#####


#### EX 2 SOLUTION ####
Genus_sizes <- bromeliads_selected %>%
  # create new column for small (<= 100mL) and large (> 100ml) bromeliads
  mutate(bromeliad_size = ifelse(volume <= 100, "small",
                                 ifelse(volume > 100, "large", NA))) %>%
  # create new column for Genus using tidyr::seperate
  separate(col = species,
           into = c("Genus", "Species"),
           sep = "_", remove = FALSE) %>%
  # group by Genus, then count by bromeliad_size
  group_by(Genus) %>%
  count(bromeliad_size) 
Genus_sizes

# calculate fraction of large bromeliads by hand

# or do it in R
pivot_wider(Genus_sizes, names_from = bromeliad_size, values_from = n) %>%
  summarize(fraction_large = large / (large + small))

# Vriesea has almost twice the amount of large bromeliads than Guzmania
#####


#### EX 3 SOLUTION ####
bromeliads_owners <- bromeliads_selected %>%
  left_join(select(visits, visit_id, dataset_id), by = "visit_id") %>%
  left_join(ownership, by = "dataset_id") %>%
  left_join(select(owners, owner_id, owner_name, institution), by = "owner_id")
bromeliads_owners

## QUESTION: this increased the number of rows from 76 to 114. 
## Why do you think this happened?

#### ANSWER ####
## The rows with bromeliads from datasets owned by multiple people are duplicated 
## (see "ownership" table)
#####
