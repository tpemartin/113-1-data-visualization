flightDestination <- read_csv("data/總人數_by_country.csv")

library(ggplot2)

# 假設 flightDestination 是在 global environment 中的 dataframe
# 數據框名稱已經默認使用 tidy_ 作前綴
tidy_flightDestination <- flightDestination

library(dplyr)

# Convert `年度` variable to a date class, representing January 1st of each year
tidy_flightDestination <- tidy_flightDestination %>%
  mutate(`年度` = as.Date(paste(`年度`, "01", "01", sep = "-")))


# 繪製不同首站抵達地的年度趨勢圖
ggplot(tidy_flightDestination, aes(x = `年度`, y = `總人數`, color = `首站抵達地`)) +
  geom_line() +
  labs(title = "不同首站抵達地的年度時間趨勢圖",
       x = "年度",
       y = "總人數",
       color = "首站抵達地") +
  theme_minimal()


tidy_flightDestination |>
  googlesheets4::write_sheet(
    "https://docs.google.com/spreadsheets/d/1-jX-3EK_yspYDgPIy5vwnRKHntw9-dQIpFVhLc5JcXc/edit?gid=1340188219#gid=1340188219",
    sheet="flightDestination"
  )
