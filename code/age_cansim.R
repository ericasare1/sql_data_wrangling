# Cleans environment
rm(list=ls(all=TRUE))

install.packages("cansim")
library("cansim")
library("tidyverse")

age <- get_cansim(
  "32-10-0442-01" # land practices
)

view(age)

age2 <- sqldf("

Select * 
From (select REF_DATE AS year, GEO as province, VALUE AS value, `Farm operators per farm` AS farm, Age AS age
      from age
      where GEO = 'Saskatchewan [PR470000000]' 
        OR GEO = 'Alberta [PR480000000]' OR GEO = 'Manitoba [PR460000000]' 
      )
Where year = 2016 AND farm ='Farms with one operator' 
      AND (age = 'under 35 years' OR age = '35 to 54 years' OR age = '55 years and over')
      
")

view(age2)

age3 <- sqldf(" 

Select province, sum(under35 * value) AS ageunder35,  
    sum(age35to54 * value) AS age35to54s, 
    sum(age55andmore * value) AS age55andmore,
    sum(value) As totalcase

From  (Select *,
    CASE WHEN age = 'under 35 years' THEN 1 ELSE 0 END AS under35,  
    CASE WHEN age = '35 to 54 years' THEN 1 ELSE 0 END AS age35to54,  
    CASE WHEN age = '55 years and over' THEN 1 ELSE 0 END AS age55andmore  

  From age2)
  
group by province
  
")
view(age3)

age_proportions <-sqldf("
                      Select province, round(100*(ageunder35/totalcase),2) As perc_ageunder35, 
                              round(100*(age35to54s/totalcase),2) AS perc_age35to54s, round(100*(age55andmore/totalcase),2) AS perc_age55andmore
                      From age3
                        ")
view(age_proportions)

write.csv(age_proportions, "data/age.csv")

