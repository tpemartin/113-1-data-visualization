library(googlesheets4)

cars <- read_sheet("https://docs.google.com/spreadsheets/d/1f6sCWRGKCMNDAt2sfbqwR5XqWTpEWNp1jNACkDfKZzo/edit?gid=0#gid=0",
                   sheet="Cars Data")

glimpse(cars)

summary(cars)

cars <- cars |> 
  mutate(
    c_type = factor(c_type)
  )

levels(cars$c_type)

# Creating the new factor variable 'c_type_main'
cars <- cars %>%
  mutate(c_type_main = case_when(
    c_type %in% c("營業大客車", "營業大貨車", "營業小客車", "營業小貨車") ~ "營業客貨車",
    c_type %in% c("自用大客車", "自用大貨車", "自用小客車", "自用小貨車") ~ "自用客貨車",
    c_type %in% c("輕型機車", "重型機車") ~ "機車",
    c_type %in% c("計程車", "特種車") ~ as.character(c_type),  # keep these as is
    TRUE ~ NA_character_  # A fallback option in case of unexpected values
  ))

# Convert the new variable to a factor
cars$c_type_main <- factor(cars$c_type_main)

# Display the levels of the new factor
levels(cars$c_type_main)

glimpse(cars)

# Step 1: Aggregate the data
tidy_cars <- cars %>%
  group_by(year, c_type_main) %>%
  summarise(total_c_count = sum(c_count), .groups = 'drop')

# Step 2: Create the trend chart
adjustable_trend_chart <- ggplot(tidy_cars, aes(x = year, y = total_c_count, color = c_type_main)) +
  geom_line(size = 1) +
  labs(title = "Trends of c_count by c_type_main Over Time",
       subtitle = "Yearly Count of Different Vehicle Types",
       x = "Year",
       y = "Count",
       color = "Vehicle Type") +
  theme_minimal()

# Adjusting text sizes
adj <- 1
adjustable_trend_chart <- adjustable_trend_chart +
  theme(
    plot.title = element_text(size = 16 * adj),
    plot.subtitle = element_text(size = 14 * adj),
    plot.caption = element_text(size = 12 * adj),
    axis.title.x = element_text(size = 12 * adj),
    axis.title.y = element_text(size = 12 * adj),
    axis.text = element_text(size = 10 * adj)
  )
adjustable_trend_chart

# Saving the graph
ggsave("c_count_trend_chart.png", plot = adjustable_trend_chart, width = 21 * 0.8, height = 15.75, units = "cm", dpi = 300, aspect.ratio = 4/3)

levels(tidy_cars$c_type_main)

tidy_cars <- tidy_cars |>
  mutate(
    c_type_main = factor(
      c_type_main
    )
  )


