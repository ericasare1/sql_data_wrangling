# Cleans environment
rm(list=ls(all=TRUE))

install.packages("cansim")
library("cansim")
library("tidyverse")
library("sqldf")

sex <- get_cansim(
  "32-10-0441-01" # land practices
)

view(sex)

sex2 <- sqldf("

Select * 
From (select REF_DATE AS year, GEO as province, VALUE AS value, `Farm operators per farm` AS farm, Sex AS sex
      from sex
      where GEO = 'Saskatchewan [PR470000000]' 
        OR GEO = 'Alberta [PR480000000]' OR GEO = 'Manitoba [PR460000000]' 
        
      )
Where year = 2016 AND farm ='Farms with one operator'
")

view(sex2)

sex3 <- sqldf(" 

Select province,  
    sum(males * value) AS males, 
    sum(females * value) AS females,
    sum(both * value) AS both,
    sum(value) As totalcase

From  (Select *,
    CASE WHEN sex = 'Males' THEN 1 ELSE 0 END AS males,  
    CASE WHEN sex = 'Females' THEN 1 ELSE 0 END AS females,  
    CASE WHEN sex = 'Both sexes' THEN 1 ELSE 0 END AS both 

  From sex2)
  
group by province
  
")

view(sex3)

sex_proportions <-sqldf("
                      Select province, round(100*(males/totalcase),2) As perc_males, 
                              round(100*(females/totalcase),2) AS perc_females, round(100*(both/totalcase),2) AS perc_both
                      From sex3
                        ")
view(sex_proportions)
write.csv(sex_proportions, "data/sex.csv")

