# Step 1. import data
library(readr)
destination <- read_csv("data/歷年中華民國國民出國目的地人數統計2002-2023.csv")

# Step 1: Import data
# The data frame 'destination' is already in the Global environment.

# Step 2: Tidy data, double check the classes of the variables
library(tidyverse)

# Convert relevant columns to numeric
destination_numeric <- destination %>%
  mutate(across(`2002`:`2023`, ~ as.numeric(gsub(",", "", .))))  # Remove commas and convert to numeric

# Reshape the data to long format
destination_long <- destination_numeric %>%
  pivot_longer(cols = `2002`:`2023`, 
               names_to = "Year", 
               values_to = "Count")

# Filter the destination_long data frame to keep only rows with "Total" in the "細分" column
destination_total <- destination_long %>%
  filter(str_detect(細分, "Total"))

# Now you can visualize the filtered data
ggplot(destination_total, aes(x = Year, y = Count, color = 細分)) +
  geom_line(linewidth = 1) +  # Use linewidth instead of size
  geom_point(size = 2) +
  labs(title = "2002-2023年不同首站抵達地的總人數趨勢 - 總計",
       subtitle = "每年所有到達國家的總人數",
       x = "年份",
       y = "總人數",
       caption = "數據來源: destination") +
  theme_minimal(base_size = 10) +
  theme(plot.title = element_text(size = 16 * 1),
        plot.subtitle = element_text(size = 14 * 1),
        plot.caption = element_text(size = 12 * 1),
        axis.title.x = element_text(size = 12 * 1),
        axis.title.y = element_text(size = 12 * 1),
        axis.text = element_text(size = 10 * 1))

# Save the plot
ggsave("total_arrivals_trend_total.png", width = 11.7 * 0.8, height = 11.7 * 0.8 * 3/4, units = "in", dpi = 300)

# Step 4: Export the tidy data to Google Sheet
# Assuming a typical function to write to Google Sheets is set up
# library(googlesheets4)
# write_sheet(destination_long, ss = "Your Google Sheet Link", sheet = "Sheet1")
