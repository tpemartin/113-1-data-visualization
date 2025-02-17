total_people_by_country <- read_csv("data/113-1-資料視覺化圖例 - total_people_by_country.csv")

glimpse(total_people_by_country |> head(2))

library(ggplot2)

# Assuming your data frame is named `total_people_by_country`
total_people_by_country |> 
  ggplot(aes(x = 年度, y = 總人數, color = `首站抵達地`)) +
  geom_line() +
  geom_point() +
  labs(
    title = "不同首站抵達地的不同年度時間趨勢圖",
    x = "年度",
    y = "總人數",
    color = "首站抵達地"
  ) +
  theme_minimal()

library(dplyr)
library(lubridate)

tidy_total_people_by_country <- total_people_by_country %>%
  mutate(年度 = as.Date(paste0(年度, "-01-01")))

tidy_total_people_by_country |>
  googlesheets4::write_sheet("https://docs.google.com/spreadsheets/d/1f6sCWRGKCMNDAt2sfbqwR5XqWTpEWNp1jNACkDfKZzo/edit?gid=0#gid=0",
                             sheet="total_people_by_country_tidy")
