# Cleans environment
rm(list=ls(all=TRUE))

install.packages("cansim")
library("cansim")
library("tidyverse")

hay_fieldcrops <- get_cansim(
  "32-10-0416-01" # land practices
)

view(hay_fieldcrops)


sqldf("
      select distinct(`Hay and field crops`)
      From hay_fieldcrops
      ")

hay_fieldcrops2 <- sqldf("


Select * 
From (select REF_DATE AS year, GEO as province, VALUE AS value, `Hay and field crops` AS fieldcrops, `Unit of measure` as units
      from hay_fieldcrops
      where GEO = 'Saskatchewan [PR470000000]' 
        OR GEO = 'Alberta [PR480000000]' OR GEO = 'Manitoba [PR460000000]' 
      )
Where year = 2016
")
view(hay_fieldcrops2)

hay_fieldcrops3 <- sqldf(" 

Select province, sum(springwheat * value) AS springwheat_acres,
    sum(oats * value) AS oats_acres,  
    sum(barley * value) AS barley_acres, sum(corn * value) AS corn_acres, 
    sum(rye * value) AS rye_acres, sum(canola * value) AS canola_acres,
    sum(peas * value) AS peas_acres, sum(lentils * value) AS lentils_acres,
    sum(beans * value) AS beans_acres, sum(sunflowers * value) AS sunflowers_acres, 
    sum(value) AS totalcase

 
From  (Select *,
    CASE WHEN fieldcrops ='Spring wheat (excluding durum)' AND units = 'Acres' THEN 1 ELSE 0 END AS springwheat,  
    CASE WHEN fieldcrops ='Oats' AND units = 'Acres' THEN 1 ELSE 0 END AS oats,
    CASE WHEN fieldcrops ='Barley' AND units = 'Acres' THEN 1 ELSE 0 END AS barley,
    CASE WHEN fieldcrops ='Total corn' AND units = 'Acres' THEN 1 ELSE 0 END AS corn,  
    CASE WHEN fieldcrops ='total rye' AND units = 'Acres' THEN 1 ELSE 0 END AS rye,
    CASE WHEN fieldcrops ='Canola (rapeseed)' AND units = 'Acres' THEN 1 ELSE 0 END AS canola,
    CASE WHEN fieldcrops ='Dry field peas' OR  fieldcrops ='Chick peas' AND units = 'Acres' THEN 1 ELSE 0 END AS peas,
    CASE WHEN fieldcrops ='Lentils' AND units = 'Acres' THEN 1 ELSE 0 END AS lentils,  
    CASE WHEN fieldcrops ='Dry white beans' OR fieldcrops ='Other dry beans' AND units = 'Acres' THEN 1 ELSE 0 END AS beans,
    CASE WHEN fieldcrops ='Sunflowers' AND units = 'Acres' THEN 1 ELSE 0 END AS sunflowers
    
  From hay_fieldcrops2)
  
group by province
  
")

view(hay_fieldcrops3)

acres_proportions <-sqldf("
Select *, round(100*(springwheat_acres/totalcase),2) As perc_springwheat, 
          round(100*(oats_acres/totalcase),2) AS perc_oats, 
          round(100*(corn_acres/totalcase),2) AS perc_corn,
          round(100*(barley_acres/totalcase),2) AS perc_barley, 
          round(100*(rye_acres/totalcase),2) AS perc_rye,
          round(100*(canola_acres/totalcase),2) AS perc_canola, 
          round(100*(peas_acres/totalcase),2) AS perc_peas,
          round(100*(lentils_acres/totalcase),2) AS perc_lentils, 
          round(100*(beans_acres/totalcase),2) AS perc_beans,         
          round(100*(sunflowers_acres/totalcase),2) AS sunflowers         

From hay_fieldcrops3
 ")
view(acres_proportions)

write.csv(acres_proportions, "data/hay_fieldcrops.csv")

