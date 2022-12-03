# GABRIELLA ALONSO
# Table of Summary Information


# Load packages
library(tidyverse)
library(dplyr)
library(readxl)
library(plyr)
library(scales)
# Load data
fa_2018 <- read_excel("DATA/Feeding America Data/MMG2020_2018Data_ToShare.xlsx",
  skip = 1, sheet = "2018 State"
)


# Aggregate table focused on the financial aspects of food insecurity
financial_df <- fa_2018 %>%
  select(
    `State Name`, `2018 Cost Per Meal`,
    `2018 Weighted Annual Food Budget Shortfall`
  ) %>%
  group_by(`State Name`) %>%
  mutate(
    `Meals Not Consumed due to Budget Shortfall` =
      `2018 Weighted Annual Food Budget Shortfall` / `2018 Cost Per Meal`
  ) %>%
  mutate(
    `Meals Not Consumed due to Budget Shortfall` =
      number(`Meals Not Consumed due to Budget Shortfall`, big.mark = ",")
  ) %>%
  mutate(
    `2018 Weighted Annual Food Budget Shortfall` =
      number(`2018 Weighted Annual Food Budget Shortfall`, big.mark = ",")
  )

# Pertinent Observations

# Find state with the most meal loss
max_meal_lost <- financial_df %>%
  select(`State Name`, `Meals Not Consumed due to Budget Shortfall`) %>%
  group_by(`Meals Not Consumed due to Budget Shortfall`) %>%
  filter(
    `Meals Not Consumed due to Budget Shortfall` ==
      max(`Meals Not Consumed due to Budget Shortfall`)
  ) %>%
  pull(`State Name`)

# Even though Texas as the cheapest meal cost, it has the highest meal loss due
# to budget shortfalls

# Find State with least meal loss
min_meal_lost <- financial_df %>%
  select(`State Name`, `Meals Not Consumed due to Budget Shortfall`) %>%
  group_by(`Meals Not Consumed due to Budget Shortfall`) %>%
  filter(
    `Meals Not Consumed due to Budget Shortfall` ==
      min(`Meals Not Consumed due to Budget Shortfall`)
  ) %>%
  pull(`State Name`)

# North Dakota continues has both the cheapest meal cost and lowest meal loss
# from budget shortfalls
