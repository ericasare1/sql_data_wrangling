# Cleans environment
rm(list=ls(all=TRUE))

install.packages("cansim")
library("cansim")
library("tidyverse")

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

