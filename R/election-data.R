library(readxl)
election <- read_excel("data/2024-taiwan-presidential-election/總統-各投票所得票明細及概況(Excel檔)/總統-A05-1-候選人得票數一覽表(中　央).xlsx", skip = 1)

election |> names()
election[1, 2:4] |>
  unlist() -> names(election)[2:4]

election |> names()

glimpse(election)

election <- election[-c(1:3), ]

glimpse(election)

# parse column 2:4 as numeric
election[2:4] <- lapply(election[2:4], as.numeric)

# parse last column as numeric
last_col <- ncol(election)
election[last_col] <- lapply(election[last_col], as.numeric)

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
# export to sheet 2024-總統大選
googlesheets4::write_sheet(election_long, gsUrl, sheet = "2024-總統大選")
