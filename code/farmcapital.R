# Cleans environment
rm(list=ls(all=TRUE))

install.packages("cansim")
library("cansim")
library("tidyverse")

farmcapital <- get_cansim(
  "32-10-0435-01" # land practices
)

view(farmcapital)
