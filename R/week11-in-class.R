# sf & sp packages
install.packages("sf")
install.packages("sp")

library(tidyverse)
library(sf)
# import shp file
shpPath <- "data/直轄市、縣(市)界線檔(TWD97經緯度)1130719/COUNTY_MOI_1130718.shp"
shp <- st_read(shpPath)

glimpse(shp)

ggplot()+
  geom_sf(data = shp,
  
  mapping=aes(
    fill = COUNTYNAME
  ))

## create a column of numeric values to represent a fake population size
shp$pop <- rnorm(nrow(shp), mean = 100000, sd = 10000)

glimpse(shp)

ggplot() +
  geom_sf(
    data = shp,
    mapping = aes(fill = pop)
  )

## check shp's bbox
tw_bbox <- st_bbox(shp)
## change ymin of bbox to 21.5
tw_bbox['ymin'] <- 21.5
## crop shp based on the new bbox
shp_crop <- st_crop(shp, tw_bbox)

ggplot() +
  geom_sf(
    data = shp_crop,
    mapping = aes(fill = pop)
  )

