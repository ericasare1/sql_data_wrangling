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
select *
From (
      Select * 
      From (select REF_DATE AS year, GEO as province, VALUE AS value, `Succession planning` AS succession
            from farm_succession
            where GEO = 'Saskatchewan [PR470000000]' 
              OR GEO = 'Alberta [PR480000000]' OR GEO = 'Manitoba [PR460000000]' 
            )
      Where year = 2016)
where succession !='All farms reporting a succession plan' 
")

view(farm_succession2)

farm_succession3 <- sqldf(" 

Select province, sum(value) AS totalcase,  
    sum(succ_fammember * value) AS succfammember, 
    sum(succ_nonfammember * value) AS nonsuccfammember

From  (Select *,
    CASE WHEN succession ='Successor(s) - family member(s)' THEN 1 ELSE 0 END AS succ_fammember,  
    CASE WHEN succession ='Successor(s) - non-family member(s)' THEN 1 ELSE 0 END AS succ_nonfammember  
    
  From farm_succession2)
  
group by province
  
")

succession_proportions <-sqldf("
                      Select *, round(100*(succfammember/totalcase),2) As perc_succfammember, 
                              round(100*(nonsuccfammember/totalcase),2) AS perc_nonsuccfammember 
                      From farm_succession3
                        ")
view(succession_proportions)

write.csv(succession_proportions, "data/farm_succession.csv")

