# Cleans environment
rm(list=ls(all=TRUE))

install.packages("cansim")
library("cansim")
library("tidyverse")

educationlevel <- get_cansim(
  "32-10-0189-01" # land practices
)

view(educationlevel)

sqldf("
select distinct(`Level of educational attainment`)

From educationlevel
      
      ")

educationlevel2 <- sqldf("

Select REF_DATE AS year, GEO as province, VALUE AS value, `Level of educational attainment` AS edulevel, `Farm operators` AS operators 
from educationlevel
where GEO = 'Saskatchewan'  OR GEO = 'Alberta' OR GEO = 'Manitoba' 

")

view(educationlevel2)
educationlevel3 <- sqldf(" 

Select province,  
    sum(nouniversitydegree * value) AS nodegree, 
    sum(universitydegree * value) AS degree,
    sum(value) AS total

From(

Select *,
    CASE WHEN edulevel ='Operators with no university degree' AND operators = 'On farms with one operator' THEN 1 ELSE 0 END AS nouniversitydegree,  
    CASE WHEN edulevel ='Operators with university degree' AND operators = 'On farms with one operator' THEN 1 ELSE 0 END AS universitydegree  

 From educationlevel2)
  
group by province
  
")
view(educationlevel3)

write.csv(educationlevel3, "data/educationlevel.csv")

