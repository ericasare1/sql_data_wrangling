
if(!require(pacman)) {
  install.packages("pacman")
  library(pacman)
}

#load
p_load(tidyverse,gtsummary,flextable)

df4 <- read.csv("data/processed.csv")

demographic <- sqldf("
SELECT
      responseid, province, converted_wetland, nolandwithwetlandconfchoice,
      sex,age_18_24,age_25_34,age_35_44,age_45_54,age_55_64,age_65_74,age_75more,age_noresponse,    --key demographic info
      no_schooling, highschool,some_posysecondary,vocationa_diploma,university_degree,donot_know,
      prop_hhincome_farming,years_farmoperatedfarm, have_children,childrenlikely_takeover,
      sole_proprietorship,partnership,familycorporation,nonfam_corporation 

FROM df4
")
view(demographic)

#group by province
demo_table <-  tbl_summary(
    demographic,
    by = province,
    type = all_continuous() ~ "continuous2",
    statistic = all_continuous() ~ c( "{mean} ({sd})", 
                                      "{min}, {max}"),
    missing = "no"
  ) %>%
  add_n() %>% # add column with total number of non-missing observations
  #add_p() %>% # test for a difference between groups
  modify_header(label = "**Variable**") %>% # update the column header
  as_flex_table() %>%
  save_as_docx(path = "output/demo_province.docx")

#group by convertedwl_past5years
demo_converted <-  tbl_summary(
  demographic,
  by = converted_wetland,
  type = all_continuous() ~ "continuous2",
  statistic = all_continuous() ~ c( "{mean} ({sd})", 
                                    "{min}, {max}"),
  missing = "no"
) %>%
  add_n() %>% # add column with total number of non-missing observations
  #add_p() %>% # test for a difference between groups
  modify_header(label = "**Variable**") %>% # update the column header
  as_flex_table() %>%
  save_as_docx(path = "output/demo_summ_converted.docx")

#group by nochoice
demo_nochoice <-  tbl_summary(
  demographic,
  by = nolandwithwetlandconfchoice,
  type = all_continuous() ~ "continuous2",
  statistic = all_continuous() ~ c( "{mean} ({sd})", 
                                    "{min}, {max}"),
  missing = "no"
) %>%
  add_n() %>% # add column with total number of non-missing observations
  #add_p() %>% # test for a difference between groups
  modify_header(label = "**Variable**") %>% # update the column header
  as_flex_table() %>%
  save_as_docx(path = "output/demo_summ_nochoice.docx")
