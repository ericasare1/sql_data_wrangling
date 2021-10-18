

if(!require(pacman)) {
  install.packages("pacman")
  library(pacman)
}

#load
p_load(tidyverse,gtsummary,flextable,sqldf)

df4 <- read.csv("data/processed.csv")

crop_cultivation <- sqldf("
SELECT

    responseid, province, nolandwithwetlandconfchoice,
    converted_bush, converted_wetland, converted_nativegrassland,
    cropland_owned, hayland_owned, pastland_owned, 
    (cropland_owned+ hayland_owned + pastland_owned) AS acres_owned,
    (cropland_rented + hayland_rented + pastland_rented) AS acres_rented,
    totalacres,
    canola, barley, rye, spring_wheat, beans, peas, flaxseed, 
    lentil, soybeans, corn, oats, sunflower, others, 
    auto_guidance, gps, variable_rate, drones, soil_test, slow_release_fert,
    rentland_next5yrs, buyland_next5yrs, bothrentbuy_next5yrs, notrentbuy_next5yrs,
    zero_tllage_in2019,continuouscropping_in2019,plowgreencrops_in2019,hvewintercrops_in2019, 
    rotationalgrazing_in2019,infield_wintergrazing_in2019, shelterbelts_in2019 

FROM df4
")
view(crop_cultivation)

#group by province
crop_cultivation_prov <-  tbl_summary(
  crop_cultivation,
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
  save_as_docx(path = "output/crop_cultivation_province.docx")

#group by convertedwl_past5years
crop_cultivation_conv <-  tbl_summary(
  crop_cultivation,
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
  save_as_docx(path = "output/crop_cultivation_converted.docx")

