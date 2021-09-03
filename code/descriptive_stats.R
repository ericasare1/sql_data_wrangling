# Cleans environment
rm(list=ls(all=TRUE))

install.packages("cansim")
library("cansim")
library("tidyverse")
library("sqldf")


#read in exeldata
producer_chact = read_csv("data/surveydata.csv")

producer_chact = producer_chact %>%
  select(responseid, respid, status, md_ca_alpha_province, q1_owned_1: q5_2, q12:q39)
view(producer_chact)


df1 <- sqldf("select 
                  responseid, respid, status, md_ca_alpha_province AS province,
                  q1_owned_1 AS cropland_owned, q1_owned_2 AS hayland_owned, q1_owned_3 AS pastland_owned,
                  q1_rented_1 AS cropland_rented, q1_rented_2 AS hayland_rented, q1_rented_3 AS pastland_rented, totalacres,
                  q2_1 AS canola, q2_2 AS barley, q2_3 AS rye, q2_4 AS spring_wheat, q2_5 AS beans, q2_6 AS peas,q2_7 AS flaxseed, 
                  q2_8 AS lentil, q2_9 AS soybeans, q2_10 AS corn, q2_11 AS oats, q2_12 AS sunflower, q2_13 AS others, 
                  q3_1 AS auto_guidance, q3_2 AS gps, q3_3 AS vriable_rate, q3_4 AS drones, q3_5 AS soil_test, q3_6 AS slow_release_fert,
                  q4 AS land_purchase_decision, q5_1 AS num_permanent_wl, q5_2 AS num_seasonal_wl, 
                  CASE WHEN q14a = 1 THEN 1 ELSE 0 END AS own_eqdwl,
                  CASE WHEN q14a = 2 THEN 1 ELSE 0 END AS no_rent_eqdwl,
                  CASE WHEN q14a = 3 THEN 1 ELSE 0 END AS no_own_rent_eqdwl,
                  q14b_1 AS own_scrapper, q14b_2 AS own_trackhoe, q14b_3 AS own_ditch_machine, q14b_4 AS own_tile_plow, q14b_5 AS own_other,
                  CASE WHEN q15 = 1 THEN 1 ELSE 0 END AS two_out_ten,
                  CASE WHEN q15 = 2 THEN 1 ELSE 0 END AS four_out_ten,
                  CASE WHEN q15 = 3 THEN 1 ELSE 0 END AS six_out_ten,
                  CASE WHEN q15 = 4 THEN 1 ELSE 0 END AS eight_out_ten,
                  CASE WHEN q15 = 5 THEN 1 ELSE 0 END AS ten_out_ten,
                  CASE WHEN q15 = 6 THEN 1 ELSE 0 END AS dont_farm_seasonal_wl,
                  CASE WHEN q16 = 1 THEN 1 ELSE 0 END AS twenty_five_abav,
                  CASE WHEN q16 = 1 THEN 1 ELSE 0 END AS twenty_five_abav,
                  CASE WHEN q16 = 2 THEN 1 ELSE 0 END AS ten_abav,
                  CASE WHEN q16 = 3 THEN 1 ELSE 0 END AS about_average,
                  CASE WHEN q16 = 4 THEN 1 ELSE 0 END AS ten_belav,
                  CASE WHEN q16 = 5 THEN 1 ELSE 0 END AS twenty_five_belav,
                  CASE WHEN q17_1 = 1 THEN 1 ELSE 0 END AS converted_bush,
                  CASE WHEN q17_1 = 1 THEN 1 ELSE 0 END AS converted_bush,
                  CASE WHEN q17_2 = 1 THEN 1 ELSE 0 END AS converted_wetland,
                  CASE WHEN q17_3 = 1 THEN 1 ELSE 0 END AS converted_nativegrassland,
                  q18_1 AS perc_wl_potent_convert,
                  q18ba_1 AS num_wl_convert,
                  q18ba_2 AS num_wlacres_convert,
                  q18bb_1 AS draincost_peracre, 
                  q19_1 AS rate_increasedeff,
                  q19_2 AS rate_landquality, 
                  q19_3 AS rate_draincost, 
                  q19_4 AS rate_effonwaterqual,
                  q19_5 AS rate_effonnearbyflooding,
                  q19_6 AS rate_effsurrlandacc,
                  q19_7 AS rate_delayedplanting,
                  q19_8 AS rate_weedcontrol,
                  q19_9 AS rate_wildlifehabitat,
                  CASE WHEN q20 = 1 THEN 1 ELSE 0 END AS restwl5perland_20percpremium,
                  CASE WHEN q21 = 1 THEN 1 ELSE 0 END AS participatewlconser_anypremium,
                  CASE WHEN q22 = 1 THEN 1 ELSE 0 END AS have_environfarmplan,
                  q24_1 AS import_waterquality_ess,
                  q24_2 AS import_floodcontrol_ess,
                  q24_3 AS import_erosioncontrol_ess,
                  q24_4 AS import_wildlifehab_ess,
                  q24_5 AS import_carbonstorage_ess,
                  q24_6 AS import_recreation_edu_ess,
                  q25_1 AS numwl_trendfromknowledge,
                  q25_2 AS qualitywl_trendfromknowledge,
                  q26_1 AS conservationpayment_rankagconserprg, 
                  q26_2 AS techassistance_rankagconserprg, 
                  q26_3 AS extensionprog_rankagconserprg, 
                  q26_4 AS conservationeasement_rankagconserprg, 
                  q26_5 AS sustainabilitycert_rankagconserprg, 
                  q26_6 AS regulation_rankagconserprg, 
                  CASE 
                    WHEN q27 = 1 THEN 'Ag chemical Dealer'
                    WHEN q27 = 2 THEN 'Seed Dealer'
                    WHEN q27 = 3 THEN 'Regional Ag Ext Specialist'
                    WHEN q27 = 4 THEN 'Private Crop Consultant'
                    WHEN q27 = 5 THEN 'University Extension'
                    WHEN q27 = 6 THEN 'Commodity Groups'
                    WHEN q27 = 7 THEN 'Other'
                  END AS firstchoice_cropinfo,
                  CASE 
                    WHEN q28 = 1 THEN 'Ag chemical Dealer'
                    WHEN q28 = 2 THEN 'Seed Dealer'
                    WHEN q28 = 3 THEN 'Regional Ag Ext Specialist'
                    WHEN q28 = 4 THEN 'Private Crop Consultant'
                    WHEN q28 = 5 THEN 'University Extension'
                    WHEN q28 = 6 THEN 'Commodity Groups'
                    WHEN q28 = 7 THEN 'Other'
                  END AS firstchoice_cropinfo,
                  CASE WHEN q29 = 1 THEN 1 ELSE 0 END AS sole_proprietorship,
                  CASE WHEN q29 = 2 THEN 1 ELSE 0 END AS partnership,
                  CASE WHEN q29 = 3 THEN 1 ELSE 0 END AS familycorporation,
                  CASE WHEN q29 = 4 THEN 1 ELSE 0 END AS nonfam_corporation,
                  CASE WHEN q30_1 = 1 THEN 1 ELSE 0 END AS zero_tllage_in2019,
                  CASE WHEN q30_2 = 1 THEN 1 ELSE 0 END AS continuouscropping_in2019,
                  CASE WHEN q30_3 = 1 THEN 1 ELSE 0 END AS plowgreencrops_in2019,
                  CASE WHEN q30_4 = 1 THEN 1 ELSE 0 END AS hvewintercrops_in2019,
                  CASE WHEN q30_5 = 1 THEN 1 ELSE 0 END AS rotationalgrazing_in2019,
                  CASE WHEN q30_6 = 1 THEN 1 ELSE 0 END AS infield_wintergrazing_in2019,
                  CASE WHEN q30_7 = 1 THEN 1 ELSE 0 END AS shelterbelts_in2019,
                  CASE WHEN q32 = 1 THEN 1 ELSE 0 END AS sex,
                  CASE WHEN q33 = 1 THEN 1 ELSE 0 END AS age_18_24,
                  CASE WHEN q33 = 2 THEN 1 ELSE 0 END AS age_25_34,
                  CASE WHEN q33 = 3 THEN 1 ELSE 0 END AS age_35_44,
                  CASE WHEN q33 = 4 THEN 1 ELSE 0 END AS age_45_54,
                  CASE WHEN q33 = 5 THEN 1 ELSE 0 END AS age_55_64,
                  CASE WHEN q33 = 6 THEN 1 ELSE 0 END AS age_65_74,
                  CASE WHEN q33 = 7 THEN 1 ELSE 0 END AS age_75more,
                  CASE WHEN q33 = 8 THEN 1 ELSE 0 END AS age_noresponse,
                  CASE WHEN q34 = 1 THEN 1 ELSE 0 END AS no_schooling,
                  CASE WHEN q34 = 2 THEN 1 ELSE 0 END AS highschool,
                  CASE WHEN q34 = 3 THEN 1 ELSE 0 END AS some_posysecondary,
                  CASE WHEN q34 = 4 THEN 1 ELSE 0 END AS vocationa_diploma,
                  CASE WHEN q34 = 5 THEN 1 ELSE 0 END AS university_degree,
                  CASE WHEN q34 = 6 THEN 1 ELSE 0 END AS donot_know,
                  q35_1 AS prop_hhincome_farming,
                  q36_1 AS years_farmoperatedfarm,
                  CASE WHEN q37 = 1 THEN 1 ELSE 0 END AS have_children,
                  CASE WHEN q38 = 1 THEN 1 ELSE 0 END AS childrenlikely_takeover
      From producer_chact
      ")
view(df1)

















farmtype_edu <- get_cansim(
  "32-10-0024-01" # number of farm operators by farm typeand education status
 # language = "english",
 # refresh = FALSE,
#  timeout = 200,
#  factors = TRUE,
#  default_month = "07",
 # default_day = "01"
)

view(farmtype_edu)
inner

farmtype_inc <- get_cansim(
  "32-10-0027-01",  # number of farm operators by farm typeand education status
 
)

farmtype_hhinc <- get_cansim(
  "32-10-0030-01"  # number of farm operators by farm typeand education status
)

mar_sex_age <- get_cansim(
  "32-10-0004-01"  # number of farm operators by farm typeand education status
)

farmarrangement_hhinc <- get_cansim(
  "32-10-0035-01"  # number of farm operators by farm typeand education status
)

incsource_incclass <- get_cansim(
  "32-10-0041-01",  # number of farm operators by farm typeand education status
)

farmtype_size <- get_cansim(
  "32-10-0064-01",  # number of farm operators by farm typeand education status
)

view(farmtype_edu)
farmtype_edu <- farmtype_edu %>%
  rename(education = `Highest level of educational attainment`,
         farmtype = `Farm type`)
  distinct(GEO)


install.packages("sqldf")
library(sqldf)



sqldf("select distinct(GEO)
      from farmtype_edu
      where GEO == 'Manitoba' OR GEO == 'Alberta'
      ")

prairie <- sqldf("SELECT REF_DATE as date, GEO as geo, VALUE as value, `Highest level of educational attainment` as education, `Farm type` as farmtype
      FROM farmtype_edu
      WHERE GEO = 'Manitoba' OR GEO = 'Alberta' OR GEO = 'Saskatchewan'
      ")

prairies1 <- sqldf(

    "
    Select date, geo, value, farm_cases, edu_cases
    From (
    
    Select * , 
        CASE 
          WHEN farmtype = 'All farm types' THEN 1
          WHEN farmtype = 'Beef cattle ranching and farming, including feedlots  [112110]' THEN 2
          WHEN farmtype = 'Dairy cattle and milk production  [112120]' THEN 3
          WHEN farmtype = 'Hog and pig farming  [1122]' THEN 4
          WHEN farmtype = 'Poultry and egg production  [1123]' THEN 5
          WHEN farmtype = 'Sheep and goat farming  [1124]'  THEN 6
          WHEN farmtype = 'Other animal production [1129]' THEN 7
          WHEN farmtype = 'Oilseed and grain farming [1111]' THEN 8
          WHEN farmtype = 'Vegetable and melon farming [1112]' THEN 9
          WHEN farmtype = 'Fruit and tree nut farming [1113]' THEN 10
          WHEN farmtype = 'Greenhouse, nursery and floriculture production [1114]' THEN 11
          ELSE 0
        END AS farm_cases,
       
       Case 
          When education = 'All educational attainments' Then 0
          When education = 'No certificate, diploma or degree' Then 1
          When education = 'Secondary (high) school diploma or equivalency certificate' Then 2
          When education ='Apprenticeship or trades certificate or diploma' Then 3
          When education = 'College, CEGEP or other non-university certificate or diploma' Then 4
          When education = 'University certificate or diploma below bachelor level' Then 5
          When education = 'University certificate, diploma or degree at bachelor level or above' Then 6
        End As edu_cases
      
      From prairie)
      
      ")

view(prairies1)

prairie2 <- sqldf("select REF_DATE as date, GEO as geo, VALUE as value, 
                   `Highest level of educational attainment` as edu_level,  `Farm type` as farm_type,
                   `Highest level of educational attainment` || `Farm type` as farm_edu
      from farmtype_edu
      where GEO = 'Manitoba' OR GEO = 'Alberta' OR GEO = 'Saskatchewan'
      ")
# AND value  IS NOT \"NA\"
view(prairie2)

sqldf("select  sum(value) as total
      from farmtype_edu
      where GEO = 'Manitoba' 
      ")

sqldf("select sum(VALUE/2 as value
      from prairie2
      where GEO = 'Manitoba' 
      group by geo
      ")






