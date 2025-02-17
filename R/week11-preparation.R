library(tidyverse)
library(sf)

# read shp file
taiwan <- st_read("data/直轄市、縣(市)界線檔(TWD97經緯度)1130719/COUNTY_MOI_1130718.shp")


# draw taiwan simple feature
ggplot() +
  geom_sf(data = taiwan) +
  theme_minimal() +
  theme(axis.text = element_blank(),
        axis.title = element_blank(),
        axis.ticks = element_blank(),
        panel.grid = element_blank()) +
  labs(title = "Taiwan") +
  theme(plot.title = element_text(hjust = 0.5))

# obtain data bbox
bbox <- taiwan %>% st_bbox()

# set ymin to 21
bbox["ymin"] <- 21

# crop taiwan based on new bbox
taiwan_crop <- taiwan %>% st_crop(bbox)

# draw taiwan simple feature
ggplot() +
  geom_sf(data = taiwan_crop) +
  theme_minimal() +
  theme(axis.text = element_blank(),
        axis.title = element_blank(),
        axis.ticks = element_blank(),
        panel.grid = element_blank()) +
  labs(title = "Taiwan") +
  theme(plot.title = element_text(hjust = 0.5))

# Create a map layer from ggmap using stadia map
# using bbox to get the map with zoom =8
gmapBbox <- as.numeric(bbox)
names(gmapBbox) <- c("left", "bottom", "right", "top")
# change names to c("left", "bottom", "right", "top")
gmapBbox 


library(ggmap)
register_stadiamaps("api key")

# get stadia map
map <-
  get_stadiamap(
    gmapBbox,
    zoom = 7,
    "stamen_toner_lite"
  )

# 
