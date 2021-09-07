# Cleans environment
rm(list=ls(all=TRUE))

install.packages("cansim")
library("cansim")
library("tidyverse")

age <- get_cansim(
  "32-10-0442-01" # land practices
)

view(age)


sqldf("
      select distinct(Technologies)
      From farmtech_use
      ")

age2 <- sqldf("

Select * 
From (select REF_DATE AS year, GEO as province, VALUE AS value, `Farm operators per farm` AS farm, Age AS age
      from age
      where GEO = 'Saskatchewan [PR470000000]' 
        OR GEO = 'Alberta [PR480000000]' OR GEO = 'Manitoba [PR460000000]' 
      )
Where year = 2016
")

view(farmtech_use2)

age3 <- sqldf(" 

Select province, sum(under35 * value) AS ageunder35,  
    sum(age35to54 * value) AS age35to54s, 
    sum(age55andmore * value) AS age55andmore,
    sum(onefarmer * value) As totalonecasefarmers

From  (Select *,
    CASE WHEN farm ='Farms with one operator' AND age = 'under 35 years' THEN 1 ELSE 0 END AS under35,  
    CASE WHEN farm ='Farms with one operator' AND age = '35 to 54 years' THEN 1 ELSE 0 END AS age35to54,  
    CASE WHEN farm ='Farms with one operator' AND age = '55 years and over' THEN 1 ELSE 0 END AS age55andmore,  
    CASE WHEN farm ='Farms with one operator' THEN 1 ELSE 0 END AS onefarmer 
    
  From age2)
  
group by province
  
")
view(age3)

write.csv(age3, "data/age.csv")

