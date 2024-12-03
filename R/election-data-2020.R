library(readxl)
election <- read_excel("data/2020-taiwan-presidential-election/總統-A05-1-候選人得票數一覽表(中　央).xls",
skip = 1)

election |> names()
election[1, 2:4] |>
  unlist() -> names(election)[2:4]

election |> names()

glimpse(election)

election <- election[-c(1:3), ]

glimpse(election)

# Assuming 'election' is already in the global environment

election <- election %>%
  mutate(across(2:12, ~ {
    .x %>%
      str_replace_all(",", "") %>%  # Remove commas
      as.numeric()                   # Convert to numeric
  }))

glimpse(election)

# remove " " in $行政區別
election$行政區別 |> str_trim() -> election$行政區別


election_long <- election |>
  tidyr::pivot_longer(cols = 2:4, names_to = "candidate", values_to = "votes")

glimpse(election_long)

# remove non-chinese characters from column names of columns 2:9

election_long |>
  names() |>
  str_replace_all("[^[:alnum:]]|[A-Z]|[0-9]", "") -> names(election_long)

# parse $行政區別 as factor
election_long$行政區別 <- as.factor(election_long$行政區別)
levels(election_long$行政區別)
election_long$district <- election_long$行政區別
levels(election_long$district) <- c(
  "Nantou County", "Chiayi City", "Chiayi County", "Keelung City", "Yilan County",
  "Pingtung County", "Changhua County", "New Taipei City", "Hsinchu City",
  "Hsinchu County", "Taoyuan City", "Penghu County", "Total", "Taichung City",
  "Taipei City", "Tainan City", "Taitung County", "Hualien County",
  "Miaoli County", "Lienchiang County", "Kinmen County", "Yunlin County",
  "Kaohsiung City"
)

glimpse(election_long)


# put data in google sheets
library(googlesheets4)
gsUrl <- "https://docs.google.com/spreadsheets/d/1-jX-3EK_yspYDgPIy5vwnRKHntw9-dQIpFVhLc5JcXc/edit?gid=0#gid=0"
# export to sheet 2020-總統大選
googlesheets4::write_sheet(election_long, gsUrl, sheet = "2020-總統大選")
