filePath <- "data/ubereats-2024-9-27.csv"

library(tidyverse)
library(ggmap)

# Read in the data
ubereats <- read_csv(filePath)
glimpse(ubereats)

# filter township has "三峽"
ubereats_sanxia <- ubereats %>%
  dplyr::filter(str_detect(township, "三峽"))


glimpse(ubereats_sanxia)

library(ggmap)

# Ensure bbox_sanxia is correctly defined
bbox_sanxia <- c(left = min(ubereats_sanxia$lon) - 0.01,
                 bottom = min(ubereats_sanxia$lat) - 0.01,
                 right = max(ubereats_sanxia$lon) + 0.01,
                 top = max(ubereats_sanxia$lat) + 0.01)

# Get stamen map with toner-lite style
sanxia_map <- get_stadiamap(bbox = bbox_sanxia, zoom = 14, maptype = "stamen_toner_lite")

# Plot the map
ggmap(sanxia_map) +
  geom_point(data = ubereats_sanxia, aes(x = lon, y = lat), color = "red", size = 2) +
  theme_minimal()
  
# make the point color vary by $rating
ggmap(sanxia_map) +
  geom_point(data = ubereats_sanxia, aes(x = lon, y = lat, color = rating), size = 2) +
  theme_minimal()

# create location as "lat,lon" for each row
ubereats_sanxia$location <- paste(ubereats_sanxia$lat, ubereats_sanxia$lon, sep = ",")
# create tooltip as "name: rating"
ubereats_sanxia$tooltip <- paste(ubereats_sanxia$name, ubereats_sanxia$rating, sep = ": ")

# select location, tooltip, and rating columns
ubereats_sanxia_select <- ubereats_sanxia %>%
  dplyr::select(location, tooltip, rating)

gsUrl <- "https://docs.google.com/spreadsheets/d/1-jX-3EK_yspYDgPIy5vwnRKHntw9-dQIpFVhLc5JcXc/edit?gid=0#gid=0"

# upload to google sheet under sheet name "ubereats_sanxia_looker"
googlesheets4::write_sheet(ubereats_sanxia_select, gsUrl, 
sheet = "ubereats_sanxia_looker")

# do the same for township "新店"
ubereats_xindian <- ubereats %>%
  dplyr::filter(str_detect(township, "新店"))

bbox_xindian <- c(left = min(ubereats_xindian$lon) - 0.01,
                  bottom = min(ubereats_xindian$lat) - 0.01,
                  right = max(ubereats_xindian$lon) + 0.01,
                  top = max(ubereats_xindian$lat) + 0.01)

xindian_map <- get_stadiamap(bbox = bbox_xindian, zoom = 14, maptype = "stamen_toner_lite")

ggmap(xindian_map) +
  geom_point(data = ubereats_xindian, aes(x = lon, y = lat), color = "red", size = 2) +
  theme_minimal()

# export relevant columns to google sheet
ubereats_xindian$location <- paste(ubereats_xindian$lat, ubereats_xindian$lon, sep = ",")
ubereats_xindian$tooltip <- paste(ubereats_xindian$name, ubereats_xindian$rating, sep = ": ")

ubereats_xindian_select <- ubereats_xindian %>%
  dplyr::select(location, tooltip, rating)

# upload to google sheet under sheet name "ubereats_xindian_looker"
googlesheets4::write_sheet(ubereats_xindian_select, gsUrl,
sheet = "ubereats_xindian_looker")
