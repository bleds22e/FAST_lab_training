# MERGE MASTER FILES 2017-2020 #### 

library(tidyverse)

# DATA #

master2017 <- read_csv("merging_masters/data/dugout_master2017.csv",
                       na = c("", "NA", "#N/A", "#VALUE!", "#DIV/0!"))
# make some quick fixes to the dataframe (from dugouts_2017_complete.R)
master2017 <- master2017[-(103:104),]
master2017[5, 4] <- "24-Jul-17" # reassign date value that includes year

master2018 <- read_csv("merging_masters/data/dugout_master2018.csv",
                        na = c("", "NA", "#N/A", "#VALUE!", "#DIV/0!"),
                        col_types = cols(Time = col_time("%H:%M")))
master2019 <- read_csv("merging_masters/data/dugout_master2019.csv",
                       na = c("", "NA", "#N/A", "#VALUE!", "#DIV/0!"))

# 2017 data
master2017 <- master2017 %>% 
  # add columns that are in the 2018 or 2019 data but not 2017
  add_column(Chl_total = NA, DIN_ug.N.L = NA, MC_ug.L = NA, d15N_bulk_POM = NA,
             d13C_bulk_POM = NA, ugN_bulk_POM = NA, ugC_bulk_POM = NA, 
             PercentN_bulk_POM = NA, PercentC_bulk_POM = NA, C_N_POM = NA,
             TA_DIC_umol = NA, TA_CO2_umol = NA, Rn_dpm.L = NA, 
             Elevation_m = NA) %>%
  # order columns and rename all the columns with standard format
  # first word uppercase, subsequent words lowercase, separated by _
  # . is used to separate components of units with more than one component 
  select(Site_ID:Time, Latitude = latitude, Longitude = longitude, Air_temp, 
         Cloud_perc = `Cloud (%)`, Wind_km.hr, Field_team, Secchi_m = Secchi.m, 
         Depth_m = Depth.m, Max_depth_m = Max_depth.m,
         DO_calibration_perc = `DO Calibration%`, Surface_temp = Surface_Temp, 
         Surface_DO_sat = Surface_DO.sat, Surface_DO_mg.L = Surface_DO.mg.L,
         Surface_cond = Surface_Cond, Surface_sal_ppt = Surface_Sal.ppt, 
         Surface_pH, Deep_temp = Deep_Temp, Deep_DO_sat = Deep_DO.sat, 
         Deep_DO_mg.L = Deep_DO.mg.L, Deep_cond = Deep_Cond, Deep_sal_ppt = 
         Deep_Sal.ppt, Deep_pH, TDS_mg.L = TDS.mg.L, YSI_atm, Core_length_cm = 
         `Core_length (cm)`, Sediment_depth, Bottle_temp_in = Bottle_Temp_In, 
         Bottle_temp_out, Tows, Floating_chamber = `Floating_chamberY/N`, Chl_total,
         Chla, NH3_mg.N.L = NH3.mg.N.L, SRP_mg.P.L = SRP.mg.P.L, 
         Nitrate_Nitrite_ug.N.L = Nitrate_Nitrite.ug.N.L, DIN_ug.N.L, TP_mg.P.L = 
         TP.mg.P.L, TN_ug.N.L = TN.ug.N.L, NP_ratio, TN_TP, DIC_mg.L = DIC.mg.L, 
         DIC_uM = DIC.uM, DOC_mg.L = DOC.mg.L, DOC_uM = DOC.uM, SO4_mg.L = 
         SO4.mg.L, Alk_mg.L = Alk.mg.L, MC_ug.L, pCO2, CO2_uM = CO2.uM, 
         CO2_uM_error = CO2.uM.error, pCH4, CH4_uM = CH4.uM, CH4_uM_error = 
         CH4.uM.error, pN2O, N2O_nM = N2O.nM, N2O_nM_error = N2O.nM.error, 
         d15N_bulk:PercentC_bulk, Sediment_C_N = sediment_C_N, d15N_bulk_POM:C_N_POM,
         d2H:Regime, Water_source = Water_Source, Residence_time = RT, 
         Water_class, d_excess:Inflow, Land_use = Landuse, Age_years = Age.years,
         NP_ratio2 = NP.ratio, TA_DIC_umol, TA_CO2_umol, B_F_max = b.f.max, 
         B_F_min = b.f.min, Rn_dpm.L, Elevation_m, Area_m2 = Area.m, Perimeter, 
         Volume_m3 = Volume.m3, SI, General_comments = `General Comments`) %>% 
  # calculate the columns missing columns that we can
  mutate(Date = lubridate::dmy(Date))
  # mutate(DIN_ug.N.L = (NH3_mg.N.L*1000) + Nitrate_Nitrite_ug.N.L)
  #   - mutate function not working because Nitrate_Nitrite_ug.N.L column is a 
  #     character column due to "<LOD" values

  
  
# 2018 data  
master2018 <- master2018 %>% 
  select(Site_ID, Date, Time, Latitude = latitude, Longitude = longitude, 
         Air_temp, Cloud_perc = `Cloud (%)`, Wind_km.hr, Field_team)
master2019 <- master2019 %>% 
  select(Site_ID = Site, Date, Time, Latitude = latitude, Longitude = longitude,
         Air_temp, Cloud_perc = `Cloud (%)`, Wind_km.hr, Field_team)

site_descr <- bind_rows(site2017, site2018, site2019) # 2018 time in decimals


  
# WORK AREA #===================================================================

# DIN_ug.N.L = (NH3_mg.N.L*1000)+Nitrate_Nitrite_ug.N.L
# TN_TP = (TN.ug.N.L/1000) / TP.mg.P.L

time_check <- bind_rows(select(master2017, Time), 
                        select(master2018, Time),
                        select(master2019, Time))

Date_check <- bind_rows(select(master2017, Date), 
                        select(master2018, Date),
                        select(master2019, Date))
