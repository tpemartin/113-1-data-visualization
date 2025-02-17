# Load required libraries
library(tidyverse)

# Transform the data from wide to long format
gdp_long <- gdpGrowth %>%
  pivot_longer(cols = starts_with("20"),  # Select all columns that start with "20"
               names_to = "Year", 
               names_prefix = "", 
               values_to = "GDP_Growth") %>%
  mutate(Year = str_extract(Year, "\\d{4}") %>% as.numeric())  # Extract and convert year to numeric

# Plot the data using ggplot2
ggplot(gdp_long, aes(x = Year, y = GDP_Growth, color = `Country Name`)) +
  geom_line(size = 1) +
  geom_point(size = 2) +
  labs(title = "GDP Growth Rates (2000-2015)", 
       x = "Year", 
       y = "GDP Growth (%)", 
       color = "Country") +
  theme_minimal() -> g

g

# Load the ggrepel package for better label placement
library(ggrepel)

# Revise the plot
g + 
  # Add text labels to the last year for each country
  geom_text_repel(data = gdp_long %>% filter(Year == max(Year)),  # Filter the latest year
                  aes(label = `Country Name`), 
                  nudge_x = 0.5,   # Slightly nudge labels to the right
                  hjust = 0,       # Align text horizontally
                  size = 5) +      # Adjust text size
  # Remove the legend
  theme(legend.position = "none")

# Remove the color aesthetic and update the plot
gdp_long %>%
  ggplot(aes(x = Year, y = GDP_Growth, group = `Country Name`)) +  # Remove color, group by Country Name
  geom_line(size = 1) +
  geom_point(size = 2) +
  geom_text_repel(data = gdp_long %>% filter(Year == max(Year)),  # Add labels at the last year
                  aes(label = `Country Name`), 
                  nudge_x = 0.5, 
                  hjust = 0, 
                  size = 5) +
  labs(title = "GDP Growth Rates (2000-2015)", 
       x = "Year", 
       y = "GDP Growth (%)") +
  theme_minimal() +
  theme(legend.position = "none")  # Remove the legend

# Update the plot to use different linetypes and point shapes
gdp_long %>%
  ggplot(aes(x = Year, y = GDP_Growth, group = `Country Name`, 
             linetype = `Country Name`, shape = `Country Name`)) +  # Map linetype and shape to Country Name
  geom_line(size = 1) +
  geom_point(size = 3) +
  geom_text_repel(data = gdp_long %>% filter(Year == max(Year)),  # Add labels at the last year
                  aes(label = `Country Name`), 
                  nudge_x = 0.5, 
                  hjust = 0, 
                  size = 5) +
  labs(title = "GDP Growth Rates (2000-2015)", 
       x = "Year", 
       y = "GDP Growth (%)") +
  theme_minimal() +
  theme(legend.position = "none")  # Remove the legend

# Use mutate and recode to translate country names into Taiwan Traditional Chinese
gdp_long <- gdp_long %>%
  mutate(`Country Name` = recode(`Country Name`,
                                 "Korea, Rep." = "南韓",
                                 "Japan" = "日本",
                                 "China" = "中國",
                                 "Singapore" = "新加坡",
                                 "Hong Kong SAR, China" = "中國香港"))

# Now, you can proceed with your plotting as usual
# Update the plot to use different linetypes and point shapes
gdp_long %>%
  ggplot(aes(x = Year, y = GDP_Growth, group = `Country Name`, 
             linetype = `Country Name`, shape = `Country Name`)) +  # Map linetype and shape to Country Name
  geom_line(size = 1) +
  geom_point(size = 3) +
  geom_text_repel(data = gdp_long %>% filter(Year == max(Year)),  # Add labels at the last year
                  aes(label = `Country Name`), 
                  nudge_x = 0.5, 
                  hjust = 0, 
                  size = 5) +
  labs(title = "GDP Growth Rates (2000-2015)", 
       x = "Year", 
       y = "GDP Growth (%)") +
  theme_minimal() +
  theme(legend.position = "none")  # Remove the legend

# Save the plot with width as 80% of A4 paper width (168 mm or about 6.61 inches)
ggsave("gdp_growth_plot.png", width = 6.61, height = 4.5, units = "in")

# Load the ggrepel package (if not already loaded)
library(ggrepel)

# Plot with adjusted font sizes
gdp_long %>%
  ggplot(aes(x = Year, y = GDP_Growth, group = `Country Name`, 
             linetype = `Country Name`, shape = `Country Name`)) +  # Different linetypes and shapes
  geom_line(size = 1) +
  geom_point(size = 3) +
  geom_text_repel(data = gdp_long %>% filter(Year == max(Year)),  # Add labels at the last year
                  aes(label = `Country Name`), 
                  nudge_x = 0.5, 
                  hjust = 0, 
                  size = 5) +
  labs(title = "GDP Growth Rates (2000-2015)", 
       x = "Year", 
       y = "GDP Growth (%)") +
  theme_minimal() +
  theme(legend.position = "none",  # Remove the legend
        plot.title = element_text(size = 14),   # Title font size 14pt
        axis.title = element_text(size = 12),   # Axis title font size 12pt
        axis.text = element_text(size = 10),    # Axis text font size 10pt
        legend.text = element_text(size = 10),  # Any remaining text (if legend exists) font size 10pt
        strip.text = element_text(size = 10))   # Facet label font size (if applicable)

# Save the plot with a width of 80% of A4 paper width (168 mm or about 6.61 inches)
ggsave("gdp_growth_plot_custom_font.png", width = 6.61, height = 4.5, units = "in")


# Define the adjustment factor
adj <- 2  # You can change this value later to adjust font sizes dynamically

# Plot with dynamically adjusted font sizes
gdp_long %>%
  ggplot(aes(x = Year, y = GDP_Growth, group = `Country Name`, 
             linetype = `Country Name`, shape = `Country Name`)) +  # Different linetypes and shapes
  geom_line(size = 1) +
  geom_point(size = 3) +
  geom_text_repel(data = gdp_long %>% filter(Year == max(Year)),  # Add labels at the last year
                  aes(label = `Country Name`), 
                  nudge_x = 0.5, 
                  hjust = 0, 
                  size = 5 * adj) +  # Adjust text size dynamically
  labs(title = "GDP Growth Rates (2000-2015)", 
       x = "Year", 
       y = "GDP Growth (%)") +
  theme_minimal() +
  theme(legend.position = "none",  # Remove the legend
        plot.title = element_text(size = 14 * adj),   # Title font size adjusted
        axis.title = element_text(size = 12 * adj),   # Axis title font size adjusted
        axis.text = element_text(size = 10 * adj),    # Axis text font size adjusted
        legend.text = element_text(size = 10 * adj),  # Remaining text font size adjusted
        strip.text = element_text(size = 10 * adj))   # Facet label font size (if applicable)

# Save the plot with a width of 80% of A4 paper width (168 mm or about 6.61 inches)
ggsave("gdp_growth_plot_custom_font_adj.png", width = 6.61, height = 4.5, units = "in")

# Load necessary libraries from tidyverse
library(tidyverse)

# Define adj for text size scaling
adj <- 1

# Reshape the data to long format
gdpGrowth_long <- gdpGrowth %>%
  pivot_longer(
    cols = starts_with("2000"):starts_with("2015"), # Selects all the year columns
    names_to = "Year",
    values_to = "GDP_Growth"
  ) %>%
  mutate(Year = as.numeric(gsub("[YR]", "", Year))) # Convert Year to numeric

# Create the plot
ggplot(gdpGrowth_long, aes(x = Year, y = GDP_Growth, color = `Country Name`, group = `Country Name`)) +
  geom_line(size = 1) +  # Draw lines for each country
  geom_point(size = 3) + # Add points to the lines
  labs(
    title = "GDP Growth Rates of Korea and Japan (2000-2015)",
    subtitle = "Annual percentage growth of GDP",
    x = "Year",
    y = "GDP Growth (%)",
    caption = "Data source: World Bank",
    color = "Country"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(size = 16 * adj, hjust = 0.5),
    plot.subtitle = element_text(size = 14 * adj, hjust = 0.5),
    plot.caption = element_text(size = 12 * adj),
    axis.title.x = element_text(size = 12 * adj),
    axis.title.y = element_text(size = 12 * adj),
    axis.text.x = element_text(size = 10 * adj),
    axis.text.y = element_text(size = 10 * adj),
    legend.title = element_text(size = 10 * adj),
    legend.text = element_text(size = 10 * adj)
  )

library(tidyverse)

# Reshape the data frame to a long format
gdpGrowth_long <- gdpGrowth %>%
  pivot_longer(cols = starts_with("20"), 
               names_to = "Year", 
               names_prefix = "X", 
               values_to = "GDP_Growth") %>%
  mutate(Year = as.integer(Year))

# Plot the data
adj <- 1
gdpGrowth_long %>%
  ggplot(aes(x = Year, y = GDP_Growth, color = `Country Name`)) +
  geom_line(size = 1) +
  geom_point(size = 2) +
  labs(title = "GDP Growth Rates (2000-2015)",
       subtitle = "Annual GDP growth rates for Korea and Japan",
       x = "Year",
       y = "GDP Growth (%)",
       caption = "Source: Global Environment") +
  theme_minimal() +
  theme(
    plot.title = element_text(size = 16 * adj),
    plot.subtitle = element_text(size = 14 * adj),
    plot.caption = element_text(size = 12 * adj),
    axis.title = element_text(size = 12 * adj),
    axis.text = element_text(size = 10 * adj),
    legend.text = element_text(size = 10 * adj),
    legend.title = element_text(size = 10 * adj)
  )

library(tidyverse)

# Reshape the data frame to a long format
gdpGrowth_long <- gdpGrowth %>%
  pivot_longer(cols = starts_with("20"), 
               names_to = "Year", 
               names_pattern = "(\\d{4}) \\[YR\\d{4}\\]", 
               values_to = "GDP_Growth") %>%
  mutate(Year = as.integer(Year))

# Plot the data
adj <- 1
gdpGrowth_long %>%
  ggplot(aes(x = Year, y = GDP_Growth, color = `Country Name`)) +
  geom_line(size = 1) +
  geom_point(size = 2) +
  labs(title = "GDP Growth Rates (2000-2015)",
       subtitle = "Annual GDP growth rates for Korea and Japan",
       x = "Year",
       y = "GDP Growth (%)",
       caption = "Source: Global Environment") +
  theme_minimal() +
  theme(
    plot.title = element_text(size = 16 * adj),
    plot.subtitle = element_text(size = 14 * adj),
    plot.caption = element_text(size = 12 * adj),
    axis.title = element_text(size = 12 * adj),
    axis.text = element_text(size = 10 * adj),
    legend.text = element_text(size = 10 * adj),
    legend.title = element_text(size = 10 * adj)
  )

# Save the plot
ggsave("gdp_growth_plot.png", width = 168, height = 210, units = "mm")

library(tidyverse)

# Reshape the data frame to a long format
gdpGrowth_long <- gdpGrowth %>%
  pivot_longer(cols = starts_with("20"), 
               names_to = "Year", 
               names_pattern = "(\\d{4}) \\[YR\\d{4}\\]", 
               values_to = "GDP_Growth") %>%
  mutate(Year = as.integer(Year))

# Plot the data
adj <- 2
plot <- gdpGrowth_long %>%
  ggplot(aes(x = Year, y = GDP_Growth, color = `Country Name`)) +
  geom_line(size = 1) +
  geom_point(size = 2) +
  labs(title = "GDP Growth Rates (2000-2015)",
       subtitle = "Annual GDP growth rates for Korea and Japan",
       x = "Year",
       y = "GDP Growth (%)",
       caption = "Source: Global Environment") +
  theme_minimal() +
  theme(
    plot.title = element_text(size = 16 * adj),
    plot.subtitle = element_text(size = 14 * adj),
    plot.caption = element_text(size = 12 * adj),
    axis.title = element_text(size = 12 * adj),
    axis.text = element_text(size = 10 * adj),
    legend.text = element_text(size = 10 * adj),
    legend.title = element_text(size = 10 * adj)
  )

# Save the plot with proper aspect ratio
ggsave("gdp_growth_plot.png", plot = plot, width = 168, height = 126, units = "mm")

# Load necessary libraries
library(tidyverse)

# Reshape the data from wide to long format
gdpGrowth_long <- gdpGrowth %>%
  pivot_longer(cols = starts_with("200"), 
               names_to = "Year", 
               # names_prefix = "X", 
               values_to = "GDP_Growth") %>%
  mutate(Year = as.numeric(str_extract(Year, "\\d{4}")))

# Plot the data
gdpGrowth_long %>%
  ggplot(aes(x = Year, y = GDP_Growth, color = `Country Name`)) +
  geom_line(size = 1) +
  geom_point(size = 2) +
  labs(title = "GDP Growth Rates (2000-2015)",
       x = "Year",
       y = "GDP Growth (%)",
       color = "Country") +
  theme_minimal()

# summarise gdpGrowth_long

gdpGrowth_long |>
  select(
    `Country Name`, GDP_Growth, Year
  ) -> gdpGrowth_long_selected

write_csv(gdpGrowth_long_selected, "data/gdp_growth_long_selected.csv")
gdpGrowth_long_selected |>
  head(2) |> glimpse()

library(dplyr)

# Step 1: Change `Country Name` to a factor
gdpGrowth_long_selected <- gdpGrowth_long_selected %>%
  mutate(`Country Name` = as.factor(`Country Name`))

# Step 2: Summarize the data by `Country Name`
gdpGrowth_summary <- gdpGrowth_long_selected %>%
  group_by(`Country Name`) %>%
  summarise(
    avg_GDP_Growth = mean(GDP_Growth, na.rm = TRUE),
    .groups = "drop"
  )

# View the summary
gdpGrowth_summary

write_csv(gdpGrowth_summary, "data/gdp_growth_summary.csv")

# week3 ----

library(tidyverse)

# 將數據中的所有年度列轉換為字符型，避免類型不一致的問題
myData_clean <- myData %>%
  mutate(across(starts_with("20"), as.character))  # 將所有以 "20" 開頭的列轉換為字符型

# 轉換為長格式
myData_long <- myData_clean %>%
  pivot_longer(cols = starts_with("20"),  # 轉長格式，選擇所有以20開頭的列
               names_to = "年度", 
               values_to = "人數") %>%
  mutate(人數 = str_replace_all(人數, ",", ""),  # 移除千位符
         人數 = as.numeric(ifelse(人數 == "-", NA, 人數)))  # 將 "-" 轉為 NA，並轉為 numeric

# 移除細分中出現 "合計" 的資料
myData_long_filtered <- myData_long %>%
  filter(!str_detect(細分, "合計"))  # 過濾掉包含 "合計" 的行

# 計算各年度對應的總人數
總人數_by_country <- myData_long_filtered %>%
  group_by(首站抵達地, 年度) %>%
  summarise(總人數 = sum(人數, na.rm = TRUE), .groups = 'drop')  # 計算總人數並移除分組

# 確保年度是數值型
總人數_by_country$年度 <- as.numeric(總人數_by_country$年度)

ggplot(總人數_by_country, aes(x = 年度, y = 總人數, color = 首站抵達地)) +
  geom_line() +
  geom_point() +
  labs(title = "不同首站抵達地的年度總人數",
       x = "年度",
       y = "總人數") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))  # 調整 x 軸標籤角度
