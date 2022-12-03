# Load libraries
library(shiny)
library(shinythemes)

# Introduction page
intro_panel <- tabPanel(
  "Introduction",
  titlePanel("Introduction"),
  p(
    style = "font-size:18px;", strong("Team Lettuce Work Together"),
    " Gabriella Alonso, Brielle Bush, Sang-Won Yu, Maynard Maynard-Zhang"
  ),
  p(
    style = "font-size:16px;", "Food insecurity,",
    em("or the lack of regular access to nutritious foods,"),
    "is not an issue solely afflicting developing countries. As a developed
  country with a robust economy and advanced infrastructure, the United States
  continues to struggle with food insecurity. In examining data from
  2009 - 2018, our team has created visualizations to study some contributing
  factors to the persistence of food insecurity in the U.S..
  These visualizations highlight potential determinants such as social
  inequalities,
  state-level financial
  needs, and food deserts.",
    p(
      style = "font-size:16px;", "Our team analyzed data from ",
      HTML(paste0(a("Feeding America", href = "https://secure.feedingamerica.org/site/Donation2?29411.donation=form1&df_id=29411&mfc_pref=T&s_src=Y21XP1B1Y&s_subsrc=c&s_keyword=feeding%20america&gclid=CjwKCAiAhbeCBhBcEiwAkv2cYyCjU5N8k3ALk3ExtioTjaZqxr90jkOtfUNTAclG2ZJi6p1Mo-HB9xoCNcYQAvD_BwE&gclsrc=aw.ds"), ",")),
      " a nonprofit organization with
  a network of over 200 food banks, to understand how food insecurity in the
  U.S.
  has changed over time. This organization drew local food insecurity and
  expenditure estimates from the Current Population Survey (CPS),
  American Community Survey (ACS), and Bureau of Labor Statistics (BLS). Using
  this data
  enabled us to explore food insecurity at the county, congressional district,
  and state levels. In addition, this data let us explore questions about the
  scale of American food insecurity and the
  budget shortfalls of existing food assistance programs."
    ),
    p(
      style = "font-size:16px;", "In addition, we utilized data calculated by
      USDA's ",
      a("Economic Research Service (ERS)", href = "https://www.ers.usda.gov/"),
      "concerning the relationship between access to
    healthy food and race. ERS sourced its statistics from Current
    Population Survey Food Security Supplement (CPS-FSS) from the U.S. Census
    Bureau. This data helped us understand any demographic factors
    influencing inequal access to nutritious foods in the United States."
    ),
    p(style = "font-size:16px;", strong("Ultimately, our project explores
    questions regarding the trends of
  food insecurity over time, food gaps between different races, and
  the success of food assistance programs, as well as the existence
  of potential
  food deserts.")),
    img(src = "market.jpg"),
  )
)
# Chart 1 page
line_panel <- tabPanel(
  "Average Rates",
  titlePanel("Average Food Insecurity Rates over Time"),
  # Drop down menu
  sidebarPanel(
    selectInput(
      inputId = "line_selection",
      label = "Select a race:",
      choices = c(
        "National",
        "Black",
        "Hispanic",
        "White"
      ),
      selected = "National"
    )
  ),
  # Output the line plot
  mainPanel(
    plotlyOutput("line_plot")
  )
)
# Chart 2 page
# Title
bar_title <- titlePanel("Budget Shortfall per Food Insecure Person")

# Widget 1: year slider
bar_year <- sliderInput(
  inputId = "bar_year",
  label = "Select a year:",
  min = 2012,
  max = 2018,
  value = 2018,
  sep = ""
)

# Widget 2: top N numeric input
bar_top_n <- numericInput(
  inputId = "bar_top_n",
  label = "Choose how many states to display:",
  value = 5,
  min = 1,
  max = 51,
  step = 1
)

# Sidebar
bar_sidebar <- sidebarPanel(
  bar_year,
  bar_top_n
)

# Main content
bar_main_content <- mainPanel(
  plotlyOutput("bar")
)

# Entire page
bar_panel <- tabPanel(
  "Budget Shortfall",
  bar_title,
  bar_sidebar,
  bar_main_content
)

# Chart 3 page
map_panel <- tabPanel(
  "High Poverty Threshold",
  titlePanel("Food Insecure Population above High Poverty Threshold"),
  sidebarPanel(
    sliderInput("slider1",
      label = "Select a year:", min = 2009,
      max = 2018, value = 2009, sep = ""
    )
  ),
  mainPanel(
    plotlyOutput("map")
  )
)

# Conclusion page
concl_panel <- tabPanel(
  "Conclusion",
  titlePanel("Insights"),
  p(
    style = "font-size:16px;", "Our work reveals that, in general,",
    strong("U.S.
    national food insecurity rates have been steadily decreasing"),
    "since 2011. In fact, average food insecurity rates hit an all-time
    low of 0.162 in 2018. While this is great news, our line graph,
    unfortunately, also highlights how", strong("food insecurity has
    disproportionately affected people."), "In addition to experiencing food
    insecurity
    rates that are above the U.S. national average, Black and Hispanic
    Americans are around twice as likely to experience food insecurity
    than White Americans.",
    p(style = "font-size:16px;", "To complement our study of the demographics
    of American food insecurity, our team also explored financial factors.
    Since our earlier research revealed that budget shortfalls in food
    assistance programs had a higher impact on food insecurity than meal
    costs, we created a bar chart to further examine these shortfalls. Our
    chart draws reveals", strong("five states that have consistently
    experienced the highest shortfalls per food-insecure person from
    2012 -2018: District of Columbia, Massachusetts, Maine, Alaska,
    and Vermont."), "These states are most in need of receiving additional
    financial assistance to help meet the needs of their food
    insecure populations. For example, the District of Columbia
    was short an average of $690.28 per food-insecure person in 2018.
    Using their average meal cost of $4.08,", strong("around 169 meals per
    person were not consumed in the District of Columbia due to budget
    shortfalls.")),
    p(
      style = "font-size:16px;", "To further explore the impact of financial
      factors
    on food insecurity in the U.S., we created a map to understand where the
    percentage
    of food-insecure people is greater than the high poverty threshold.",
      em("In other words, it examines where people are not poor yet still food
         insecure."),
      "Our map reveals that the", strong("American Midwest"), "tends to have
      more
    financially-able food insecure people. Additionally,", strong("Vermont"),
      "stands out as a state with consistently high levels of food insecure
    people who have the resources to purchase healthy foods. While there
    are many explanations for this,", strong("it suggests that these states
    tend to have more food deserts, where there are fewer ways to access
    and purchase nutritious foods.")
    ),
    p(style = "font-size:16px;", "Overall, our study sheds light on the
    complexity of U.S. food insecurity. While general food insecurity rates
    are decreasing, factors such as demographics, budget shortfalls,
    and potential food deserts continue to limit access to food. The
    information revealed in this project can facilitate targeted
    help to vulnerable states and provide insight into social factors
    influencing food insecurity."),
    img(src = "field.jpg"),
  )
)

# Define UI
ui <- navbarPage(
  "Food Insecurity in the U.S.",
  theme = shinytheme("united"),
  intro_panel,
  line_panel,
  bar_panel,
  map_panel,
  concl_panel
)
