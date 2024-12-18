library(tidyverse)
library(sf)

if(!require("bigrquery")) install.packages("bigrquery")

shpPath <- "data/直轄市、縣(市)界線檔(TWD97經緯度)1130719/COUNTY_MOI_1130718.shp"

# load the Taiwan shp file
tw_shp <- st_read(shpPath)

# simplify the Taiwan shp
tw_shp_simplified <- st_simplify(tw_shp, dTolerance = 0.01)

# Taiwan bbox
tw_bbox <- st_bbox(tw_shp_simplified)

# crop xmin to 21.5
tw_bbox['xmin'] <- 21.5

# crop Taiwan shp
tw_shp_crop <- st_crop(tw_shp, tw_bbox)

# plot the Taiwan shp
ggplot() +
  geom_sf(
    data = tw_shp_crop
  )

# convert geometry to WKT
tw_shp_crop <- tw_shp_crop |>
  mutate(
    geometry = st_as_text(geometry)
  )

glimpse(tw_shp_crop)

