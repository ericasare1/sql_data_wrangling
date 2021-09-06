

if(!require(pacman)) {
  install.packages("pacman")
  library(pacman)
}

#load
p_load(tidyverse,gtsummary,flextable)

df4 <- read.csv("data/processed.csv")

crop_cultivation <- sqldf("
SELECT

    responseid, province, converted_wetland, nolandwithwetlandconfchoice,
    num_permanent_wl, num_seasonal_wl                                                      -- wetland types on land   
    own_eqdwl, no_rent_eqdwl, no_own_rent_eqdwl,                                           -- wetland drainage ownership
                                                                                           -- wetland drainage tools owned
    own_scrapper, own_trackhoe, own_ditch_machine, own_tile_plow,
    
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
    
    restwl5perland_20percpremium, participatewlconser_anypremium, have_environfarmplan,    -- will you restore wl based on some incentives?
    
                                                                                          -- ESS importance
    waterqual_veryimport, waterqual_slightlyimport,waterqual_notimport,waterqual_noopinion,
    floodcont_veryimport, floodcont_slightlyimport, floodcont_notimport, floodcont_noopinion,    
    erosioncont_veryimport, erosioncont_slightlyimport, erosioncont_notimport,erosioncont_noopinion,   
    wildlifehab_veryimport, wildlifehab_slightlyimport, wildlifehab_notimport, wildlifehab_noopinion, 
    
                                                       
                                                                                          -- to you how has wl num and quality fared from the past
    numwl_decreasedalot, numwl_slightdecreased, numwl_nochange, numwl_slightincrease, numwl_increasedalot,
    waterquality_decreasedalot, waterquality_slightdecreased, waterquality_nochange, waterquality_slightincrease, waterquality_increasedalot,
  

FROM df4
")
view(crop_cultivation)

#group by province
crop_cultivation_prov <-  tbl_summary(
  demographic,
  by = province,
  type = all_continuous() ~ "continuous2",
  statistic = all_continuous() ~ c( "{mean} ({sd})", 
                                    "{min}, {max}"),
  missing = "no"
) %>%
  add_n() %>% # add column with total number of non-missing observations
  #add_p() %>% # test for a difference between groups
  modify_header(label = "**Variable**") %>% # update the column header
  as_flex_table() %>%
  save_as_docx("demo_table", path = "data/crop_cultivation.docx")

#group by convertedwl_past5years
crop_cultivation_conv <-  tbl_summary(
  demographic,
  by = converted_wetland,
  type = all_continuous() ~ "continuous2",
  statistic = all_continuous() ~ c( "{mean} ({sd})", 
                                    "{min}, {max}"),
  missing = "no"
) %>%
  add_n() %>% # add column with total number of non-missing observations
  #add_p() %>% # test for a difference between groups
  modify_header(label = "**Variable**") %>% # update the column header
  as_flex_table() %>%
  save_as_docx("demo_table", path = "data/crop_cultivation_converted.docx")

#group by nochoice
crop_cultivation_nochoice <-  tbl_summary(
  demographic,
  by = nolandwithwetlandconfchoice,
  type = all_continuous() ~ "continuous2",
  statistic = all_continuous() ~ c( "{mean} ({sd})", 
                                    "{min}, {max}"),
  missing = "no"
) %>%
  add_n() %>% # add column with total number of non-missing observations
  #add_p() %>% # test for a difference between groups
  modify_header(label = "**Variable**") %>% # update the column header
  as_flex_table() %>%
  save_as_docx("demo_table", path = "output/crop_cultivation_nochoice.docx")
