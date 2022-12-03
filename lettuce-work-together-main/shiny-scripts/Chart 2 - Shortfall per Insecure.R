# MAYNARD MAYNARD-ZHANG
# Shiny Application Script
# Budget Shortfall Per Food-Insecure Person by State
# ------------------------------------------------------------------------------
# Load packages
library(tidyverse)
library(ggplot2)
library(readxl)
library(plotly)
library(RColorBrewer)
library(stringr)

# Load data
fa_2012 <- read_excel(
  "DATA/Feeding America Data/MMG2014_2012Data_ToShare.xlsx",
  sheet = "2012 State",
  .name_repair = "universal"
)

fa_2013 <- read_excel(
  "DATA/Feeding America Data/MMG2015_2013Data_ToShare.xlsx",
  sheet = "2013 State",
  .name_repair = "universal"
)

fa_2014 <- read_excel(
  "DATA/Feeding America Data/MMG2016_2014Data_ToShare.xlsx",
  sheet = "2014 State",
  .name_repair = "universal"
)

fa_2015 <- read_excel(
  "DATA/Feeding America Data/MMG2017_2015Data_ToShare.xlsx",
  sheet = "2015 State",
  .name_repair = "universal"
)

fa_2016 <- read_excel(
  "DATA/Feeding America Data/MMG2018_2016Data_ToShare.xlsx",
  sheet = "2016 State",
  .name_repair = "universal"
)

fa_2017 <- read_excel(
  "DATA/Feeding America Data/MMG2019_2017Data_ToShare.xlsx",
  sheet = "2017 State",
  .name_repair = "universal"
)

fa_2018 <- read_excel(
  "DATA/Feeding America Data/MMG2020_2018Data_ToShare.xlsx",
  skip = 1, sheet = "2018 State",
  .name_repair = "universal"
)

# Join all dfs by state
df <- fa_2018 %>% 
  left_join(fa_2017, by = "State.Name") %>% 
  left_join(fa_2016, by = "State.Name") %>% 
  left_join(fa_2015, by = "State.Name") %>% 
  left_join(fa_2014, by = "State.Name") %>% 
  left_join(fa_2013, by = "State.Name") %>% 
  left_join(fa_2012, by = "State.Name")

# Calculate budget shortfall per food-insecure person
shortfall_per_person <- df %>%
  mutate(X2018 = ((..2018.Weighted.Annual.Food.Budget.Shortfall
                                    / ..of.Food.Insecure.Persons.in.2018) %>%
                                     round(digits = 2)))

shortfall_per_person <- shortfall_per_person %>%
  mutate(X2017 = ((..2017.Weighted.Annual.Food.Budget.Shortfall
                   / ..of.Food.Insecure.Persons.in.2017) %>%
                    round(digits = 2)))

shortfall_per_person <- shortfall_per_person %>%
  mutate(X2016 = ((..2016.Weighted.Annual.Food.Budget.Shortfall
                   / ..of.Food.Insecure.Persons.in.2016) %>%
                    round(digits = 2)))

shortfall_per_person <- shortfall_per_person %>%
  mutate(X2015 = ((..2015.Weighted.Annual.Food.Budget.Shortfall
                   / ..of.Food.Insecure.Persons.in.2015) %>%
                    round(digits = 2)))

shortfall_per_person <- shortfall_per_person %>%
  mutate(X2014 = ((..2014.Weighted.Annual.Food.Budget.Shortfall
                   / ..of.Food.Insecure.Persons.in.2014) %>%
                    round(digits = 2)))

shortfall_per_person <- shortfall_per_person %>%
  mutate(X2013 = ((..2013.Weighted.Annual.Food.Budget.Shortfall
                   / ..of.Food.Insecure.Persons.in.2013) %>%
                    round(digits = 2)))

shortfall_per_person <- shortfall_per_person %>%
  mutate(X2012 = ((..2012.Weighted.Annual.Food.Budget.Shortfall
                   / ..of.Food.Insecure.Persons.in.2012) %>%
                    round(digits = 2)))

# Select state and shortfall per person columns
shortfall_per_person <- shortfall_per_person %>% 
  select(State.Name, X2018, X2017, X2016, X2015, X2014, X2013, X2012) %>% 
  # Pivot longer
  pivot_longer(!State.Name, names_to = "year", values_to = "shortfall")

# Take the X out of year names
shortfall_per_person <- shortfall_per_person %>% 
  mutate(year = sub("X", "", shortfall_per_person$year))