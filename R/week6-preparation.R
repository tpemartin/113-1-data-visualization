library(readr)
flightDestinationRaw <- read_csv("data/首站抵達地raw.csv")

library(tidyverse)
library(tidyverse)

# Step 1: Filter the data for "亞洲地區" and convert all year columns to character
tidy_flight_data <- flightDestinationRaw %>%
  dplyr::filter(`首站抵達地` == "亞洲地區") %>%
  mutate(across(starts_with("20"), as.character)) %>%  # Convert year columns to character
  pivot_longer(cols = starts_with("20"),
               names_to = "Year",
               values_to = "Counts") %>%
  mutate(Counts = as.numeric(gsub(",", "", Counts))) # Convert to numeric after pivoting

googlesheets4::write_sheet(
  tidy_flight_data,
  "https://docs.google.com/spreadsheets/d/1-jX-3EK_yspYDgPIy5vwnRKHntw9-dQIpFVhLc5JcXc/edit?gid=0#gid=0",
  sheet = "flightDestinationAsia"
)

library(tidyverse)

# Step 1: Filter the data for "亞洲地區" and convert all year columns to character
tidy_flight_data <- tidy_flight_data %>%
  mutate(
         Year = as.Date(paste0(Year, "-01-01")))  # Convert Year to Date class

googlesheets4::write_sheet(
  tidy_flight_data,
  "https://docs.google.com/spreadsheets/d/1-jX-3EK_yspYDgPIy5vwnRKHntw9-dQIpFVhLc5JcXc/edit?gid=0#gid=0",
  sheet = "flightDestinationAsia-looker"
)

# Step 2: Create the time trend plot
ggplot(tidy_flight_data, aes(x = Year, y = Counts, color = 細分)) +
  geom_line() +
  geom_point() +
  labs(title = "Time Trend of Different Categories in Asia (2002-2022)",
       x = "Year",
       y = "Counts",
       color = "Category") +
  theme_minimal()
