


df4 <- read.csv("data/processed.csv")

demographic <- sqldf("
SELECT
      responseid, respid, status, province, converted_wetland, 
      sex,age_18_24,age_25_34,age_35_44,age_45_54,age_55_64,age_65_74,age_75more,age_noresponse,    --key demographic info
      no_schooling, highschool,some_posysecondary,vocationa_diploma,university_degree,donot_know,
      prop_hhincome_farming,years_farmoperatedfarm, have_children,childrenlikely_takeover

FROM df4
")
view(demographic)
