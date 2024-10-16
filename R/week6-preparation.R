library(tidyverse)
flightDestinationRaw <- read_csv("data/首站抵達地raw.csv")

# Step 1: Filter the data for "亞洲地區" and convert all year columns to character
tidy_flight_data <- flightDestinationRaw %>%
  dplyr::filter(`首站抵達地` == "亞洲地區") %>%
  mutate(across(starts_with("20"), as.character)) %>%  # Convert year columns to character
  pivot_longer(cols = starts_with("20"),
               names_to = "Year",
               values_to = "Counts") %>%
  mutate(Counts = as.numeric(gsub(",", "", Counts))) # Convert to numeric after pivoting

# googlesheets4::write_sheet(
#   tidy_flight_data,
#   "https://docs.google.com/spreadsheets/d/1-jX-3EK_yspYDgPIy5vwnRKHntw9-dQIpFVhLc5JcXc/edit?gid=0#gid=0",
#   sheet = "flightDestinationAsia"
# )

# Step 1: Filter the data for "亞洲地區" and convert all year columns to character
tidy_flight_data <- tidy_flight_data %>%
  mutate(
         Year = as.Date(paste0(Year, "-01-01")))  # Convert Year to Date class

# googlesheets4::write_sheet(
#   tidy_flight_data,
#   "https://docs.google.com/spreadsheets/d/1-jX-3EK_yspYDgPIy5vwnRKHntw9-dQIpFVhLc5JcXc/edit?gid=0#gid=0",
#   sheet = "flightDestinationAsia-looker"
# )

# Step 2: Create the time trend plot
ggplot(tidy_flight_data, aes(x = Year, y = Counts, color = 細分)) +
  geom_line() +
  geom_point() +
  labs(title = "Time Trend of Different Categories in Asia (2002-2022)",
       x = "Year",
       y = "Counts",
       color = "Category") +
  theme_minimal()

# 移除細分中的"亞洲合計 Total"
tidy_flight_data <- tidy_flight_data %>%
  dplyr::filter(細分 != "亞洲合計 Total")

# Parse細分成為factor
tidy_flight_data <- tidy_flight_data %>%
  mutate(細分 = factor(細分))

# 計算不同細分的"Counts"總和，並以它的排序來重新排列細分
tidy_flight_data %>%
  group_by(細分) %>%
  summarise(total = sum(Counts, na.rm = T)) %>%
  arrange(desc(total)) %>% 
  pull(細分) %>%
  factor(., levels = .) -> order_levels

# 重新排列細分
tidy_flight_data <- tidy_flight_data %>%
  mutate(細分 = factor(細分, levels = order_levels))

# 繪製area堆疊圖。
ggplot(tidy_flight_data, aes(x = Year, y = Counts, fill = 細分)) +
  geom_area() +
  labs(title = "Time Trend of Different Categories in Asia (2002-2022)",
       x = "Year",
       y = "Counts",
       fill = "Category") +
  theme_minimal()

