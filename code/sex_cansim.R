# Cleans environment
rm(list=ls(all=TRUE))

install.packages("cansim")
library("cansim")
library("tidyverse")

sex <- get_cansim(
  "32-10-0441-01" # land practices
)

view(sex)


sqldf("
      select distinct(Technologies)
      From farmtech_use
      ")

sex2 <- sqldf("

Select * 
From (select REF_DATE AS year, GEO as province, VALUE AS value, `Farm operators per farm` AS farm, Sex AS sex
      from sex
      where GEO = 'Saskatchewan [PR470000000]' 
        OR GEO = 'Alberta [PR480000000]' OR GEO = 'Manitoba [PR460000000]' 
      )
Where year = 2016
")

view(sex2)

sex3 <- sqldf(" 

Select province,  
    sum(males * value) AS males, 
    sum(females * value) AS females,
    sum(onefarmer * value) As totalonecasefarmers

From  (Select *,
    CASE WHEN farm ='Farms with one operator' AND sex = 'Males' THEN 1 ELSE 0 END AS males,  
    CASE WHEN farm ='Farms with one operator' AND sex = 'Females' THEN 1 ELSE 0 END AS females,  
    CASE WHEN farm ='Farms with one operator' THEN 1 ELSE 0 END AS onefarmer 
    
  From sex2)
  
group by province
  
")
view(sex3)

write.csv(age3, "data/sex.csv")

