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

# simplify shp_crop simple feature data frame
library(sf)  # Ensure the sf package is available

tidy_simplified_shp_crop <- st_simplify(shp_crop, preserveTopology = TRUE, dTolerance = 1)

# Plot the simplified shapefile
ggplot() +
  geom_sf(
    data = tidy_simplified_shp_crop,
    mapping = aes(fill = pop)
  )

# use 
# 24.94999
# 121.35977
# 121.38521
# 24.93562
# to create a bounding box for OSM data
library(osmdata)
bbox_osm <- c(xmin = 121.35977, ymin = 24.93562, xmax = 121.38521, ymax = 24.94999)

# request OSM data where feature key is "building" and feature value is "university"
# using open pass query (OPQ) language

osmdata_query <- opq(bbox_osm) %>% 
     add_osm_feature(key="building", value="university") 

# obtain osmdata using the query
osmdata <- osmdata_sf(osmdata_query)

osmdata

glimpse(osmdata$osm_polygons)

# ntpu building sf
ntpu_building_sf <- osmdata$osm_polygons
glimpse(ntpu_building_sf)

# plot ntpu building sf
ggplot() +
  geom_sf(
    data = ntpu_building_sf
  )

# new bbox from
# 

# 25.06316
# 121.50630
# 121.60810
# 25.00569

bbox_osm_mrt <- c(xmin = 121.50630, ymin = 25.00569, xmax = 121.60810, ymax = 25.06316)

# request OSM data where feature key is "railway" and feature value is "subway"
# using open pass query (OPQ) language

osmdata_query_mrt <- opq(bbox_osm_mrt) %>% 
     add_osm_feature(key="railway", value="subway")

# obtain osmdata using the query
osmdata_mrt <- osmdata_sf(osmdata_query_mrt)

tpe_mrt_sf <- osmdata_mrt$osm_lines

# graph
ggplot() +
  geom_sf(
    data = tpe_mrt_sf
  )
