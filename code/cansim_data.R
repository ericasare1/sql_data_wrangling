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

farmtenure <- get_cansim(
  "32-10-0407-01",  # land owned,rented...
)
view(farmtenure)

sqldf("
      select distinct(`Land tenure`)
      From farmtenure
      ")

farmtenure1 <- sqldf("

Select * 
From (select REF_DATE AS year, GEO as province, VALUE AS value, `Land tenure` AS tenure, `Unit of measure` as units
      from farmtenure
      where GEO = 'Saskatchewan [PR470000000]' 
        OR GEO = 'Alberta [PR480000000]' OR GEO = 'Manitoba [PR460000000]' 
      )
Where year = 2016
")

farmtenure2 <- sqldf(" 

Select province, sum(numpeop_totalfarmacres * value) AS num_totfarmacres,
    sum(totalfarmacres * value) AS totfarmacres, sum(acres_owned * value) AS totacresowned, 
    sum(numpeop_acresowned * value) AS numpeopl_acresowned, sum(acres_rented * value) AS totacresrented, 
    sum(numpeop_acresrented * value) AS numpeopl_acresrented
 
From  (Select *,
    CASE WHEN tenure ='Total farm area' AND units = 'Acres' THEN 1 ELSE 0
      END AS totalfarmacres,  --'' for string values `` for wordy columns
    CASE WHEN tenure ='Total farm area' AND units = 'Number of farms reporting' THEN 1 ELSE 0
      END AS numpeop_totalfarmacres,
    CASE WHEN tenure ='Area owned' AND units = 'Acres' THEN 1 ELSE 0
      END AS acres_owned,
    CASE WHEN tenure ='Area owned' AND units = 'Number of farms reporting' THEN 1 ELSE 0
      END AS numpeop_acresowned,  
    CASE WHEN tenure ='Area rented or leased from others' AND units = 'Acres' THEN 1 ELSE 0
      END AS acres_rented,
    CASE WHEN tenure ='Area rented or leased from others' AND units = 'Number of farms reporting' THEN 1 ELSE 0
      END AS numpeop_acresrented
  From farmtenure1)
  
group by province
  
")
view(farmtenure2)
write.csv(farmtenure2, "data/landtenure_cansim.csv")

