# Load packages
library(dplyr)
library(shiny)
library(plotly)
library(tidyverse)
library(readxl)
library(maps)
library(usmap)
library(ggplot2)
library(RColorBrewer)
library(stringr)
library(mapproj)

# Chart 1 data
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
foodsec_18 <- fa_2018 %>% summarize(
  State,
  X2018 = ..2018.Food.Insecurity.Rate
)
foodsec_17 <- fa_2017 %>% summarize(
  State,
  X2017 = ..2017.Food.Insecurity.Rate
)
foodsec_16 <- fa_2016 %>% summarize(
  State,
  X2016 = ..2016.Food.Insecurity.Rate
)
foodsec_15 <- fa_2015 %>% summarize(
  State,
  X2015 = ..2015.Food.Insecurity.Rate
)
foodsec_14 <- fa_2014 %>% summarize(
  State,
  X2014 = ..2014.Food.Insecurity.Rate
)
foodsec_13 <- fa_2013 %>% summarize(
  State,
  X2013 = ..2013.Food.Insecurity.Rate
)
foodsec_12 <- fa_2012 %>% summarize(
  State,
  X2012 = ..2012.Food.Insecurity.Rate
)
foodsec_11 <- fa_2011 %>% summarize(
  State = County..State, X2011 = ..2011.Food.Insecurity.Rate
)
foodsec_10 <- fa_2010 %>% summarize(
  State,
  X2010 = ..2010.Food.Insecurity.Rate
)
foodsec_09 <- fa_2009 %>% summarize(
  State = State.Name, X2009 = Food.Insecurity.Rate..aggregate.of.counties.
)

# Join as multi-year dataframe
decade <- left_join(foodsec_18, foodsec_17, by = "State") %>%
  left_join(foodsec_16, by = "State") %>%
  left_join(foodsec_15, by = "State") %>%
  left_join(foodsec_14, by = "State") %>%
  left_join(foodsec_13, by = "State") %>%
  left_join(foodsec_12, by = "State") %>%
  left_join(foodsec_11, by = "State") %>%
  left_join(foodsec_10, by = "State") %>%
  left_join(foodsec_09, by = "State")

# Transpose the dataframe with tidyr
decade <- gather(
  decade,
  key = year,
  value = food_insec,
  -State
)

# Remove the prefix "X" from years
decade$year <- substring(decade$year, 2)

# Get the average of food insecurity nationwide each year
us_avg_insec <- decade %>%
  group_by(year) %>%
  dplyr::summarize(mean_food_insec = mean(food_insec))

# Chart 2 data
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

# Chart 3 data
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

# Start shinyServer
server <- function(input, output) {
  # Chart 1 - Line graphs of annual average food insecurity rate 2009 - 2018
  # Rename the name of the column to match with the drop down menu
  us_avg_insec <- rename(us_avg_insec, National = mean_food_insec)

  # Read the Excel file from USDA's Economic Research Service (ERS)
  usda_ers <- read_excel(
    "DATA/foodsecurity_datafile.xlsx",
    sheet = "Food security, all households"
  )

  # Filter the data to those from 2009 - 2018, food insecurity rate by race
  usda_filtered <- usda_ers %>%
    filter(Year == "2009" | Year == "2010" | Year == "2011" |
      Year == "2012" | Year == "2013" | Year == "2014" |
      Year == "2015" | Year == "2016" | Year == "2017" |
      Year == "2018") %>%
    filter(Subcategory == "White non-Hispanic" |
      Subcategory == "Black non-Hispanic" |
      Subcategory == "Hispanic") %>%
    select(year = Year, Subcategory, `Food insecure-Percent`)

  # Divide the food insecurity rate by 100 so it matches the format
  # on the `us_avg_insec` dataframe
  usda_filtered$`Food insecure-Percent` <-
    usda_filtered$`Food insecure-Percent` / 100

  # Convert the year from numeric to character for left join
  usda_filtered$year <- as.character(usda_filtered$year)

  # Transpose the dataframe with tidyr
  usda_filtered <- spread(
    usda_filtered,
    key = Subcategory,
    value = `Food insecure-Percent`
  )

  # Rename the name of the columns to match with the drop down menu
  usda_filtered <- rename(
    usda_filtered,
    Black = `Black non-Hispanic`,
    White = `White non-Hispanic`
  )

  # Join the dataframes into one
  us_avg_insec <- left_join(us_avg_insec, usda_filtered)

  # Render a line plot
  output$line_plot <- renderPlotly({
    plot_ly(
      data = us_avg_insec,
      x = ~year,
      y = ~ us_avg_insec[[input$line_selection]],
      type = "scatter",
      mode = "lines"
    ) %>%
      layout(
        title = paste(
          input$line_selection, "Average Food Insecurity Rate"
        ),
        xaxis = list(title = "Year"),
        yaxis = list(title = "Rate")
      )
  })

  # Plot 2 - Shortfall per Person
  output$bar <- renderPlotly({
    # Gather top 5
    shortfall_top_n <- shortfall_per_person %>%
      filter(year == input$bar_year) %>%
      slice_max(order_by = shortfall, n = input$bar_top_n)

    # Create plot
    plot2 <- plot_ly(
      data = shortfall_top_n,
      x = ~ reorder(State.Name, -shortfall),
      y = ~shortfall,
      type = "bar",
      color = ~State.Name,
      showlegend = F
    ) %>%
      layout(
        title = paste0("Top ", input$bar_top_n, " State Shortfalls in ",
                       input$bar_year),
        xaxis = list(title = "State"),
        yaxis = list(title = "Shortfall", tickprefix = "$")
      )

    # Return plot
    return(plot2)
  })

  # Plot 3 - map
  output$map <- renderPlotly({
    # Round the rate
    map_data$high_threshold <- round(
      map_data$high_threshold, 3
    )
    # Filter the dataframe based on the input of the slider bar
    data_year_filtered <- filter(map_data, year == input$slider1)
    # Rename the column name for better readability on tooltip
    Rate <- data_year_filtered$high_threshold
    # Plot the map
    us_map <- ggplot(data_year_filtered) +
      geom_polygon(
        mapping = aes(x = long, y = lat, group = group, fill = Rate),
        color = "white",
        size = .1
      ) +
      coord_map() +
      scale_fill_continuous(low = "White", high = "Red") +
      labs(fill = "Rate") + # Shortened to just "Percentage" b/c it's too long
      # Move the longer name (commented out below) to the title
      theme_bw() +
      theme(
        axis.line = element_blank(),
        axis.text = element_blank(),
        axis.ticks = element_blank(),
        axis.title = element_blank(),
        plot.background = element_blank(),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.border = element_blank()
      )
    return(us_map)
  })
}
