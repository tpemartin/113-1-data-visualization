gsUrl <- "https://docs.google.com/spreadsheets/d/11Gc9tbOKcRVUkzv2OK_Wr6IQWDvm_j8Jn_fnobzheJg/edit?gid=543078418#gid=543078418"

# download all sheets from the google sheets
library(googlesheets4)
gs <- googlesheets4::gs4_get(gsUrl)
gs$sheets$name |>
  purrr::map(
    ~{
        read_sheet(gsUrl, .x)
    }
  ) -> sheets

library(tidyverse)
# for each sheet filter 評分人 == "學生與教師"
tidy_grade <- function(sheet) {
  sheet  |>
    dplyr::filter(
      評分人 == "學生與教師"
    ) -> filtered_df
  
  filtered_df |>
    pivot_longer(
      cols = -c(1:3),
      names_to = "ID學生",
      values_to = "分數"
    ) |>
    mutate(
      ID = stringr::str_extract(ID學生, "\\d+"),
      學生 = stringr::str_extract(ID學生, "[^\\d\\s經濟一二三四]+")
    ) |>
    select(
      -評分人,-評分面向
    )
}

sheets[[1]] |> tidy_grade()

sheets |> purrr::map_dfr(tidy_grade) -> all_grades

# extract last 3 digits of $ID 
all_grades |>
  mutate(
    ID3 = stringr::str_extract(ID, "\\d{3}$")
  ) -> all_grades

all_grades |>
  group_by(學生) |>
  summarise(
    ID = glue::glue("({ID3[1]}) {學生[[1]]}"),
    學生 = 學生[[1]],
    分數 = sum(分數, na.rm = TRUE)
  ) -> sum_grades

gsUrl <- "https://docs.google.com/spreadsheets/d/1AyZ6i5M49Rnug3bk1KDvMyIGGGrVwu-5EzPQWSUv6kE/edit?gid=482415666#gid=482415666"
sum_grades |>
  write_sheet(gsUrl, 
              sheet="semester grades")
