# MERGE MASTER FILES 2017-2020 #### 

library(tidyverse)
library(hms)
library(stringr)

# DATA ####

# 2017 data
master2017 <- read_csv("data/dugout_master2017.csv",
                       na = c("", "NA", "#N/A", "#VALUE!", "#DIV/0!"))
# make some quick fixes to the dataframe (from dugouts_2017_complete.R)
master2017 <- master2017[-(103:104),] # remove last two columns of NAs
master2017[5, 4] <- "24-Jul-17" # reassign date value that includes year
master2017 <- master2017[-(2:3),] # remove sorting and site name columns

# 2018 data
master2018 <- read_csv("data/dugout_master2018.csv",
                       na = c("", "NA", "#N/A", "#VALUE!", "#DIV/0!"))
# need to fix this before hms conversion otherwise it switches to NA
master2018[42, 8] <- "9:38"
master2018 <- master2018 %>% 
  mutate(Time = strptime(.$Time, format = "%H:%M")) %>% # converts to POSIXlt
  mutate(Time = hms::as_hms(Time)) # gets rid of date part

# 2019 data
master2019 <- read_csv("data/dugout_master2019.csv",
                       na = c("", "NA", "#N/A", "#VALUE!", "#DIV/0!"))

# 2020 data
master2020 <- read_csv("data/dugout_master2020.csv",
                       na = c("", "NA", "#N/A", "#VALUE!", "#DIV/0!"))

# MAKE COLUMNS MATCH ####

# 2017 data
master2017 <- master2017 %>% 
  # add columns that are in the 2018 or 2019 data but not 2017
  add_column(Bottle2_temp_in = NA, Bottle2_temp_out = NA,
             Chl_total = NA, DIN_ug.N.L = NA, MC_ug.L = NA, d15N_bulk_POM = NA,
             d13C_bulk_POM = NA, ugN_bulk_POM = NA, ugC_bulk_POM = NA, 
             PercentN_bulk_POM = NA, PercentC_bulk_POM = NA, C_N_POM = NA,
             Rn_dpm.L = NA, Elevation_m = NA) %>%
  # order columns and rename all the columns with standard format
  # first word uppercase, subsequent words lowercase, separated by _
  # . is used to separate components of units with more than one component 
  select(Site_ID, Date, Time, Latitude = latitude, Longitude = longitude, Air_temp, 
         Cloud_perc = `Cloud (%)`, Wind_km.hr, Field_team, Secchi_m = Secchi.m, 
         Depth_m = Depth.m, Max_depth_m = Max_depth.m,
         DO_calibration_perc = `DO Calibration%`, Surface_temp = Surface_Temp, 
         Surface_DO_sat = Surface_DO.sat, Surface_DO_mg.L = Surface_DO.mg.L,
         Surface_cond = Surface_Cond, Surface_sal_ppt = Surface_Sal.ppt, 
         Surface_pH, Deep_temp = Deep_Temp, Deep_DO_sat = Deep_DO.sat, 
         Deep_DO_mg.L = Deep_DO.mg.L, Deep_cond = Deep_Cond, Deep_sal_ppt = 
         Deep_Sal.ppt, Deep_pH, TDS_mg.L = TDS.mg.L, YSI_atm, Core_length_cm = 
         `Core_length (cm)`, Sediment_depth, Bottle_temp_in = Bottle_Temp_In, 
         Bottle_temp_out, Bottle2_temp_in, Bottle2_temp_out, 
         Tows, Floating_chamber = `Floating_chamberY/N`, Chl_total,
         Chla, NH3_mg.N.L = NH3.mg.N.L, SRP_mg.P.L = SRP.mg.P.L, 
         Nitrate_Nitrite_ug.N.L = Nitrate_Nitrite.ug.N.L, DIN_ug.N.L, TP_mg.P.L = 
         TP.mg.P.L, TN_ug.N.L = TN.ug.N.L, NP_ratio, TN_TP, DIC_mg.L = DIC.mg.L, 
         DIC_uM = DIC.uM, DOC_mg.L = DOC.mg.L, DOC_uM = DOC.uM, SO4_mg.L = 
         SO4.mg.L, Alk_mg.L = Alk.mg.L, MC_ug.L, pCO2, CO2_uM = CO2.uM, 
         CO2_uM_error = CO2.uM.error, pCH4, CH4_uM = CH4.uM, CH4_uM_error = 
         CH4.uM.error, pN2O, N2O_nM = N2O.nM, N2O_nM_error = N2O.nM.error, 
         d15N_bulk:PercentC_bulk, Sediment_C_N = sediment_C_N, d15N_org:PercentC_org, 
         Sediment_C_N_org = `sediment_C_Norg`, d15N_bulk_POM:C_N_POM,
         d2H:Regime, Water_source = Water_Source, Residence_time = RT, 
         Water_class, d_excess:Inflow, Land_use = Landuse, Age_years = Age.years,
         NP_ratio2 = NP.ratio, B_F_max = b.f.max, B_F_min = b.f.min, Rn_dpm.L, 
         Elevation_m, Area_m2 = Area.m, Perimeter, Volume_m3 = Volume.m3, SI, 
         General_comments = `General Comments`) %>% 
  # calculate the columns missing columns that we can
  mutate(Date = lubridate::dmy(Date))
  # mutate(DIN_ug.N.L = (NH3_mg.N.L*1000) + Nitrate_Nitrite_ug.N.L)
  #   - mutate function not working because Nitrate_Nitrite_ug.N.L column is a 
  #     character column due to "<LOD" values
  
# 2018 data  
master2018 <- master2018 %>% 
  add_column(Core_length_cm = NA, Sediment_depth = NA, Bottle_temp_in = NA, 
             Bottle_temp_out = NA, Bottle2_temp_in = NA, Bottle2_temp_out = NA, 
             Tows = NA, Floating_chamber = NA, TN_TP = NA, SO4_mg.L =  NA, Alk_mg.L = NA, 
             d15N_bulk = NA, d13C_bulk = NA, mgN_bullk = NA, mgC_bulk = NA,
             PercentN_bulk = NA, PercentC_bulk = NA, Sediment_C_N = NA, 
             d15N_org = NA, d13_org = NA, mgN_org = NA, mgC_org = NA, PercentN_org = NA, 
             PercentC_org = NA, Sediment_C_N_org = NA, Regime = NA, d_excess = NA, 
             delI180 = NA, delI2H = NA, Inflow = NA, NP_ratio2 = NA, Perimeter = NA, 
             Volume_m3 = NA, SI = NA) %>% 
  select(Site_ID, Date, Time, Latitude = latitude, Longitude = longitude, 
         Air_temp, Cloud_perc = `Cloud (%)`, Wind_km.hr, Field_team, Secchi_m = Secchi.m, 
         Depth_m = Depth.m, Max_depth_m = Max_depth.m,
         DO_calibration_perc = `DO Calibration%`, Surface_temp = Surface_Temp, 
         Surface_DO_sat = Surface_DO.sat, Surface_DO_mg.L = Surface_DO.mg.L,
         Surface_cond = Surface_Cond, Surface_sal_ppt = Surface_Sal.ppt, Surface_pH, 
         Deep_temp = Deep_Temp, Deep_DO_sat = Deep_DO.sat, Deep_DO_mg.L = Deep_DO.mg.L, 
         Deep_cond = Deep_Cond, Deep_sal_ppt = Deep_Sal.ppt, Deep_pH, 
         TDS_mg.L = TDS.mg.L, YSI_atm, Core_length_cm, Sediment_depth, Bottle_temp_in, 
         Bottle_temp_out, Bottle2_temp_in, Bottle2_temp_out, Tows, Floating_chamber, 
         Chl_total, Chla, NH3_mg.N.L = NH3.mg.N.L, SRP_mg.P.L = SRP.mg.P.L, 
         Nitrate_Nitrite_ug.N.L = Nitrate_Nitrite.ug.N.L, DIN_ug.N.L = DIN.ug.N.L, 
         TP_mg.P.L = TP.mg.P.L, TN_ug.N.L = TN.ug.N.L, NP_ratio, TN_TP, DIC_mg.L = DIC.mg.L, 
         DIC_uM = DIC.uM, DOC_mg.L = DOC.mg.L, DOC_uM = DOC.uM, SO4_mg.L, Alk_mg.L, 
         MC_ug.L = MC.ug.L, pCO2, CO2_uM = CO2.uM, CO2_uM_error = CO2.uM.error, 
         pCH4, CH4_uM = CH4.uM, CH4_uM_error = CH4.uM.error, pN2O, N2O_nM = N2O.nM, 
         N2O_nM_error = N2O.nM.error, d15N_bulk, d13C_bulk, mgN_bullk, mgC_bulk,
         PercentN_bulk, PercentC_bulk, Sediment_C_N, d15N_org, d13_org, mgN_org, 
         mgC_org, PercentN_org, PercentC_org, Sediment_C_N_org, d15N_bulk_POM:C_N_POM, 
         d2H, d18O, EtoI, Regime, Water_source = `Water Source`, Residence_time = 
           Residence_Time, Water_class, d_excess, delI180, delI2H, Inflow, 
         Land_use = Landuse, Age_years = Age.years, NP_ratio2, B_F_max = b.f.max, 
         B_F_min = b.f.min, Rn_dpm.L = Rn.dpm.L, Elevation_m = elevation.m, 
         Area_m2 = Area.m2, Perimeter, Volume_m3, SI, General_comments = `General Comments`) %>% 
  mutate(Date = lubridate::dmy(Date))

# 2019 data
master2019 <- master2019 %>% 
  add_column(Bottle2_temp_in = NA, Bottle2_temp_out = NA, DIN_ug.N.L = NA, TN_TP = NA,
             SO4_mg.L = NA, Alk_mg.L = NA, MC_ug.L = NA, Sediment_C_N_org = NA, 
             d15N_bulk_POM = NA, d13C_bulk_POM = NA, ugN_bulk_POM = NA, ugC_bulk_POM = NA, 
             PercentN_bulk_POM = NA, PercentC_bulk_POM = NA, C_N_POM = NA, d_excess = NA, 
             delI180 = NA, delI2H = NA, Inflow = NA, Elevation_m = NA, Area_m2 = NA, 
             Perimeter = NA, Volume_m3 = NA, SI = NA) %>% 
  select(Site_ID = Site, Date, Time, Latitude = latitude, Longitude = longitude,
         Air_temp, Cloud_perc = `Cloud (%)`, Wind_km.hr, Field_team, Secchi_m = Secchi.m, 
         Depth_m = Depth.m, Max_depth_m = Max_depth.m,
         DO_calibration_perc = `DO Calibration%`, Surface_temp = Surface_Temp, 
         Surface_DO_sat = Surface_DO.sat, Surface_DO_mg.L = Surface_DO.mg.L,
         Surface_cond = Surface_Cond, Surface_sal_ppt = Surface_Sal.ppt, Surface_pH, 
         Deep_temp = Deep_Temp, Deep_DO_sat = Deep_DO.sat, Deep_DO_mg.L = Deep_DO.mg.L, 
         Deep_cond = Deep_Cond, Deep_sal_ppt = Deep_Sal.ppt, Deep_pH, TDS_mg.L = 
           TDS.mg.L, YSI_atm, Core_length_cm = `Core_length (cm)`, Sediment_depth, 
         Bottle_temp_in = Bottle_Temp_In, Bottle_temp_out, Bottle2_temp_in, Bottle2_temp_out, Tows, 
         Floating_chamber = `Floating_chamberY/N`, Chl_total,Chla, NH3_mg.N.L = NH3.mg.N.L, 
         SRP_mg.P.L = SRP.mg.P.L, Nitrate_Nitrite_ug.N.L = Nitrate_Nitrite.ug.N.L, 
         DIN_ug.N.L, TP_mg.P.L = TP.mg.P.L, TN_ug.N.L = TN.ug.N.L, NP_ratio, TN_TP, 
         DIC_mg.L = DIC.mg.L, DIC_uM = DIC.uM, DOC_mg.L = DOC.mg.L, DOC_uM = DOC.uM,
         SO4_mg.L, Alk_mg.L, MC_ug.L, pCO2, CO2_uM = CO2.uM, CO2_uM_error = CO2.uM.error, 
         pCH4, CH4_uM = CH4.uM, CH4_uM_error = CH4.uM.error, pN2O, N2O_nM = N2O.nM, 
         N2O_nM_error = N2O.nM.error, d15N_bulk:PercentC_bulk, Sediment_C_N = 
           sediment_C_N, d15N_org:PercentC_org, Sediment_C_N_org, d15N_bulk_POM:C_N_POM,
         d2H:Regime, Water_source = `Water Source`, Residence_time = Residence_Time, 
         Water_class, d_excess:Inflow, Land_use = Landuse, Age_years = Age.years,
         NP_ratio2 = NP.ratio, B_F_max = b.f.max, B_F_min = b.f.min, Rn_dpm.L = Rn.dpm.L,
         Elevation_m, Area_m2, Perimeter, Volume_m3, SI, General_comments = `General Comments`) %>% 
  mutate(Date = lubridate::dmy(Date))

# 2020 data
master2020 <- master2020 %>% 
  add_column(Field_team = NA, TDS_mg.L = NA, Core_length_cm = NA, Sediment_depth = 
               NA, Bottle_temp_in = NA, Bottle2_temp_in = NA, Tows = NA, 
             Floating_chamber = NA, Chl_total = NA, Chla = NA, NH3_mg.N.L = NA, 
             SRP_mg.P.L = NA, Nitrate_Nitrite_ug.N.L = NA, DIN_ug.N.L = NA, TP_mg.P.L = NA, 
             TN_ug.N.L = NA, NP_ratio = NA, TN_TP = NA, DIC_mg.L = NA, DIC_uM = NA, 
             DOC_mg.L = NA, DOC_uM = NA, SO4_mg.L = NA, Alk_mg.L = NA, MC_ug.L = NA, pCO2 = NA, 
             CO2_uM = NA, CO2_uM_error = NA, pCH4 = NA, CH4_uM = NA, CH4_uM_error = NA, 
             pN2O = NA, N2O_nM = NA, N2O_nM_error = NA, 
             d15N_bulk = NA, d13C_bulk = NA, mgN_bullk = NA, mgC_bulk = NA,
             PercentN_bulk = NA, PercentC_bulk = NA, Sediment_C_N = NA, 
             d15N_org = NA, d13_org = NA, mgN_org = NA, mgC_org = NA, PercentN_org = NA, 
             PercentC_org = NA, Sediment_C_N_org = NA, d15N_bulk_POM = NA, d13C_bulk_POM = NA, ugN_bulk_POM = NA, ugC_bulk_POM = NA, 
             PercentN_bulk_POM = NA, PercentC_bulk_POM = NA, C_N_POM = NA, d2H = NA, 
             d18O = NA, EtoI = NA, Regime = NA, Water_source = NA, Residence_time = NA, 
             Water_class = NA, d_excess = NA, delI180 = NA, delI2H = NA, Inflow = NA, 
             Land_use = NA, Age_years = NA, NP_ratio2 = NA, B_F_max = NA, B_F_min = NA, 
             Rn_dpm.L = NA, Elevation_m = NA, Area_m2 = NA, Perimeter = NA, Volume_m3 = NA, 
             SI = NA, General_comments = NA) %>% 
  select(Site_ID:Time, Latitude = latitude, Longitude = longitude, Air_temp, 
         Cloud_perc = `Cloud (%)`, Wind_km.hr, Field_team, Secchi_m = Secchi.m, 
         Depth_m = Depth.m, Max_depth_m = `Sample_depth (m)`, DO_calibration_perc = 
           `DO Calibration%`, Surface_temp = Surface_Temp, 
         Surface_DO_sat = Surface_DO.sat, Surface_DO_mg.L = Surface_DO.mg.L,
         Surface_cond = Surface_Cond, Surface_sal_ppt = Surface_Sal.ppt, Surface_pH, 
         Deep_temp = Deep_Temp, Deep_DO_sat = Deep_DO.sat, 
         Deep_DO_mg.L = Deep_DO.mg.L, Deep_cond = Deep_Cond, Deep_sal_ppt = 
           Deep_Sal.ppt, Deep_pH, TDS_mg.L, YSI_atm, Core_length_cm, Sediment_depth, 
         Bottle_temp_in, Bottle_temp_out = `Shakey Bottle 1 temp out`, Bottle2_temp_in, 
         Bottle2_temp_out = `Shakey Bottle 2 temp out`, Tows, Floating_chamber:General_comments) %>% 
  mutate(Date = lubridate::dmy(Date))

# ADDING IN DATA ####

## 2020 ##

# read in TIC TOC and water chem data for 2020
carbon2020 <- read.csv("data/carbon_2020.csv", 
                       na = c("", "NA", "#N/A", "#VALUE!", "#DIV/0!"))
waterchem2020 <- read.csv("data/water_chem_2020.csv", 
                          na = c("", "NA", "#N/A", "#VALUE!", "#DIV/0!"))

# prep carbon data for merging 
carbon2020 <- carbon2020 %>% 
  separate(col = Sample.ID, into = c("Site_ID", "Date"), sep = "/") %>% 
  add_column(Year = "2020") %>% 
  mutate(Sample = str_sub(Site_ID, 1, 1),  
         Site_ID = str_sub(Site_ID, 2, nchar(Site_ID)),
         Month = str_extract(Date, "[aA-zZ]+"), # pull out letters from Date
         Day = str_extract(Date, "[0-9]+")) %>% # pull out numbers from Date
  # if Day has only 1 character, add a 0 in front so lubridate understands
  mutate(Day = ifelse(str_length(Day) == 1, paste0("0", Day), Day)) %>% 
  unite("Date", Year, Day, Month, sep = "-") %>% 
  mutate(Date = lubridate::ydm(Date)) %>% 
  # make a new column to indicate if samples were labeled "deep"
  separate(Site_ID, c("Site_ID", "Deep"), sep = "-") %>% 
  rename(TIC_PPM_mg.L.C = TIC..PPM.as.mg.L.C., 
         TOC_PPM_mg.L.C = TOC..PPM.as.mg.L.C.)

# prep waterchem data
waterchem2020 <- waterchem2020 %>% 
  select(Sample:Nitrate.Nitrite..ug.N.L.) %>% 
  drop_na() %>% 
  mutate(Site_ID = str_sub(Sample, 2, nchar(Sample)),
         Sample = str_sub(Sample, 1, 1)) %>% 
  separate(Site_ID, c("Site_ID", "Deep"), sep = "-") %>% 
  rename(TN_ug.N.L = TN..ug.N.L., TP_mg.P.L = TP..mg.P.L., 
         NH3_mg.N.L = Ammonia..mg.NH3.N.L., SRP_mg.P.L = SRP..mg.P.L., 
         Nitrate_Nitrite_ug.N.L = Nitrate.Nitrite..ug.N.L.)

# join waterchem2020 to carbon2020
carbon_waterchem2020 <- full_join(carbon2020, waterchem2020) %>% 
  select(-Sample) %>% 
  arrange(Site_ID, Date)

# differences between waterchem/carbon & master2020 files
diff1 <- setdiff(carbon_waterchem2020[,c(1,5)], 
                 select(master2020, Site_ID, Date) %>% 
                   mutate(Date = lubridate::dmy(Date)))

diff2 <- setdiff(select(master2020, Site_ID, Date) %>% 
                   mutate(Date = lubridate::dmy(Date)),
                 carbon_waterchem2020[,c(1,5)])

# need to merge 2020 data #


## 2017 ##

# read in chl total data from 2017
chl_total2017 <- read.csv("data/chl_2017.csv", 
                          na = c("", "NA", "#N/A", "#VALUE!", "#DIV/0!"))

# join 2017 chl total with master2017 (?)
# chl data has 2 runs per sample? do we average them? even so, 2 extra samples?
master2017 <- master2017 %>%
  full_join(., select(chl_total2017, Site_ID, Chla = ChlA.ug.L,
                      Chl_total = ChlTotal.ug.L), by = c("Site_ID"))



# MATCH COLUMN TYPES ####

# only chr columns should be Site_ID, Field_team, Floating_chamber, Regime, 
# Water_source, Water_class, and Land_use #
# Date should be Date, Time should be 'hms' num, everything else should be num #

# fix chr columns in 2017 --- NEED TO CONVERT TO 10% LOD; ALSO "NV"?
master2017 <- master2017 %>% 
  mutate(SRP_mg.P.L = as.numeric(SRP_mg.P.L), 
         Nitrate_Nitrite_ug.N.L = as.numeric(Nitrate_Nitrite_ug.N.L), #
         SO4_mg.L = as.numeric(SO4_mg.L)) 
# Age_years = as.numeric(Age_years))  I'm thinking we make Age_years a character column for simplicity...

# fix latitude in 2020 -- need to remove all extra spaces (before, after, and by the decimal)
master2020 <- master2020 %>% 
  mutate(Latitude = str_replace_all(Latitude, fixed(" "), "")) %>% # remove internal spaces
  mutate(Latitude = as.numeric(str_trim(Latitude))) # remove spaces from before or after value
master2020$Latitude

## Check Cloud % column for Non-numeric Values ## 
str(master2017$Cloud_perc) # numeric (with decimals)
str(master2018$Cloud_perc) # chr, has % 
str(master2019$Cloud_perc) # chr, has %
str(master2020$Cloud_perc) # numeric

# fix cloud % in 2018
master2018 <- master2018 %>% 
  mutate(Cloud_perc = as.numeric(str_replace(Cloud_perc, "%", "")))
# fix cloud % in 2019
master2019 <- master2019 %>% 
  mutate(Cloud_perc = as.numeric(str_replace(Cloud_perc, "%", "")))

## Fix Time in 2020 ##
master2020$Time
master2020 <- master2020 %>% 
  mutate(Time = str_replace(.$Time, "~", "")) %>% 
  mutate(Time = str_replace(.$Time, "AM", "")) %>% 
  mutate(Time = str_replace(.$Time, "PM", "")) 
master2020[45, 3] <- "13:30"

master2020 <- master2020 %>% 
  mutate(Time = strptime(.$Time, format = "%H:%M")) %>% # converts to POSIXlt
  mutate(Time = hms::as_hms(Time)) # gets rid of date part

## Also need to calculate 10% LOD for 2017 data ##

## Can then use mutate to calculate DIN and TN_TP ##

## Need to bind_rows to finish ##

# WORK AREA #===================================================================

# DIN_ug.N.L = (NH3_mg.N.L*1000)+Nitrate_Nitrite_ug.N.L
# TN_TP = (TN.ug.N.L/1000) / TP.mg.P.L

