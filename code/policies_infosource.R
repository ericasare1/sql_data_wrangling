
if(!require(pacman)) {
  install.packages("pacman")
  library(pacman)
}

#load
p_load(tidyverse,gtsummary,flextable)

df4 <- read.csv("data/processed.csv")

policies_sourceinfo <- sqldf("
SELECT
    -- <<<<<<<<<<<<How does these policies influence conservation dec>>>>>>>>>>>
    responseid, province, converted_wetland, nolandwithwetlandconfchoice,
    conservationpayment_leasteffective, conservationpayment_mosteffective,
    techassistance_leasteffective,techassistance_mosteffective,
    extensionprog_leasteffective,extensionprog_mosteffective,
    conservationeasement_leasteffective,conservationeasement_mosteffective,
    sustainabilitycert_leasteffective,sustainabilitycert_mosteffective,
    regulation_leasteffective,regulation_mosteffective,
    
    -- <<<<<<<<<<<<<first choice infor for crop prod and conservation<<<<<<<<<<<<
    chem_dealer_cropinfo, seeddealer_cropinfo,
    regagextspecialist_cropinfo, privcropconsultant_cropinfo,
    univsext_cropinfo,commoditygrps_cropinfo,
    seeddealer_conserinfo,
    regagextspecialist_conserinfo,privcropconsultant_conserinfo,
    univsext_conserinfo,commoditygrps_conserinfo
FROM df4
")


#group by province
demo_policies_info1 <-  tbl_summary(
  policies_sourceinfo,
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
  save_as_docx(path = "output/policies_info_summ.docx")

#group by convertedwl_past5years
demo_policies_infoconverted <-  tbl_summary(
  policies_sourceinfo,
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
  save_as_docx(path = "output/policies_info_summ_converted.docx")
