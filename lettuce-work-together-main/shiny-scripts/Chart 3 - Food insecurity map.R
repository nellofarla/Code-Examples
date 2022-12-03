library(readxl)
library(shiny)
library(usmap)
library(plotly)
library(maps)
library(dplyr)
library(tidyverse)

# Read excel files
fa_2009 <- read_excel(
  "DATA/Feeding America Data/MMG2011_2009Data_ToShare.xlsx",
  sheet = "State", .name_repair = "universal"
)
fa_2010 <- read_excel(
  "DATA/Feeding America Data/MMG2012_2010Data_ToShare.xlsx",
  sheet = "State", .name_repair = "universal"
)
fa_2011 <- read_excel(
  "DATA/Feeding America Data/MMG2013_2011Data_ToShare.xlsx",
  sheet = "2011 State ", .name_repair = "universal"
)
fa_2012 <- read_excel(
  "DATA/Feeding America Data/MMG2014_2012Data_ToShare.xlsx",
  sheet = "2012 State", .name_repair = "universal"
)
fa_2013 <- read_excel(
  "DATA/Feeding America Data/MMG2015_2013Data_ToShare.xlsx",
  sheet = "2013 State", .name_repair = "universal"
)
fa_2014 <- read_excel(
  "DATA/Feeding America Data/MMG2016_2014Data_ToShare.xlsx",
  sheet = "2014 State", .name_repair = "universal"
)
fa_2015 <- read_excel(
  "DATA/Feeding America Data/MMG2017_2015Data_ToShare.xlsx",
  sheet = "2015 State", .name_repair = "universal"
)
fa_2016 <- read_excel(
  "DATA/Feeding America Data/MMG2018_2016Data_ToShare.xlsx",
  sheet = "2016 State", .name_repair = "universal"
)
fa_2017 <- read_excel(
  "DATA/Feeding America Data/MMG2019_2017Data_ToShare.xlsx",
  sheet = "2017 State", .name_repair = "universal"
)
fa_2018 <- read_excel(
  "DATA/Feeding America Data/MMG2020_2018Data_ToShare.xlsx",
  skip = 1, sheet = "2018 State", .name_repair = "universal"
)


# Create dataframes with State and Food.Insecurity.Rate only
high_threshold_09 <- fa_2009 %>% summarize(
  State = State.Name, X2009 = ..FI...High.Threshold
)
high_threshold_10 <- fa_2010 %>% summarize(
  State,
  X2010 = ..FI...High.Threshold
)
high_threshold_11 <- fa_2011 %>% summarize(
  State = County..State, X2011 = ..FI...High.Threshold
)
high_threshold_12 <- fa_2012 %>% summarize(
  State,
  X2012 = ..FI...High.Threshold
)
high_threshold_13 <- fa_2013 %>% summarize(
  State,
  X2013 = ..FI...High.Threshold
)
high_threshold_14 <- fa_2014 %>% summarize(
  State,
  X2014 = ..FI...High.Threshold
)
high_threshold_15 <- fa_2015 %>% summarize(
  State,
  X2015 = ..FI...High.Threshold
)
high_threshold_16 <- fa_2016 %>% summarize(
  State,
  X2016 = ..FI...High.Threshold
)
high_threshold_17 <- fa_2017 %>% summarize(
  State,
  X2017 = ..FI...High.Threshold
)
high_threshold_18 <- fa_2018 %>% summarize(
  State,
  X2018 = ..FI...High.Threshold
)

# merge all the data frames 
decade <- left_join(high_threshold_09, high_threshold_10, by = "State") %>%
  left_join(high_threshold_11, by = "State") %>%
  left_join(high_threshold_12, by = "State") %>%
  left_join(high_threshold_13, by = "State") %>%
  left_join(high_threshold_14, by = "State") %>%
  left_join(high_threshold_15, by = "State") %>%
  left_join(high_threshold_16, by = "State") %>%
  left_join(high_threshold_17, by = "State") %>%
  left_join(high_threshold_18, by = "State")

decade$State <- 
  state.name[match(decade$State, state.abb)]
decade$State <- tolower(decade$State)

df <- decade %>%
  pivot_longer(!State, names_to = "year", values_to = "high_threshold") 

state_shape <- map_data("state") %>%
  rename(State = region) %>%
  left_join(df, by = "State")

map_data <- left_join(state_shape, df)

map_data <- map_data %>%
  mutate(year = sub("X", "", map_data$year))

# data_year_filtered <- filter(map_data, year == "2009")
# 
# us_map <- ggplot(data_year_filtered) +
#   geom_polygon(
#     mapping = aes(x = long, y = lat, group = group, fill = high_threshold),
#     color = "white", 
#     size = .1        
#   ) +
#   coord_map() +
#   scale_fill_continuous(low = "White", high = "Red") +
#   labs(fill = "Percentage of Food Insecure Population Above High Poverty Threshold") +
#   theme_bw() + 
#   theme(
#     axis.line = element_blank(),
#     axis.text = element_blank(),
#     axis.ticks = element_blank(),
#     axis.title = element_blank(),
#     plot.background = element_blank(),
#     panel.grid.major = element_blank(),
#     panel.grid.minor = element_blank(),
#     panel.border = element_blank()
#   )