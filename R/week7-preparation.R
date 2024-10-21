
flightDestinationAsia <- 
  googlesheets4::read_sheet("https://docs.google.com/spreadsheets/d/1-jX-3EK_yspYDgPIy5vwnRKHntw9-dQIpFVhLc5JcXc/edit?gid=1550447151#gid=1550447151",
                            sheet="flightDestinationAsia-looker")

flightDestinationAsia |> glimpse()

flightDestinationAsia <-
  flightDestinationAsia |>
  mutate(
    `細分` = factor(`細分`)
  ) |>
  dplyr::filter(
    `細分` !="亞洲合計 Total",
    `Year` <= "2020-01-01"
  )

library(ggplot2)

# Assuming flightDestinationAsia is already in the global environment

# Create the time trend plot
ggplot(data = flightDestinationAsia, aes(x = Year, y = Counts, color = `細分`)) +
  geom_line() +
  labs(title = "Counts Trend by 細分",
       x = "Year",
       y = "Counts",
       color = "細分") +
  theme_minimal()


plotTimeTrend <- function(){
  ggplot(data = flightDestinationAsia, aes(x = Year, y = Counts, color = `細分`)) +
    geom_line() +
    labs(title = "Counts Trend by 細分",
         x = "Year",
         y = "Counts",
         color = "細分") +
    theme_minimal()
  
}

levels(flightDestinationAsia$細分)

library(dplyr)

# Reorder `細分` based on the total Counts in descending order
flightDestinationAsia <- flightDestinationAsia %>%
  mutate(`細分` = fct_reorder(`細分`, Counts, sum, .desc = TRUE))

plotTimeTrend() |> plotly::ggplotly()

library(dplyr)
library(forcats)

# Step 1: Create `細分2` column with top four categories and others as "其他"
top_four <- flightDestinationAsia %>%
  count(`細分`, wt = Counts) %>%      # Count occurrences per `細分`
  top_n(4, n) %>%                      # Get top four `細分`
  pull(`細分`)                         # Extract values as a character vector

flightDestinationAsia <- flightDestinationAsia %>%
  mutate(`細分2` = fct_other(`細分`, keep = as.character(top_four), other_level = "其他"))

# Step 2: Summarize the total Counts for each `細分2` by `Year`
tidy_flightDestinationAsia <- flightDestinationAsia %>%
  group_by(Year, `細分2`) %>%
  summarize(Total_Counts = sum(Counts, na.rm=T), .groups = 'drop')

# Display the tidy data frame
print(tidy_flightDestinationAsia)


# Create the time trend plot
ggplot(data = tidy_flightDestinationAsia, aes(x = Year, y = Total_Counts, color = `細分2`)) +
  geom_line() +
  labs(title = "Counts Trend by 細分",
       x = "Year",
       y = "Counts",
       color = "細分") +
  theme_minimal()


# Create the area chart
ggplot(data = tidy_flightDestinationAsia, aes(x = Year, y = Total_Counts, 
                                              fill = `細分2`)) +
  geom_area(color="white") +
  labs(title = "Counts Trend by 細分",
       x = "Year",
       y = "Counts",
       color = "細分") +
  theme_minimal()

# 100% Stacked Area Chart
ggplot(data = tidy_flightDestinationAsia, aes(x = Year, y = Total_Counts, 
                                              fill = `細分2`)) +
  geom_area(position = "fill", color="white") +
  labs(title = "Counts Trend by 細分",
       x = "Year",
       y = "Counts",
       color = "細分") +
  theme_minimal()

# reorder `細分2` levels based on story telling
tidy_flightDestinationAsia2 <- tidy_flightDestinationAsia %>%
  mutate(`細分2` = factor(`細分2`, 
                        levels= c( "中國大陸China", "澳門Macao", "其他", "香港Hong Kong", "日本Japan")
                        ))

# 100% Stacked Area Chart
ggplot(data = tidy_flightDestinationAsia2, aes(x = Year, y = Total_Counts, 
                                              fill = `細分2`)) +
  geom_area(position = "fill", color="white") +
  labs(title = "Counts Trend by 細分",
       x = "Year",
       y = "Counts",
       color = "細分") +
  theme_minimal()

# Create a ordered sequence field for Looker
tidy_flightDestinationAsia2 <-
  tidy_flightDestinationAsia2 |>
  mutate(
    `細分2order` = as.integer(`細分2`)
  )
