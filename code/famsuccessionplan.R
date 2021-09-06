# Cleans environment
rm(list=ls(all=TRUE))

install.packages("cansim")
library("cansim")
library("tidyverse")

farm_succession <- get_cansim(
  "32-10-0448-01" # land practices
)

view(farm_succession)


sqldf("
      select distinct(`Hay and field crops`)
      From hay_fieldcrops
      ")

farm_succession2 <- sqldf("

Select * 
From (select REF_DATE AS year, GEO as province, VALUE AS value, `Succession planning` AS succession
      from farm_succession
      where GEO = 'Saskatchewan [PR470000000]' 
        OR GEO = 'Alberta [PR480000000]' OR GEO = 'Manitoba [PR460000000]' 
      )
Where year = 2016
")

view(farm_succession2)

farm_succession3 <- sqldf(" 

Select province, sum(report_successionplan * value) AS num_reportsuccessionplan,  
    sum(succ_fammember * value) AS num_succfammember, 
    sum(succ_nonfammember * value) AS num_nonsuccfammember

From  (Select *,
    CASE WHEN succession ='All farms reporting a succession plan' THEN 1 ELSE 0 END AS report_successionplan,  
    CASE WHEN succession ='Successor(s) - family member(s)' THEN 1 ELSE 0 END AS succ_fammember,  
    CASE WHEN succession ='Successor(s) - non-family member(s)' THEN 1 ELSE 0 END AS succ_nonfammember  
    
  From farm_succession2)
  
group by province
  
")
view(farm_succession3)

write.csv(farm_succession3, "data/farm_succession.csv")

