
# Cleans environment
rm(list=ls(all=TRUE))

library("tidyverse")
library("sqldf")

df2 <- read.csv("data/main_cleaned.csv")
df3 <- sqldf(
"select                                                                                     -- <--Brief cmments on variablee groups-->
    responseid, respid, status, province,                                           
    cropland_owned, hayland_owned, pastland_owned,                                          --land owned  
    
    cropland_rented, hayland_rented, pastland_rented, totalacres,                           --land rented
    
    canola, barley, rye, spring_wheat, beans, peas, flaxseed,                               --crops acreage cultivated
    lentil, soybeans, corn, oats, sunflower, others, 
    
    CASE WHEN auto_guidance = 1 THEN 1 ELSE 0 END As auto_guidance,                         -- Precision ag tools use
    CASE WHEN gps = 1 THEN 1 ELSE 0 END As gps,
    CASE WHEN vriable_rate = 1 THEN 1 ELSE 0 END As variable_rate,
    CASE WHEN drones = 1 THEN 1 ELSE 0 END As drones,
    CASE WHEN soil_test = 1 THEN 1 ELSE 0 END As soil_test,
    CASE WHEN slow_release_fert = 1 THEN 1 ELSE 0 END As slow_release_fert,
    
    CASE WHEN land_purchase_decision = 1 THEN 1 ELSE 0 END As rentland_next5yrs,            -- land purchase dec and wetlands on land
    CASE WHEN land_purchase_decision = 2 THEN 1 ELSE 0 END As buyland_next5yrs,
    CASE WHEN land_purchase_decision = 3 THEN 1 ELSE 0 END As bothrentbuy_next5yrs,
    CASE WHEN land_purchase_decision = 4 THEN 1 ELSE 0 END As notrentbuy_next5yrs,
    
    num_permanent_wl, num_seasonal_wl,                                                      -- wetland types on land   
    
    own_eqdwl, no_rent_eqdwl, no_own_rent_eqdwl,                                           -- wetland drainage ownership
    
    CASE WHEN own_scrapper = 1 THEN 1 ELSE 0 END As own_scrapper,                          -- wetland drainage tools owned
    CASE WHEN own_trackhoe = 1 THEN 1 ELSE 0 END As own_trackhoe,
    CASE WHEN own_ditch_machine = 1 THEN 1 ELSE 0 END As own_ditch_machine,
    CASE WHEN own_tile_plow = 1 THEN 1 ELSE 0 END As own_tile_plow,
    
    two_out_ten, four_out_ten, six_out_ten, eight_out_ten, ten_out_ten,                    --Delayed Seeding
    dont_farm_seasonal_wl,
    
    twenty_five_abav, ten_abav, about_average, ten_belav, twenty_five_belav,               -- wetland land quality compared to nonwl
    
    converted_bush, converted_bush, converted_wetland, converted_nativegrassland,          -- landtype conversion in last 5 yrs
    
    childrenlikely_takeover, nolandwithwetlandconfchoice, nointerestedrentmoreland,        -- No choice in exp and reasons
    rentalpricestoohigh, overalllandquanotattractive, otherreasons
    
    perc_wl_potent_convert, num_wl_convert, num_wlacres_convert,  draincost_peracre,       -- potential wetland attributes in drainage
    
    rate_increasedeff, rate_landquality, rate_draincost, rate_effonwaterqual,              -- factors important in wl decision
    rate_effonnearbyflooding, rate_effsurrlandacc, rate_delayedplanting, 
    rate_weedcontrol, rate_wildlifehabitat,
    
    conserwl_mandatorypartsustainagcert, haveenvfarmplan, partbmp,    -- will you restore wl based on some incentives?
    
    CASE WHEN import_waterquality_ess = 1 THEN 1 ELSE 0 END As waterqual_veryimport,       -- ESS importance
    CASE WHEN import_waterquality_ess = 2 THEN 1 ELSE 0 END As waterqual_slightlyimport,
    CASE WHEN import_waterquality_ess = 3 THEN 1 ELSE 0 END As waterqual_notimport,
    CASE WHEN import_waterquality_ess = 4 THEN 1 ELSE 0 END As waterqual_noopinion,
   
    CASE WHEN import_floodcontrol_ess = 1 THEN 1 ELSE 0 END As floodcont_veryimport,
    CASE WHEN import_floodcontrol_ess = 2 THEN 1 ELSE 0 END As floodcont_slightlyimport,
    CASE WHEN import_floodcontrol_ess = 3 THEN 1 ELSE 0 END As floodcont_notimport,
    CASE WHEN import_floodcontrol_ess = 4 THEN 1 ELSE 0 END As floodcont_noopinion,    
    
    CASE WHEN import_erosioncontrol_ess = 1 THEN 1 ELSE 0 END As erosioncont_veryimport,
    CASE WHEN import_erosioncontrol_ess = 2 THEN 1 ELSE 0 END As erosioncont_slightlyimport,
    CASE WHEN import_erosioncontrol_ess = 3 THEN 1 ELSE 0 END As erosioncont_notimport,
    CASE WHEN import_erosioncontrol_ess = 4 THEN 1 ELSE 0 END As erosioncont_noopinion,   
    
    CASE WHEN import_wildlifehab_ess = 1 THEN 1 ELSE 0 END As wildlifehab_veryimport,
    CASE WHEN import_wildlifehab_ess = 2 THEN 1 ELSE 0 END As wildlifehab_slightlyimport,
    CASE WHEN import_wildlifehab_ess = 3 THEN 1 ELSE 0 END As wildlifehab_notimport,
    CASE WHEN import_wildlifehab_ess = 4 THEN 1 ELSE 0 END As wildlifehab_noopinion, 
    
                                                       
    CASE WHEN numwl_trendfromknowledge = 1 THEN 1 ELSE 0 END As numwl_decreasedalot,       -- to you how has wl num and quality fared from the past
    CASE WHEN numwl_trendfromknowledge = 2 THEN 1 ELSE 0 END As numwl_slightdecreased,
    CASE WHEN numwl_trendfromknowledge = 3 THEN 1 ELSE 0 END As numwl_nochange,
    CASE WHEN numwl_trendfromknowledge = 4 THEN 1 ELSE 0 END As numwl_slightincrease,
    CASE WHEN numwl_trendfromknowledge = 5 THEN 1 ELSE 0 END As numwl_increasedalot,

    CASE WHEN qualitywl_trendfromknowledge = 1 THEN 1 ELSE 0 END As waterquality_decreasedalot,
    CASE WHEN qualitywl_trendfromknowledge = 2 THEN 1 ELSE 0 END As waterquality_slightdecreased,
    CASE WHEN qualitywl_trendfromknowledge = 3 THEN 1 ELSE 0 END As waterquality_nochange,
    CASE WHEN qualitywl_trendfromknowledge = 4 THEN 1 ELSE 0 END As waterquality_slightincrease,
    CASE WHEN qualitywl_trendfromknowledge = 5 THEN 1 ELSE 0 END As waterquality_increasedalot,
    
    CASE WHEN conservationpayment_rankagconserprg = 1 THEN 1 
         ELSE 0 END As conservationpayment_leasteffective,                                      -- How does these policies influence conservation dec
    CASE WHEN conservationpayment_rankagconserprg = 6 THEN 1 
        ELSE 0 END As conservationpayment_mosteffective,
    CASE WHEN techassistance_rankagconserprg = 1 THEN 1 
        ELSE 0 END As techassistance_leasteffective,
    CASE WHEN techassistance_rankagconserprg = 6 THEN 1 
        ELSE 0 END As techassistance_mosteffective,
    CASE WHEN extensionprog_rankagconserprg = 1 THEN 1 
        ELSE 0 END As extensionprog_leasteffective,
    CASE WHEN extensionprog_rankagconserprg = 6 THEN 1 
        ELSE 0 END As extensionprog_mosteffective,
    CASE WHEN conservationeasement_rankagconserprg = 1 THEN 1 
        ELSE 0 END As conservationeasement_leasteffective,
    CASE WHEN conservationeasement_rankagconserprg = 6 THEN 1 
        ELSE 0 END As conservationeasement_mosteffective,
    CASE WHEN sustainabilitycert_rankagconserprg = 1 THEN 1 ELSE 0 
        END As sustainabilitycert_leasteffective,
    CASE WHEN sustainabilitycert_rankagconserprg = 6 THEN 1 
        ELSE 0 END As sustainabilitycert_mosteffective,
    CASE WHEN regulation_rankagconserprg = 1 THEN 1 
        ELSE 0 END As regulation_leasteffective,
    CASE WHEN regulation_rankagconserprg = 6 THEN 1 
        ELSE 0 END As regulation_mosteffective,
    
    CASE WHEN firstchoice_cropinfo = 'Fertilizer or Ag Chemical Dealer' THEN 1                 -- first choice infor for crop prod and conservation
        ELSE 0 END As chem_dealer_cropinfo,  
    CASE WHEN firstchoice_cropinfo = 'Seed Dealer' THEN 1 ELSE 0 END As seeddealer_cropinfo,
    CASE WHEN firstchoice_cropinfo = 'Regional Agricultural Extension Specialist' THEN 1 
        ELSE 0 END As regagextspecialist_cropinfo,
    CASE WHEN firstchoice_cropinfo = 'Private Crop consultant' THEN 1 
        ELSE 0 END As privcropconsultant_cropinfo,
    CASE WHEN firstchoice_cropinfo = 'University extension' THEN 1 
        ELSE 0 END As univsext_cropinfo,
    CASE WHEN firstchoice_cropinfo = 'Commodity groups' THEN 1 
        ELSE 0 END As commoditygrps_cropinfo,
  
    CASE WHEN firstchoice_conserinfo = 'Fertilizer or Ag Chemical Dealer' THEN 1 ELSE 0 END As chem_dealer_conserinfo,
    CASE WHEN firstchoice_conserinfo = 'Seed Dealer' THEN 1 ELSE 0 END As seeddealer_conserinfo,
    CASE WHEN firstchoice_conserinfo = 'Regional Agricultural Extension Specialist' THEN 1 ELSE 0 END As regagextspecialist_conserinfo,
    CASE WHEN firstchoice_conserinfo = 'Private Crop consultant' THEN 1 ELSE 0 END As privcropconsultant_conserinfo,
    CASE WHEN firstchoice_conserinfo = 'University extension' THEN 1 ELSE 0 END As univsext_conserinfo,
    CASE WHEN firstchoice_conserinfo = 'Commodity groups' THEN 1 ELSE 0 END As commoditygrps_conserinfo,
    
    sole_proprietorship,partnership,familycorporation,nonfam_corporation,                         -- form of farm business
    
    zero_tllage_in2019,continuouscropping_in2019,plowgreencrops_in2019,hvewintercrops_in2019,     -- cultivation practive in 2019
    rotationalgrazing_in2019,infield_wintergrazing_in2019, shelterbelts_in2019,
    
    sex,age_18_24,age_25_34,age_35_44,age_45_54,age_55_64,age_65_74,age_75more,age_noresponse,    --key demographic info
    no_schooling, highschool,some_posysecondary,vocationa_diploma,university_degree,donot_know,
    prop_hhincome_farming,years_farmoperatedfarm, have_children,childrenlikely_takeover
    
From df2
")

view(df3)

write.csv(df3, "data/processednew.csv")






















