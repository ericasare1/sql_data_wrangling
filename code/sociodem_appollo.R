
df_appolo <- read.csv("data/processednew.csv")
df_appolo1 <- sqldf(
  "select                                                                                   
    responseid,
    CASE WHEN province = 'SK' THEN 1 ELSE 0 END AS Sk, 
    CASE WHEN province = 'AB' THEN 1 ELSE 0 END AS AB,
    CASE WHEN province = 'MN' THEN 1 ELSE 0 END AS MN,
    round(100*(CAST(cropland_owned AS float)/CAST(totalacres AS float)), 2) AS prop_croplandowned, 
    CASE WHEN auto_guidance = 1|gps = 1|drones = 1 THEN 1 ELSE 0 END As precision_ag,     
    bothrentbuy_next5yrs, 
    (num_permanent_wl + num_seasonal_wl) AS numwl_onfarm,   
    own_eqdwl, 
    dont_farm_seasonal_wl,
    CASE WHEN twenty_five_abav=1|ten_abav=1|about_average=1 THEN 1 ELSE 0 END AS wlqual_abavup, 
    converted_wetland,  
    nointerestedrentmoreland, rentalpricestoohigh, overalllandquanotattractive, 
    perc_wl_potent_convert, draincost_peracre,   
    CASE WHEN conserwl_mandatorypartsustainagcert=1|haveenvfarmplan=1|partbmp=1|sustainabilitycert_mosteffective =1 THEN 1 ELSE 0 END AS posmindset_conserv,  
    CASE WHEN waterqual_veryimport=1|floodcont_veryimport=1|erosioncont_veryimport=1|wildlifehab_veryimport=1 THEN 1 ELSE 0 END AS ess_import,  
    CASE WHEN numwl_decreasedalot=1|numwl_slightdecreased=1 THEN 1 ELSE 0 END AS numwl_decreased,
    numwl_nochange,
    CASE WHEN waterquality_decreasedalot=1|waterquality_slightdecreased=1 THEN 1 ELSE 0 END AS waterqual_decreased,
    waterquality_nochange,
    CASE WHEN conservationpayment_mosteffective=1|conservationeasement_mosteffective=1 THEN 1 ELSE 0 END AS conspayeaseeff,
    CASE WHEN techassistance_mosteffective=1|extensionprog_mosteffective=1 THEN 1 ELSE 0 END AS techexteffe,
    regulation_mosteffective, 
    sole_proprietorship,partnership,familycorporation,nonfam_corporation, 
    zero_tllage_in2019, continuouscropping_in2019, plowgreencrops_in2019, shelterbelts_in2019,
    sex, no_schooling, university_degree, prop_hhincome_farming,years_farmoperatedfarm,childrenlikely_takeover,
    CASE WHEN age_45_54=1|age_55_64=1|age_65_74=1|age_75more=1 THEN 1 ELSE 0 END AS age45_more
    
From df_appolo
")

view(df_appolo1)

write.csv(df_appolo1, "data/sociodem_appollo.csv")
