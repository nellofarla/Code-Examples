# MAYNARD MAYNARD-ZHANG
# Web Report
# Budget Shortfall Per Food-Insecure Person by State in 2018
# ------------------------------------------------------------------------------
# Load packages
library(tidyverse)
library(ggplot2)
library(readxl)

# Load data
fa_2018 <- read_excel("DATA/Feeding America Data/MMG2020_2018Data_ToShare.xlsx",
  skip = 1, sheet = "2018 State"
)

# Budget shortfall per food-insecure person
fa_2018 <- fa_2018 %>%
  select(
    `State Name`,
    `2018 Weighted Annual Food Budget Shortfall`,
    `# of Food Insecure Persons in 2018`
  ) %>%
  mutate(shortfall_per_insecure = ((`2018 Weighted Annual Food Budget Shortfall`
  / `# of Food Insecure Persons in 2018`) %>% round(digits = 2)))

# Top 5 shortfalls
shortfall_top_5 <- fa_2018 %>%
  select(`State Name`, shortfall_per_insecure) %>%
  arrange(desc(shortfall_per_insecure)) %>%
  top_n(5, shortfall_per_insecure)

# Bottom 5 shortfalls
shortfall_bottom_5 <- fa_2018 %>%
  select(`State Name`, shortfall_per_insecure) %>%
  arrange(desc(shortfall_per_insecure)) %>%
  top_n(-5, shortfall_per_insecure)

# Join top and bottom 5
shortfalls <- full_join(shortfall_top_5, shortfall_bottom_5,
  by = c("State Name", "shortfall_per_insecure")
)

# Create visualization - bar graph
# 1 categorical (state) and 1 continuous (shortfall) variable
chart2 <- ggplot(data = shortfalls) +
  geom_col(mapping = aes(
    x = reorder(`State Name`, shortfall_per_insecure),
    y = shortfall_per_insecure,
    fill = `State Name`
  )) +
  labs(
    title = "Top 5 and Bottom 5 State Shortfalls",
    x = "State",
    y = "Shortfall ($)"
  ) +
  coord_flip() +
  theme(legend.position = "none")
