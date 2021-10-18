
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
      sex,
      CASE WHEN age_18_24 = 1 OR age_25_34 = 1 THEN 1 ELSE 0 END AS under35,
      CASE WHEN age_35_44 = 1 OR age_45_54 = 1 THEN 1 ELSE 0 END AS betwn35to54,
      CASE WHEN age_55_64 = 1 OR age_65_74 = 1 OR age_75more = 1 THEN 1 ELSE 0 END AS over54,
      no_schooling, highschool,some_posysecondary,vocationa_diploma,university_degree,donot_know,
      prop_hhincome_farming,years_farmoperatedfarm,
      have_children,childrenlikely_takeover,sole_proprietorship,partnership,familycorporation,nonfam_corporation 

FROM df4
") %>% as.tibble()
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
  save_as_docx(path = "output/demo_province_9_9.docx")

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
  save_as_docx(path = "output/demo_summ_converted_09_09.docx")

