# GABRIELLA ALONSO
# Summary Information

# Load packages
library(snakecase)
library(tidyverse)
library(dplyr)
library(readxl)
library(plyr)

# Load data

fa_2018 <- read_excel("DATA/Feeding America Data/MMG2020_2018Data_ToShare.xlsx",
  skip = 1, sheet = "2018 State"
)

# Pull the state with the highest food insecurity rate in 2018
state_max_insecurity <- fa_2018 %>%
  select(`State Name`, `2018 Food Insecurity Rate`) %>%
  filter(`2018 Food Insecurity Rate` == max(`2018 Food Insecurity Rate`,
    na.rm = T
  )) %>%
  pull(`State Name`)
# Mississippi

# Pull the state with the lowest food insecurity rate in 2018
state_min_insecurity <- fa_2018 %>%
  select(`State Name`, `2018 Food Insecurity Rate`) %>%
  filter(`2018 Food Insecurity Rate` == min(`2018 Food Insecurity Rate`,
    na.rm = T
  )) %>%
  pull(`State Name`)
# North Dakota

# Pull average number of people who are food insecure in the US in 2018
# The data included WA DC as a state, which is why I divided by 51
avg_num_food_insecure <- round(
  (sum(fa_2018$`# of Food Insecure Persons in 2018`)) / 51
)
# about 782,796 food insecure people per state

# Function that compares the national number of children who are food insecure
# to the national number of adults who are food insecure
prop_food_insecure <- (sum(fa_2018$`# of Food Insecure Children in 2018`)) /
  (sum(fa_2018$`# of Food Insecure Persons in 2018`)) %>%
    round(digits = 2)
# 0.31003 or about 30%
# In 2018, for every 10 adults 3 children were food insecure

# Pull the state with the highest meal cost
most_expensive_meal <- fa_2018 %>%
  select(`State Name`, `2018 Cost Per Meal`) %>%
  filter(`2018 Cost Per Meal` == max(`2018 Cost Per Meal`)) %>%
  pull(`State Name`)
# Washington, D.C.

# Pull price of the highest meal
price_most_expensive_meal <- fa_2018 %>%
  select(`State Name`, `2018 Cost Per Meal`) %>%
  filter(`2018 Cost Per Meal` == max(`2018 Cost Per Meal`)) %>%
  pull(`2018 Cost Per Meal`)
# $4.08

# Pull the state with the lowest meal cost
cheapest_meal_2018 <- fa_2018 %>%
  select(`State Name`, `2018 Cost Per Meal`) %>%
  filter(`2018 Cost Per Meal` == min(`2018 Cost Per Meal`)) %>%
  pull(`State Name`)
# Texas

# Pull price of the lowest meal
price_cheapest_meal <- fa_2018 %>%
  select(`State Name`, `2018 Cost Per Meal`) %>%
  filter(`2018 Cost Per Meal` == min(`2018 Cost Per Meal`)) %>%
  pull(`2018 Cost Per Meal`)
# $2.64

# Function that calculates average meal cost in US
# T he data included WA DC as a state, which is why I divided by 51
avg_meal_cost <- (sum(fa_2018$`2018 Cost Per Meal`)) / 51
# 3.089411764

# Function based on budget shortfall to calculate how many meals on average
# are not being consumed due to lack of funding
num_meals_not_consumed <- sum(
  fa_2018$`2018 Weighted Annual Food Budget Shortfall`
) / (avg_meal_cost)
# 6,621,359,520 meals
total_food_insecure <- sum(fa_2018$`# of Food Insecure Persons in 2018`)
# 39,922,630

# Divided by 3 to calculate for 3 meals each day
num_of_meals_missed_by_day <- num_meals_not_consumed / 3
# 2,207,119,840 meals per day

# Divide number of meals by people
num_days_lost <- round(num_of_meals_missed_by_day / total_food_insecure)
# 55.28 days of missed meals due to budget falls
