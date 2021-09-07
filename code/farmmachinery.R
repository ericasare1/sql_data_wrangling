# Cleans environment
rm(list=ls(all=TRUE))

install.packages("cansim")
library("cansim")
library("tidyverse")

farmmachinery <- get_cansim(
  "32-10-0437-01" # land practices
)

view(farmmachinery)

opermgt2 <- sqldf("

Select * 
From (select REF_DATE AS year, GEO as province, VALUE AS value, `Operating arrangements` bustype
      from opermgt
      where GEO = 'Saskatchewan [PR470000000]' 
        OR GEO = 'Alberta [PR480000000]' OR GEO = 'Manitoba [PR460000000]' 
      )
Where year = 2016
")

view(sex2)

opermgt3 <- sqldf(" 

Select province,  
    sum(sole * value) AS sole_prop, 
    sum(partner * value) AS partnership,
    sum(familycorp * value) As familycorporation,
    sum(nonfarmcorp * value) As nonfarmcorpoation,
    sum(value) As totalfarmers

From  (Select *,
    CASE WHEN bustype ='Sole proprietorship' THEN 1 ELSE 0 END AS sole,  
    CASE WHEN bustype ='Partnership without a written agreement' OR bustype ='Partnership with a written agreement' THEN 1 ELSE 0 END AS partner,  
    CASE WHEN bustype ='Family corporation' THEN 1 ELSE 0 END AS familycorp,  
    CASE WHEN bustype ='Non-family corporation' THEN 1 ELSE 0 END AS nonfarmcorp  

  From opermgt2)
  
group by province
  
")
view(opermgt3)

write.csv(opermgt3, "data/businesstype.csv")

