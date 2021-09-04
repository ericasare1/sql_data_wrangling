
# Cleans environment
rm(list=ls(all=TRUE))

library("tidyverse")
library("sqldf")

df2 <- read.csv("data/main_cleaned.csv")
df3 <- sqldf(
"select                                                                                                          -- <--Brief cmments on variablee groups-->
    responseid, respid, status, province,                                           
    cropland_owned, hayland_owned, pastland_owned,                                                               --land owned                 
    cropland_rented, hayland_rented, pastland_rented, totalacres,                                                --land rented
    canola, barley, rye, spring_wheat, beans, peas, flaxseed,                                                    --crops acreage cultivated
    lentil, soybeans, corn, oats, sunflower, others, 
    auto_guidance, gps, vriable_rate, drones, soil_test, slow_release_fert,                                      -- Precision ag tools use
    land_purchase_decision, num_permanent_wl, num_seasonal_wl,                                                   -- land purchase dec and wetlands on land
    own_eqdwl, no_rent_eqdwl, no_own_rent_eqdwl,                                                                 -- wetland drainage ownership
    own_scrapper, own_trackhoe, own_ditch_machine, own_tile_plow, own_other,                                     -- wetland drainage tools owned
    two_out_ten, four_out_ten, six_out_ten, eight_out_ten, ten_out_ten, dont_farm_seasonal_wl,
    twenty_five_abav, ten_abav, about_average, ten_belav, twenty_five_belav,                                     -- wetland land quality compared to nonwl
    converted_bush, converted_bush, converted_wetland, converted_nativegrassland,                                -- landtype conversion in last 5 yrs
    perc_wl_potent_convert, num_wl_convert, num_wlacres_convert,  draincost_peracre,                             -- potential wetland attributes in drainage
    rate_increasedeff, rate_landquality, rate_draincost, rate_effonwaterqual,                                    -- factors important in wl decision
    rate_effonnearbyflooding, rate_effsurrlandacc, rate_delayedplanting, rate_weedcontrol, rate_wildlifehabitat,
    restwl5perland_20percpremium, participatewlconser_anypremium, have_environfarmplan,                          -- will you restore wl based on some incentives?
    import_waterquality_ess, import_floodcontrol_ess, import_erosioncontrol_ess,import_wildlifehab_ess,          -- ESS importance 
    import_carbonstorage_ess, import_recreation_edu_ess, 
    numwl_trendfromknowledge,qualitywl_trendfromknowledge,                                                       -- to you how has wl num and quality fared from the past
    conservationpayment_rankagconserprg, techassistance_rankagconserprg, extensionprog_rankagconserprg,          -- How does these policies influence conservation dec
    conservationeasement_rankagconserprg, sustainabilitycert_rankagconserprg, regulation_rankagconserprg, 
    firstchoice_cropinfo, firstchoice_cropinfo AS firstchoice_conserinfo,                                       -- first choice infor for crop prod and conservation
    sole_proprietorship,partnership,familycorporation,nonfam_corporation,                                       -- form of farm business
    zero_tllage_in2019,continuouscropping_in2019,plowgreencrops_in2019,hvewintercrops_in2019,                   -- cultivation practive in 2019
    rotationalgrazing_in2019,infield_wintergrazing_in2019, shelterbelts_in2019,
    sex,age_18_24,age_25_34,age_35_44,age_45_54,age_55_64,age_65_74,age_75more,age_noresponse,                  --key demographic info
    no_schooling, highschool,some_posysecondary,vocationa_diploma,university_degree,donot_know,
    prop_hhincome_farming,years_farmoperatedfarm, have_children,childrenlikely_takeover
From df2
      ")
view(df2)























