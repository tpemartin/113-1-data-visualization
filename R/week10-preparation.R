library(tidyverse)
library(googlesheets4)
gsUrl <- "https://docs.google.com/spreadsheets/d/1-jX-3EK_yspYDgPIy5vwnRKHntw9-dQIpFVhLc5JcXc/edit?gid=215920315#gid=215920315"
# Import the data from the sheet "2024-6-29_UberEats" in gsUrl
uberEats <- read_sheet(gsUrl, sheet = "2024-6-29_UberEats")

# write the data to a csv file
write_csv(uberEats, "data/uberEats.csv")

# import the data from the csv file
uberEats <- read_csv("data/uberEats.csv")

glimpse(uberEats)

# Plot shops on a map based on shopLat and shopLng 
ggplot(uberEats, aes(x = shopLng, y = shopLat)) +
  geom_point() +
  coord_fixed() + # make the aspect ratio 1:1 in the plot
  theme_minimal() +
  labs(title = "Shops on UberEats",
       x = "Longitude",
       y = "Latitude")

# ggmap
library(ggmap)
# create a bbox to use in ggmap's get_stadiamap 
bbox <- c(
  min(uberEats$shopLng),
  min(uberEats$shopLat),
  max(uberEats$shopLng),
  max(uberEats$shopLat)
)
# extend the bbox by 0.1
bbox <- bbox + c(-0.1, -0.1, 0.1, 0.1)

# Get the map of the bbox from stadia map
map <- get_stadiamap(bbox, zoom = 7)

# Plot the with the complement color to green. 
# The color should be muted and alpha should be 0.3
ggmap(map) +
  geom_point(data = uberEats, aes(x = shopLng, y = shopLat), color = "red", alpha = 0.3) +
  theme_minimal() +
  labs(title = "Shops on UberEats",
       x = "Longitude",
       y = "Latitude")

# Plot the with the analogous color to green. 
# The color should be muted and alpha should be 0.3
ggmap(map) +
  geom_point(data = uberEats, aes(x = shopLng, y = shopLat), color = "#5353f4", alpha = 0.3) +
  theme_minimal() +
  labs(title = "Shops on UberEats",
       x = "Longitude",
       y = "Latitude")

# Get the stamen_toner_lite map
map <- get_stadiamap(bbox, zoom = 7, maptype = "stamen_toner_lite")

# Plot the map again
ggmap(map) +
  geom_point(data = uberEats, aes(x = shopLng, y = shopLat), color = "#5353f4", alpha = 0.3) +
  theme_minimal() +
  labs(title = "Shops on UberEats",
       x = "Longitude",
       y = "Latitude")

glimpse(uberEats)

# create $location as "shopLat, shopLng"
uberEats$location <- paste(uberEats$shopLat, uberEats$shopLng, sep = ", ")
# create tooltip as "shopName, shopAddress"
uberEats$tooltip <- paste(uberEats$shopName, uberEats$shopAddress, sep = ", ")

# select location, shopName, and shopAddress
write_sheet(
    uberEats %>% select(location, tooltip),
    "https://docs.google.com/spreadsheets/d/1-jX-3EK_yspYDgPIy5vwnRKHntw9-dQIpFVhLc5JcXc/edit?gid=215920315#gid=215920315",
    sheet="ubereats-looker"
)
