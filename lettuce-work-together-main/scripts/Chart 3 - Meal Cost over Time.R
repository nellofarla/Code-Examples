# Brielle's Chart

# Load packages
library(tidyverse)
library(ggplot2)
library(readxl)

fa_2018 <- read_excel("DATA/Feeding America Data/MMG2020_2018Data_ToShare.xlsx",
  skip = 1, sheet = "2018 State"
)

meal_insecurity <- select(fa_2018,
  state = "State",
  food_insecurity = "2018 Food Insecurity Rate",
  meal_cost = "2018 Cost Per Meal"
)

chart <- ggplot(meal_insecurity, aes(meal_cost, food_insecurity)) +
  geom_point() +
  labs(
    title = "2018 Food Insecurity Rate and Meal Cost",
    y = "Food Insecurity Rate",
    x = "Meal Cost $"
  )