# Cleans environment
rm(list=ls(all=TRUE))

install.packages("cansim")
library("cansim")
library("tidyverse")

farmtech_use <- get_cansim(
  "32-10-0446-01" # land practices
)

view(farmtech_use)


sqldf("
      select distinct(Technologies)
      From farmtech_use
      ")

farmtech_use2 <- sqldf("

Select * 
From (select REF_DATE AS year, GEO as province, VALUE AS value, Technologies AS tech
      from farmtech_use
      where GEO = 'Saskatchewan [PR470000000]' 
        OR GEO = 'Alberta [PR480000000]' OR GEO = 'Manitoba [PR460000000]' 
      )
Where year = 2016
")

view(farmtech_use2)

farmtech_use3 <- sqldf(" 

Select province, sum(auto_steer * value) AS num_autosteer,  
    sum(gps * value) AS num_gps, 
    sum(gpsmapping_egsoiltest * value) AS num_gpsmapping,
    sum(value) As totaltechuse

From  (Select *,
    CASE WHEN tech ='Automated steering (auto-steer)' THEN 1 ELSE 0 END AS auto_steer,  
    CASE WHEN tech ='GPS technology' THEN 1 ELSE 0 END AS gps,  
    CASE WHEN tech ='GIS mapping (e.g., soil mapping)' THEN 1 ELSE 0 END AS gpsmapping_egsoiltest 
    
  From farmtech_use2)
  
group by province
  
")
view(farmtech_use3)

write.csv(farmtech_use3, "data/farmtech_use.csv")

