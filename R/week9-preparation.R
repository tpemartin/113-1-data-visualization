flightDestinationAsia <- 
  googlesheets4::read_sheet("https://docs.google.com/spreadsheets/d/1-jX-3EK_yspYDgPIy5vwnRKHntw9-dQIpFVhLc5JcXc/edit?gid=71141138#gid=71141138",
                            sheet="flightDestinationAsia-looker-2")

glimpse(flightDestinationAsia)

unique(flightDestinationAsia$`細分2`) |> 
  dput()

# Prepare the data to create a 100% stacked bar chart
tidy_data <- flightDestinationAsia %>%
  group_by(Year, 細分2) %>%
  summarise(Total_Counts = sum(Total_Counts, na.rm = TRUE)) %>%
  ungroup()
 
tidy_data <- tidy_data |>
  mutate(
    `細分2` = factor(
                `細分2`, 
                 levels = c(  "日本Japan", "其他","澳門Macao",  "香港Hong Kong","中國大陸China"))
  )


# Create the 100% stacked bar graph

adj <- 3
adjustable_plot <- ggplot(tidy_data, aes(x = Year, y = Total_Counts, fill = 細分2)) +
  geom_area( position = "fill") +
  scale_y_continuous(
    labels = scales::percent_format(scale = 100, suffix=""),
  )+
  scale_fill_manual(values = c(
    "中國大陸China" = "#D85C5C",   # Muted Red
    "香港Hong Kong" = "#E6A58C",  # Muted Coral
    "澳門Macao" = "#C171B3",      # Muted Purple
    "日本Japan" = "#7DA0C7",      # Muted Blue (Secondary Role)
    "其他" = "#D0D0D0"            # Gray (Background Role)
  )) +
  labs(title = "歷年台灣出國首站抵達亞洲國家之各國人次佔比",
       subtitle = "單位: 百分比（分母為首站亞洲抵達國家總人次）",
       caption = "開放政府資料平台",
       x = NULL,
       y = NULL) +
  theme_minimal() +
  theme(
    plot.title = element_text(size = 16 * adj),
    plot.subtitle = element_text(size = 14 * adj),
    plot.caption = element_text(size = 12 * adj),
    axis.title.x = element_text(size = 12 * adj),
    axis.title.y = element_text(size = 12 * adj),
    axis.text = element_text(size = 10 * adj),
    legend.text = element_text(size = 10 * adj),
    legend.title = element_blank(),
    # Set other text sizes to 10
    text = element_text(size = 10),
    legend.position = "top"
  )
adjustable_plot
# Save the graph
output_width <- 11.7 * 0.8  # 80% of A4 width
output_height <- output_width * (3 / 4)  # Aspect ratio 4:3

ggsave("img/歷年台灣出國首站抵達亞洲國家之各國人次佔比.png", plot = adjustable_plot, 
       width = output_width, height = output_height, dpi = 300, 
       device = "png")



