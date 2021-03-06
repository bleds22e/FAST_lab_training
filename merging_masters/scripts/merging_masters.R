###################################
#   MERGE MASTER FILES 2017-2020  # 
# Jess Lerminiaux & Ellen Bledsoe #
#          Summer 2021            #
###################################

# PACAKGES & WD #---------------------------------------------------------------
library(tidyverse)
library(hms)
library(stringr)

# set working directory
setwd("./merging_masters/")

# DATA #------------------------------------------------------------------------

# 2017 data
master2017 <- read_csv("data/dugout_master2017.csv",
                       na = c("", "NA", "#N/A", "#VALUE!", "#DIV/0!"))
# make some quick fixes to the dataframe (from dugouts_2017_complete.R)
master2017 <- master2017[-(103:104),] # remove last two columns of NAs
master2017[5, 4] <- "24-Jul-17" # reassign date value that includes year

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

# MAKE COLUMNS MATCH #----------------------------------------------------------

# NOTE--Column naming general format:
# first word uppercase, subsequent words lowercase, separated by _
# . is used to separate components of units with more than one component 

# 2017 data
master2017 <- master2017 %>% 
  # add columns that are in the 2018 or 2019 data but not 2017
  add_column(Bottle2_temp_in = NA, Bottle2_temp_out = NA, Chl_total = NA, 
             Deep_NH3_mg.N.L = NA, Deep_SRP_mg.P.L = NA, Deep_Nitrate_Nitrite_ug.N.L 
             = NA, Surface_DIN_ug.N.L = NA, 
             Deep_TP_mg.P.L = NA, Deep_TN_ug.N.L = NA, Deep_DIC_mg.L = NA, 
             Deep_DIC_uM = NA, Deep_DOC_mg.L = NA, Deep_DOC_uM = NA, MC_ug.L = NA, 
             d15N_bulk_POM = NA, d13C_bulk_POM = NA, ugN_bulk_POM = NA, 
             ugC_bulk_POM = NA, PercentN_bulk_POM = NA, PercentC_bulk_POM = NA, 
             C_N_POM = NA, Rn_dpm.L = NA, Elevation_m = NA, Chloride_mg.L = NA) %>%
  # order columns and rename all the columns with standard format
  select(Site_ID, Date, Time, Latitude = latitude, Longitude = longitude, 
         Air_temp, Cloud_perc = `Cloud (%)`, Wind_km.hr, Field_team, Secchi_m = 
         Secchi.m, Depth_m = Depth.m, Max_depth_m = Max_depth.m,
         DO_calibration_perc = `DO Calibration%`, Surface_temp = Surface_Temp, 
         Surface_DO_sat = Surface_DO.sat, Surface_DO_mg.L = Surface_DO.mg.L,
         Surface_cond = Surface_Cond, Surface_sal_ppt = Surface_Sal.ppt, 
         Surface_pH, Deep_temp = Deep_Temp, Deep_DO_sat = Deep_DO.sat, 
         Deep_DO_mg.L = Deep_DO.mg.L, Deep_cond = Deep_Cond, Deep_sal_ppt = 
         Deep_Sal.ppt, Deep_pH, TDS_mg.L = TDS.mg.L, YSI_atm, Core_length_cm = 
         `Core_length (cm)`, Sediment_depth, Bottle1_temp_in = Bottle_Temp_In, 
         Bottle1_temp_out = Bottle_temp_out, Bottle2_temp_in, Bottle2_temp_out, Tows, 
         Floating_chamber = `Floating_chamberY/N`, Chl_total, Chla, 
         Surface_NH3_mg.N.L = NH3.mg.N.L, Surface_SRP_mg.P.L = SRP.mg.P.L, 
         Surface_Nitrate_Nitrite_ug.N.L = Nitrate_Nitrite.ug.N.L, 
         Surface_TP_mg.P.L = TP.mg.P.L, Surface_TN_ug.N.L = TN.ug.N.L,  
         Surface_DIC_mg.L = DIC.mg.L,  Surface_DIC_uM = DIC.uM, 
         Surface_DOC_mg.L = DOC.mg.L, Surface_DOC_uM = DOC.uM, Surface_DIN_ug.N.L,
         Surface_NP_ratio = NP_ratio, Surface_TN_TP = TN_TP, Deep_NH3_mg.N.L, 
         Deep_SRP_mg.P.L, Deep_Nitrate_Nitrite_ug.N.L, Deep_TP_mg.P.L, 
         Deep_TN_ug.N.L, Deep_DIC_mg.L, Deep_DIC_uM, Deep_DOC_mg.L, 
         Deep_DOC_uM,  SO4_mg.L = SO4.mg.L, Alk_mg.L = Alk.mg.L, Chloride_mg.L,
         MC_ug.L, pCO2, CO2_uM = CO2.uM, CO2_uM_error = CO2.uM.error, pCH4, 
         CH4_uM = CH4.uM, CH4_uM_error = CH4.uM.error, pN2O, N2O_nM = N2O.nM, 
         N2O_nM_error = N2O.nM.error, d15N_bulk:PercentC_bulk, Sediment_C_N = 
         sediment_C_N, d15N_org:PercentC_org, Sediment_C_N_org = `sediment_C_Norg`, 
         d15N_bulk_POM:C_N_POM, d2H:Regime, Water_source = Water_Source, 
         Residence_time = RT, Water_class, d_excess:Inflow, Land_use = Landuse, 
         Age_years = Age.years, B_F_max = b.f.max, 
         B_F_min = b.f.min, Rn_dpm.L, Elevation_m, Area_m2 = Area.m, Perimeter_m = Perimeter, 
         Volume_m3 = Volume.m3, SI, General_comments = `General Comments`) %>% 
  # calculate the columns missing columns that we can
  mutate(Date = lubridate::dmy(Date),
         Site_ID = ifelse(is.na(str_extract(Site_ID, "[aA-zZ]+")),
                          paste0(Site_ID, 'A'), Site_ID))

# 2018 data  
master2018 <- master2018 %>% 
  add_column(Core_length_cm = NA, Sediment_depth = NA, Bottle1_temp_in = NA, 
             Bottle1_temp_out = NA, Bottle2_temp_in = NA, Bottle2_temp_out = NA, 
             Tows = NA, Floating_chamber = NA, Deep_NH3_mg.N.L = NA, Deep_SRP_mg.P.L
             = NA, Deep_Nitrate_Nitrite_ug.N.L = NA, Deep_TP_mg.P.L = NA, 
             Deep_TN_ug.N.L = NA, Surface_TN_TP = NA, Deep_DIC_mg.L = NA, Deep_DIC_uM = NA, 
             Deep_DOC_mg.L = NA, Deep_DOC_uM = NA, SO4_mg.L =  NA, Alk_mg.L = NA, 
             d15N_bulk = NA, d13C_bulk = NA, mgN_bulk = NA, mgC_bulk = NA,
             PercentN_bulk = NA, PercentC_bulk = NA, Sediment_C_N = NA, 
             d15N_org = NA, d13C_org = NA, mgN_org = NA, mgC_org = NA, PercentN_org
             = NA, PercentC_org = NA, Sediment_C_N_org = NA, Regime = NA, d_excess
             = NA, delI18O = NA, delI2H = NA, Inflow = NA, Perimeter = NA, 
             Volume_m3 = NA, SI = NA, DIN_ug.N.L = NA, Chloride_mg.L = NA) %>% 
  select(Site_ID, Date, Time, Latitude = latitude, Longitude = longitude, 
         Air_temp, Cloud_perc = `Cloud (%)`, Wind_km.hr, Field_team, Secchi_m = 
         Secchi.m, Depth_m = Depth.m, Max_depth_m = Max_depth.m,
         DO_calibration_perc = `DO Calibration%`, Surface_temp = Surface_Temp, 
         Surface_DO_sat = Surface_DO.sat, Surface_DO_mg.L = Surface_DO.mg.L,
         Surface_cond = Surface_Cond, Surface_sal_ppt = Surface_Sal.ppt, 
         Surface_pH, Deep_temp = Deep_Temp, Deep_DO_sat = Deep_DO.sat, Deep_DO_mg.L
         = Deep_DO.mg.L, Deep_cond = Deep_Cond, Deep_sal_ppt = Deep_Sal.ppt, 
         Deep_pH, TDS_mg.L = TDS.mg.L, YSI_atm, Core_length_cm, Sediment_depth, 
         Bottle1_temp_in, Bottle1_temp_out, Bottle2_temp_in, Bottle2_temp_out, Tows,
         Floating_chamber, Chl_total, Chla, Surface_NH3_mg.N.L = NH3.mg.N.L, 
         Surface_SRP_mg.P.L = SRP.mg.P.L, Surface_Nitrate_Nitrite_ug.N.L = 
         Nitrate_Nitrite.ug.N.L, Surface_TP_mg.P.L = TP.mg.P.L, Surface_TN_ug.N.L
         = TN.ug.N.L, Surface_DIC_mg.L = DIC.mg.L,  Surface_DIC_uM = DIC.uM, 
         Surface_DOC_mg.L = DOC.mg.L, Surface_DOC_uM = DOC.uM, Deep_NH3_mg.N.L, 
         Deep_SRP_mg.P.L, Deep_Nitrate_Nitrite_ug.N.L, Deep_TP_mg.P.L, 
         Deep_TN_ug.N.L, Deep_DIC_mg.L, Deep_DIC_uM, Surface_DIN_ug.N.L = DIN.ug.N.L, Deep_DOC_mg.L, 
         Deep_DOC_uM, Surface_NP_ratio = NP_ratio, Surface_TN_TP, SO4_mg.L, Alk_mg.L, 
         Chloride_mg.L, MC_ug.L = MC.ug.L, pCO2, CO2_uM = CO2.uM, CO2_uM_error = CO2.uM.error, 
         pCH4, CH4_uM = CH4.uM, CH4_uM_error = CH4.uM.error, pN2O, N2O_nM = N2O.nM, 
         N2O_nM_error = N2O.nM.error, d15N_bulk, d13C_bulk, mgN_bulk, mgC_bulk,
         PercentN_bulk, PercentC_bulk, Sediment_C_N, d15N_org, d13C_org, mgN_org, 
         mgC_org, PercentN_org, PercentC_org, Sediment_C_N_org, d15N_bulk_POM:C_N_POM, 
         d2H, d18O, EtoI, Regime, Water_source = `Water Source`, Residence_time = 
         Residence_Time, Water_class, d_excess, delI18O, delI2H, Inflow, Land_use
         = Landuse, Age_years = Age.years, B_F_max = b.f.max, B_F_min
         = b.f.min, Rn_dpm.L = Rn.dpm.L, Elevation_m = elevation.m, Area_m2 = 
         Area.m2, Perimeter_m = Perimeter, Volume_m3, SI, 
         General_comments = `General Comments`) %>% 
  mutate(Date = lubridate::dmy(Date),
         Site_ID = ifelse(is.na(str_extract(Site_ID, "[aA-zZ]+")),
                          paste0(Site_ID, 'A'), Site_ID))

# 2019 data
master2019 <- master2019 %>% 
  add_column(Bottle2_temp_in = NA, Bottle2_temp_out = NA, Deep_NH3_mg.N.L = NA, 
             Deep_SRP_mg.P.L = NA, Deep_Nitrate_Nitrite_ug.N.L = NA, Surface_DIN_ug.N.L = NA, 
             Deep_TP_mg.P.L = NA, Deep_TN_ug.N.L = NA, Surface_TN_TP = NA,
             Deep_DIC_mg.L = NA, Deep_DIC_uM = NA, Deep_DOC_mg.L = NA, Deep_DOC_uM = NA, 
             SO4_mg.L = NA, Alk_mg.L = NA, MC_ug.L = NA, Sediment_C_N_org = NA, 
             d15N_bulk_POM = NA, d13C_bulk_POM = NA, ugN_bulk_POM = NA, ugC_bulk_POM = NA, 
             PercentN_bulk_POM = NA, PercentC_bulk_POM = NA, C_N_POM = NA, d_excess = NA, 
             delI18O = NA, delI2H = NA, Inflow = NA, Elevation_m = NA, Area_m2 = NA, 
             Perimeter = NA, Volume_m3 = NA, SI = NA, Chloride_mg.L = NA) %>% 
  select(Site_ID = Site, Date, Time, Latitude = latitude, Longitude = longitude,
         Air_temp, Cloud_perc = `Cloud (%)`, Wind_km.hr, Field_team, Secchi_m = 
         Secchi.m, Depth_m = Depth.m, Max_depth_m = Max_depth.m,
         DO_calibration_perc = `DO Calibration%`, Surface_temp = Surface_Temp, 
         Surface_DO_sat = Surface_DO.sat, Surface_DO_mg.L = Surface_DO.mg.L,
         Surface_cond = Surface_Cond, Surface_sal_ppt = Surface_Sal.ppt, Surface_pH, 
         Deep_temp = Deep_Temp, Deep_DO_sat = Deep_DO.sat, Deep_DO_mg.L = Deep_DO.mg.L, 
         Deep_cond = Deep_Cond, Deep_sal_ppt = Deep_Sal.ppt, Deep_pH, TDS_mg.L = 
         TDS.mg.L, YSI_atm, Core_length_cm = `Core_length (cm)`, Sediment_depth, 
         Bottle1_temp_in = Bottle_Temp_In, Bottle1_temp_out = Bottle_temp_out, Bottle2_temp_in, 
         Bottle2_temp_out, Tows, Floating_chamber = `Floating_chamberY/N`, Chl_total, 
         Chla, Surface_NH3_mg.N.L = NH3.mg.N.L, Surface_SRP_mg.P.L = SRP.mg.P.L, 
         Surface_Nitrate_Nitrite_ug.N.L = Nitrate_Nitrite.ug.N.L, 
         Surface_TP_mg.P.L = TP.mg.P.L, Surface_TN_ug.N.L = TN.ug.N.L,  
         Surface_DIC_mg.L = DIC.mg.L,  Surface_DIC_uM = DIC.uM, 
         Surface_DOC_mg.L = DOC.mg.L, Surface_DOC_uM = DOC.uM, Deep_NH3_mg.N.L, 
         Deep_SRP_mg.P.L, Deep_Nitrate_Nitrite_ug.N.L, Deep_TP_mg.P.L, 
         Deep_TN_ug.N.L, Deep_DIC_mg.L, Deep_DIC_uM, Surface_DIN_ug.N.L, Deep_DOC_mg.L, 
         Deep_DOC_uM, Surface_NP_ratio = NP_ratio, Surface_TN_TP, SO4_mg.L, Alk_mg.L, 
         Chloride_mg.L, MC_ug.L, pCO2, CO2_uM = CO2.uM, CO2_uM_error = CO2.uM.error, 
         pCH4, CH4_uM = CH4.uM, CH4_uM_error
         = CH4.uM.error, pN2O, N2O_nM = N2O.nM, N2O_nM_error = N2O.nM.error, 
         d15N_bulk:PercentC_bulk, Sediment_C_N = sediment_C_N, d15N_org:PercentC_org,
         Sediment_C_N_org, d15N_bulk_POM:C_N_POM, d2H:Regime, Water_source = 
         `Water Source`, Residence_time = Residence_Time, Water_class, d_excess:Inflow,
         Land_use = Landuse, Age_years = Age.years, B_F_max
         = b.f.max, B_F_min = b.f.min, Rn_dpm.L = Rn.dpm.L, Elevation_m, Area_m2, 
         Perimeter_m = Perimeter, Volume_m3, SI, General_comments = `General Comments`) %>% 
  mutate(Date = lubridate::dmy(Date),
         Site_ID = ifelse(is.na(str_extract(Site_ID, "[aA-zZ]+")),
                          paste0(Site_ID, 'A'), Site_ID))

# 2020 data
master2020 <- master2020 %>% 
  add_column(Field_team = NA, TDS_mg.L = NA, Core_length_cm = NA, Sediment_depth = 
             NA, Bottle1_temp_in = NA, Bottle2_temp_in = NA, Tows = NA, 
             Floating_chamber = NA, Chl_total = NA, Chla = NA, Surface_DIC_uM = NA, 
             Surface_DOC_uM = NA, Deep_DIC_uM = NA, Surface_DIN_ug.N.L
             = NA, Deep_DOC_uM = NA, Surface_NP_ratio = NA, Surface_TN_TP = NA, 
             SO4_mg.L = NA, Alk_mg.L = NA, Chloride_mg.L = NA, MC_ug.L = NA, pCO2 = NA, CO2_uM = NA,
             CO2_uM_error = NA, pCH4 = NA, CH4_uM = NA, CH4_uM_error = NA, pN2O 
             = NA, N2O_nM = NA, N2O_nM_error = NA, d15N_bulk = NA, d13C_bulk = NA,
             mgN_bulk = NA, mgC_bulk = NA,PercentN_bulk = NA, PercentC_bulk = NA,
             Sediment_C_N = NA, d15N_org = NA, d13C_org = NA, mgN_org = NA, mgC_org
             = NA, PercentN_org = NA, PercentC_org = NA, Sediment_C_N_org = NA, 
             d15N_bulk_POM = NA, d13C_bulk_POM = NA, ugN_bulk_POM = NA, ugC_bulk_POM 
             = NA, PercentN_bulk_POM = NA, PercentC_bulk_POM = NA, C_N_POM = NA, 
             d2H = NA, d18O = NA, EtoI = NA, Regime = NA, Water_source = NA, 
             Residence_time = NA, Water_class = NA, d_excess = NA, delI18O = NA, 
             delI2H = NA, Inflow = NA, Land_use = NA, Age_years = NA, 
             B_F_max = NA, B_F_min = NA, Rn_dpm.L = NA, Elevation_m = NA, Area_m2
             = NA, Perimeter_m = NA, Volume_m3 = NA, SI = NA, General_comments = NA) %>% 
  select(Site_ID:Time, Latitude = latitude, Longitude = longitude, Air_temp, 
         Cloud_perc = `Cloud (%)`, Wind_km.hr, Field_team, Secchi_m = Secchi.m, 
         Depth_m = Depth.m, Max_depth_m = `Sample_depth (m)`, DO_calibration_perc = 
         `DO Calibration%`, Surface_temp = Surface_Temp, Surface_DO_sat = 
         Surface_DO.sat, Surface_DO_mg.L = Surface_DO.mg.L,Surface_cond = 
         Surface_Cond, Surface_sal_ppt = Surface_Sal.ppt, Surface_pH, Deep_temp 
         = Deep_Temp, Deep_DO_sat = Deep_DO.sat, Deep_DO_mg.L = Deep_DO.mg.L, 
         Deep_cond = Deep_Cond, Deep_sal_ppt = Deep_Sal.ppt, Deep_pH, TDS_mg.L, 
         YSI_atm, Core_length_cm, Sediment_depth, Bottle1_temp_in, Bottle1_temp_out
         = `Shakey Bottle 1 temp out`, Bottle2_temp_in, Bottle2_temp_out = 
         `Shakey Bottle 2 temp out`, Tows, Floating_chamber:General_comments) %>% 
  mutate(Date = lubridate::dmy(Date),
         Site_ID = ifelse(is.na(str_extract(Site_ID, "[aA-zZ]+")),
                          paste0(Site_ID, 'A'), Site_ID))

# ADDING IN DATA #--------------------------------------------------------------

# 2017 ####

# Chl data #
# read in chl total data from 2017
chl_total2017 <- read.csv("data/chl_2017.csv", 
                          na = c("", "NA", "#N/A", "#VALUE!", "#DIV/0!")) %>% 
  group_by(Site_ID) %>% 
  arrange(Site_ID) %>% 
  summarise(across(ChlA.ug.L:ChlTotal.ug.L, mean)) %>% 
  filter(Site_ID != '54A?') %>% 
  mutate(Site_ID = ifelse(is.na(str_extract(Site_ID, "[aA-zZ]+")),
                          paste0(Site_ID, 'A'), Site_ID)) %>% 
  select(Site_ID, Chl_total = ChlTotal.ug.L)

# POM data # 
pom_2017 <- read_csv("data/POM_2017.csv") %>% 
  rename(Site_ID = Sample, d15N_bulk_POM = d15NAIR, d13C_bulk_POM = d13CVPDB,
         ugN_bulk_POM = mgN, ugC_bulk_POM = mgC, PercentN_bulk_POM = `%N`,
         PercentC_bulk_POM = `%C`, C_N_POM = `C/N`) %>% 
  filter(!is.na(Site_ID)) %>% 
  mutate(Site_ID = replace(Site_ID, Site_ID == 'CD July 12', '14a'),
         Site_ID = replace(Site_ID, Site_ID == '71', '7I')) %>%
  mutate(Site_ID = toupper(Site_ID),
         Site_ID = ifelse(is.na(str_extract(Site_ID, "[aA-zZ]+")),
                          paste0(Site_ID, 'A'), Site_ID)) %>% 
  filter(Site_ID != '8AC', Site_ID != '8CE', 
         !str_detect(Site_ID, "SD"), !str_detect(Site_ID, "CD")) %>% 
  select(Site_ID, d15N_bulk_POM, d13C_bulk_POM, ugN_bulk_POM, ugC_bulk_POM,
         PercentN_bulk_POM, PercentC_bulk_POM, C_N_POM) %>% 
  group_by(Site_ID) %>% 
  summarise(across(.fns = mean))

# MC data # 
mc_2017 <- read_csv("data/MC_2017.csv") %>% 
  rename(Site_ID = Name, MC_ug.L = `[MC] ppb`) %>% 
  filter(MC_ug.L != ">2", MC_ug.L != "CV % Off", MC_ug.L != "CV % off",
         !str_detect(Site_ID, "SD"),
         !str_detect(Site_ID, "CD")) %>% 
  mutate(MC_ug.L = replace(MC_ug.L, MC_ug.L == '<.2', 0.02),
         Site_ID = toupper(str_sub(Site_ID, 2, nchar(Site_ID))),
         Site_ID = replace(Site_ID, Site_ID == '71', '7I'),
         Site_ID = replace(Site_ID, Site_ID == '65B', '56B'),
         Site_ID = ifelse(is.na(str_extract(Site_ID, "[aA-zZ]+")),
                          paste0(Site_ID, 'A'), Site_ID)) %>% 
  group_by(Site_ID) %>% 
  summarise(MC_ug.L = mean(as.numeric(MC_ug.L), na.rm = TRUE))

# Elevation # 
elevation_2017 <- read_csv("data/elevation_2017.csv") %>% 
  select(Site_ID, Elevation_m = Elevation.m) %>% 
  mutate(Site_ID = ifelse(is.na(str_extract(Site_ID, "[aA-zZ]+")),
                          paste0(Site_ID, 'A'), Site_ID))

# join 2017 data with master2017
master2017 <- left_join(select(master2017, -Chl_total, -MC_ug.L, -Elevation_m,
                               -d15N_bulk_POM:-C_N_POM), 
                        chl_total2017) %>% 
  left_join(mc_2017) %>% 
  left_join(elevation_2017) %>% 
  left_join(pom_2017) %>% 
  select(Site_ID:Floating_chamber, Chl_total, Chla:Chloride_mg.L, MC_ug.L, 
         pCO2:Sediment_C_N_org, d15N_bulk_POM:C_N_POM, d2H:Rn_dpm.L,
         Elevation_m, Area_m2:General_comments)

# 2018 ####

# shaky bottles
sb_2018 <- read_csv("data/shakeybottle_2018.csv") %>% 
  mutate(Date = lubridate::dmy(Date),
         Site_ID = ifelse(is.na(str_extract(Site_ID, "[aA-zZ]+")),
                          paste0(Site_ID, 'A'), Site_ID)) %>% 
  filter(Sample == '1A' | Sample == '2A') %>% # checked NAs, they are fine
  select(Site_ID:Temp_out) %>% 
  pivot_longer(Temp_in:Temp_out, names_to = "temp_type", values_to = "temp") %>% 
  pivot_wider(names_from = c(temp_type, Sample), values_from = temp) %>% 
  rename(Bottle1_temp_in = Temp_in_1A, Bottle1_temp_out = Temp_out_1A,
         Bottle2_temp_in = Temp_in_2A, Bottle2_temp_out = Temp_out_2A)

# Chlorida, Alk, and SO4
alk_etc_2018 <- read_csv("data/cl_alk_so4_2018.csv") %>% 
  select(Site_ID = SampleID, Alk_mg.L = `Alkalinity (mg/L)`, 
         Chloride_mg.L = `Chloride (mg/L)`, SO4_mg.L = `SO4 (mg/L)`) %>% 
  # separate into only 2 columns so hours and date go into one column
  separate(Site_ID, c("Site_ID", "Date"), "-", extra = "merge") %>% 
  # separate the Date column into hours and dates, filling hours with NAs if empty
  separate(Date, c("Hours", "Date"), "-", fill = "left") %>% 
  mutate(Year = 2018,
         Month = str_extract(Date, "[aA-zZ]+"), # pull out letters from Date
         Day = str_extract(Date, "[0-9]+")) %>% # pull out numbers from Date
  # if Day has only 1 character, add a 0 in front so lubridate understands
  mutate(Day = ifelse(str_length(Day) == 1, paste0("0", Day), Day)) %>% 
  unite("Date", Day, Month, Year, sep = "-") %>% 
  mutate(SO4_mg.L = as.numeric(SO4_mg.L),   ### should maybe be 10% of detection limit...
         Date = lubridate::dmy(Date),
         Site_ID = replace(Site_ID, Site_ID == '5A', '56A'),
         Site_ID = replace(Site_ID, Site_ID == '66', '66C'),
         # if Site_ID is just a number (no letters), add the letter A
         Site_ID = ifelse(is.na(str_extract(Site_ID, "[aA-zZ]+")),
                          paste0(Site_ID, 'A'), Site_ID)) %>% 
  # remove sites that start with P and sites with hours 
  filter(str_sub(Site_ID, 1, 1) != "P", is.na(Hours)) %>% 
  select(-Hours)

# tows 
tows_2018 <- read_csv("data/tows_2018.csv", na = 'na') %>% 
  rename(Site_ID = `Site ID`) %>% 
  separate(Site_ID, c("Site_ID", "Hours"), sep = " ", fill = "right") %>% 
  filter(is.na(Hours)) %>% 
  mutate(Date = lubridate::dmy(Date),
         Site_ID = ifelse(is.na(str_extract(Site_ID, "[aA-zZ]+")),
                          paste0(Site_ID, 'A'), Site_ID)) %>% 
  select(-Hours)

# volume and perimeter
vol_per_2018 <- read_csv("data/vol_per_2018.csv") %>% 
  rename(Volume_m3 = Volume.m3, Perimeter_m = Perimeter.m) %>% 
  mutate(Date = lubridate::dmy(Date),
         Site_ID = ifelse(is.na(str_extract(Site_ID, "[aA-zZ]+")),
                          paste0(Site_ID, 'A'), Site_ID))
  
# float chambers
float_2018 <- read_csv("data/floatingchamber_2018.csv") %>% 
  select(Site_ID = 'Dugout ID', Date) %>% 
  mutate(Date = lubridate::dmy(Date),
         Site_ID = ifelse(is.na(str_extract(Site_ID, "[aA-zZ]+")),
                          paste0(Site_ID, 'A'), Site_ID))

# merge into 2018
master2018 <- left_join(select(master2018, 
                               -Bottle1_temp_in:-Bottle2_temp_out, 
                               -SO4_mg.L:-Chloride_mg.L,
                               -Tows, -Volume_m3, -Perimeter_m),
                        sb_2018) %>% 
  left_join(alk_etc_2018) %>% 
  left_join(tows_2018) %>% 
  left_join(vol_per_2018) %>% 
  select(Site_ID:Sediment_depth, Bottle1_temp_in:Bottle2_temp_out, Tows,
         Floating_chamber:Surface_TN_TP, SO4_mg.L, Alk_mg.L, Chloride_mg.L,
         MC_ug.L:Area_m2, Perimeter_m, Volume_m3, SI:General_comments) %>% 
  mutate(Floating_chamber = ifelse(Site_ID %in% as.vector(float_2018$Site_ID) & 
                                     Date %in% as.vector(float_2018$Date),
                                   'Y', 'N'))

# 2019 ####

# POM 
pom_2019 <- read_csv("data/POM_2019.csv") %>% 
  select(Site_ID = Sample, d15N_bulk_POM = d15NAIR, d13C_bulk_POM = d13CVPDB,
         ugN_bulk_POM = mgN, ugC_bulk_POM = mgC, PercentN_bulk_POM = `%N`,
         PercentC_bulk_POM = `%C`, C_N_POM = `C/N`) %>% 
  separate(Site_ID, c("Site_ID", "Extra"), sep = " ", extra = "merge") %>% 
  separate(Extra, c("Extra", "Month", "Day"), sep = , fill = "left") %>% 
  mutate(Day = replace(Day, Day == '209', '09'),
         Year = 2019) %>% 
  unite(Date, Month, Day, Year, sep = "-") %>% 
  filter(str_sub(Site_ID, 1, 1) == "D", is.na(Extra), Site_ID != 'DIL') %>% 
  mutate(Date = lubridate::mdy(Date),
         Site_ID = str_sub(Site_ID, 2, length(Site_ID)),
         Site_ID = ifelse(is.na(str_extract(Site_ID, "[aA-zZ]+")),
                          paste0(Site_ID, 'A'), Site_ID)) %>% 
  select(-Extra) %>% 
  group_by(Site_ID, Date) %>% 
  summarise(across(.cols = d15N_bulk_POM:C_N_POM, .fns = ~ mean(., na.rm = TRUE))) %>% 
  mutate(across(.fns = ~replace(., is.nan(.), NA)))

# shaky bottle temps
sb_2019 <- read_csv("data/shakeybottle_2019.csv") %>% 
  mutate(Date = lubridate::dmy(Date),
         Site_ID = ifelse(is.na(str_extract(Site_ID, "[aA-zZ]+")),
                          paste0(Site_ID, 'A'), Site_ID)) %>% 
  filter(Sample == '1A' | Sample == '2A') %>% # checked NAs, they are fine
  select(Site_ID:Temp_Out) %>% 
  pivot_longer(Temp_in:Temp_Out, names_to = "temp_type", values_to = "temp") %>% 
  pivot_wider(names_from = c(temp_type, Sample), values_from = temp) %>% 
  rename(Bottle1_temp_in = Temp_in_1A, Bottle1_temp_out = Temp_Out_1A,
         Bottle2_temp_in = Temp_in_2A, Bottle2_temp_out = Temp_Out_2A)

# alk, SO4, and chloride
alk_etc_2019 <- read_csv("data/ALK_CHL_SO4_2019.csv") %>% 
  select(Site_ID = `Sample ID`, Alk_mg.L = `ALKALINITY (mg/L)`, 
         Chloride_mg.L = `CHLORIDE (mg/L)`, SO4_mg.L = `SO4 (mg/L)`) %>% 
  separate(Site_ID, c("Site_ID", "Date"), "-") %>% 
  filter(str_sub(Site_ID, 1, 1) == "D") %>% 
  mutate(Year = 2019,
         Month = str_extract(Date, "[aA-zZ]+"), # pull out letters from Date
         Day = str_extract(Date, "[0-9]+")) %>% # pull out numbers from Date
  # if Day has only 1 character, add a 0 in front so lubridate understands
  mutate(Day = ifelse(str_length(Day) == 1, paste0("0", Day), Day)) %>% 
  unite("Date", Day, Month, Year, sep = "-") %>% 
  mutate(Date = lubridate::dmy(Date),
         Site_ID = str_sub(Site_ID, 2, length(Site_ID)),
         Site_ID = ifelse(is.na(str_extract(Site_ID, "[aA-zZ]+")),
                          paste0(Site_ID, 'A'), Site_ID)) 

# merge into 2019 master file
master2019 <- left_join(select(master2019, 
                               -Bottle1_temp_in:-Bottle2_temp_out, 
                               -SO4_mg.L:-Chloride_mg.L,
                               -d15N_bulk_POM:-C_N_POM),
                        sb_2019) %>% 
  left_join(alk_etc_2019) %>% 
  left_join(pom_2019) %>% 
  select(Site_ID:Sediment_depth, Bottle1_temp_in:Bottle2_temp_out, 
         Tows:Surface_TN_TP, SO4_mg.L, Alk_mg.L, Chloride_mg.L,
         MC_ug.L:Sediment_C_N_org, d15N_bulk_POM:C_N_POM,
         d2H:General_comments) 

## need to double-check site_IDs that might be missing in 2019

# 2020 ####

# read in DIC, DOC, and water chem data for 2020
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
  mutate(Date = lubridate::ydm(Date),
         Site_ID = ifelse(is.na(str_extract(Site_ID, "[aA-zZ]+")),
                          paste0(Site_ID, 'A'), Site_ID)) %>% 
  # make a new column to indicate if samples were labeled "deep"
  separate(Site_ID, c("Site_ID", "Deep"), sep = "-")

# prep waterchem data
waterchem2020 <- waterchem2020 %>% 
  select(Sample:Nitrate.Nitrite..ug.N.L.) %>% 
  drop_na() %>% 
  mutate(Site_ID = str_sub(Sample, 2, nchar(Sample)),
         Sample = str_sub(Sample, 1, 1),
         Site_ID = replace(Site_ID, Site_ID == '57C', '56C'),
         Site_ID = ifelse(is.na(str_extract(Site_ID, "[aA-zZ]+")),
                          paste0(Site_ID, 'A'), Site_ID)) %>% 
  separate(Site_ID, c("Site_ID", "Deep"), sep = "-")

# join waterchem2020 to carbon2020
carbon_waterchem2020 <- full_join(carbon2020, waterchem2020) %>% 
  select(-Sample) 

# make deep and surface dfs and rejoin
# separate "deep" values
carbon_water_deep <- carbon_waterchem2020 %>% 
  filter(!is.na(Deep)) %>% 
  rename(Deep_DIC_mg.L = TIC..PPM.as.mg.L.C., 
         Deep_DOC_mg.L = TOC..PPM.as.mg.L.C., 
         Deep_TN_ug.N.L = TN..ug.N.L., Deep_TP_mg.P.L = TP..mg.P.L., 
         Deep_NH3_mg.N.L = Ammonia..mg.NH3.N.L., Deep_SRP_mg.P.L = SRP..mg.P.L., 
         Deep_Nitrate_Nitrite_ug.N.L = Nitrate.Nitrite..ug.N.L.) %>% 
  select(-Deep)

carbon_water_surface <- carbon_waterchem2020 %>% 
  filter(is.na(Deep)) %>% 
  rename(Surface_DIC_mg.L = TIC..PPM.as.mg.L.C., 
         Surface_DOC_mg.L = TOC..PPM.as.mg.L.C., Surface_TN_ug.N.L = 
         TN..ug.N.L., Surface_TP_mg.P.L = TP..mg.P.L., Surface_NH3_mg.N.L = 
         Ammonia..mg.NH3.N.L., Surface_SRP_mg.P.L = SRP..mg.P.L., 
         Surface_Nitrate_Nitrite_ug.N.L = Nitrate.Nitrite..ug.N.L.) %>% 
  select(-Deep)

# fix differences in dates according to Ryan's corrections
carbon_water_surface <- carbon_water_surface %>% 
  mutate(Date = replace(Date, Site_ID == '56A' & Date == "2020-06-02", "2020-06-03"),
         Date = replace(Date, Site_ID == '56C' & Date == "2020-06-02", "2020-06-03"),
         Date = replace(Date, Site_ID == 'LA2' & Date == "2020-07-22", "2020-07-02"),
         Site_ID = replace(Site_ID, Site_ID == 'LB1', 'CB1'))

master2020 <- master2020 %>% 
  mutate(Date = replace(Date, Site_ID == '56A' & Date == "2020-06-20", "2020-06-30"),
         Date = replace(Date, Site_ID == 'LH' & Date == "2020-07-03", "2020-07-07"),
         Date = replace(Date, Site_ID == 'LS' & Date == "2020-07-03", "2020-07-07"),
         Date = replace(Date, Site_ID == '14B' & Date == "2020-07-20", "2020-07-30"),
         Date = replace(Date, Site_ID == '14A' & Date == "2020-08-16", "2020-08-17"),
         Date = replace(Date, Site_ID == '56A' & Date == "2020-08-16", "2020-08-17"))

# other bits of data
sites_2020 <- paste(c(unique(master2020$Site_ID), "65", "14C2"), collapse = '|')
other_2020 <- read_csv("data/other_2020.csv", na = 'na') %>% 
  rename(Site_ID = `Site ID`, Bottle1_temp_in = `Bottle Temp In 1`,
         Bottle1_temp_out = `Bottle Temp Out 1`, Bottle2_temp_in = `Bottle Temp In 2`,
         Bottle2_temp_out = `Bottle Temp Out 2`, Field_team = `Field Team`,
         General_comments = `General Comments`) %>% 
  mutate(Date = lubridate::dmy(Date),
         Site_ID = str_extract(Site_ID, sites_2020))

# need to merge 2020 data #
master2020 <- full_join(master2020, carbon_water_surface) %>% 
  full_join(., carbon_water_deep) %>% 
  select(-Bottle1_temp_in:-Bottle2_temp_out, -Field_team, -General_comments) %>% 
  left_join(other_2020)

#####

# MATCH COLUMN TYPES ####-------------------------------------------------------

# only chr columns should be Site_ID, Field_team, Floating_chamber, Regime, 
# Water_source, Water_class, Age_class, and Land_use #
# Date should be Date, Time should be 'hms' num, everything else should be num #

# fix chr columns in 2017 
master2017 <- master2017 %>% 
  # replace '<LOD' with 10% of LOD
  # LOD for SRP is 0.01 mg/L
  # LOD for NO2/NO3 is 5 ug/L
  mutate(Surface_SRP_mg.P.L = replace(Surface_SRP_mg.P.L, 
                                      Surface_SRP_mg.P.L == '<LOD', 
                                      0.1*0.01),
         Surface_Nitrate_Nitrite_ug.N.L = replace(Surface_Nitrate_Nitrite_ug.N.L, 
                                      Surface_Nitrate_Nitrite_ug.N.L == '<LOD', 
                                      0.1*5.0)) %>% 
  # convert columns to numeric
  mutate(Surface_SRP_mg.P.L = as.numeric(Surface_SRP_mg.P.L), 
         Surface_Nitrate_Nitrite_ug.N.L = as.numeric(Surface_Nitrate_Nitrite_ug.N.L), 
         SO4_mg.L = as.numeric(SO4_mg.L)) %>% 
  # calculate other columns 
  mutate(Surface_DIN_ug.N.L = (Surface_NH3_mg.N.L*1000) + Surface_Nitrate_Nitrite_ug.N.L)

# calculate columns in other years
master2018 <- master2018 %>% 
  mutate(Surface_TN_TP = (Surface_TN_ug.N.L/1000) / Surface_TP_mg.P.L)

master2019 <- master2019 %>% 
  mutate(Surface_DIN_ug.N.L = (Surface_NH3_mg.N.L*1000) + Surface_Nitrate_Nitrite_ug.N.L,
         Surface_TN_TP = (Surface_TN_ug.N.L/1000) / Surface_TP_mg.P.L)

master2020 <- master2020 %>% 
  mutate(Surface_DIN_ug.N.L = (Surface_NH3_mg.N.L*1000) + Surface_Nitrate_Nitrite_ug.N.L,
         Surface_TN_TP = (Surface_TN_ug.N.L/1000) / Surface_TP_mg.P.L)

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

## Match-up Land-use Descriptors from 2017 ##
master2018 <- left_join(select(master2018, -Land_use),
                        select(master2017, Site_ID, Land_use))
  
master2019 <- left_join(select(master2019, -Land_use),
                        select(master2017, Site_ID, Land_use))

master2020 <- left_join(select(master2020, -Land_use),
                        select(master2017, Site_ID, Land_use))
#####

# BIND TOGETHER ####------------------------------------------------------------

grand_master <- bind_rows(master2017, 
                          master2018,
                          master2019,
                          master2020)

write_csv(grand_master, "data/grand_master.csv")

# END #-------------------------------------------------------------------------

# grand_master <- read_csv("data/grand_master.csv")
# 
# grand_master_NA <- grand_master %>%
#   mutate(Year = as.factor(lubridate::year(Date))) %>% 
#   group_by(Year) %>% 
#   summarise_all(funs(sum(is.na(.)))) %>% 
#   pivot_longer(Site_ID:General_comments,
#                names_to = "Column", values_to = "NA_count") %>% 
#   filter(NA_count > 40)

            