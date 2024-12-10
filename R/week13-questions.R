# import from google sheets sheet name "歷年來台旅客國籍統計2002-2023"
library(googlesheets4)
library(tidyverse)
gsUrl <- "https://docs.google.com/spreadsheets/d/1uc5OkSPAun50YzIAqTRn5ZW1PmuC6lki2ecy0OqdPSY/edit?gid=1116111633#gid=1116111633"
sheet <- read_sheet(gsUrl, sheet = "歷年來台旅客國籍統計2002-2023")

glimpse(sheet)

# parse `2002` to `2023` columns to  numeric
sheet <- sheet |>
  mutate(across(`2002`:`2023`, as.numeric))

sheet_long <- sheet |>
  pivot_longer(
    cols = "2002":"2023",
    names_to = "year",
    values_to = "value"
  )

glimpse(sheet_long)

sheet_long |>
 write_sheet(
    gsUrl,
    "歷年來台旅客國籍統計2002-2023_long"
 )

library(tidyverse)
library(osmdata)
library(sf)

# Define the bounding box around the location
location_bbox <- c(left = 121.537, bottom = 25.029, right = 121.542, top = 25.032) 

# Get the data from OpenStreetMap
subway_data <- opq(bbox = location_bbox) %>%
  add_osm_feature(key = "railway", value = "subway") %>%
  osmdata_sf()

# Extract the simple feature geometry and store it in a tidy data frame
tidy_subway_data <- subway_data$osm_lines
