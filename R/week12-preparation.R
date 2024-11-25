# Overlay Simple Features on ggmap
library(sf)
## Taiwan shp

# load the Taiwan shp file
tw_shp <- st_read("data/直轄市、縣(市)界線檔(TWD97經緯度)1130719/COUNTY_MOI_1130718.shp")

# get bbox of Taiwan shp
tw_bbox <- st_bbox(tw_shp)

# crop xmin to 21.5
tw_bbox["xmin"] <- 21.5

# crop Taiwan shp
tw_shp_crop <- st_crop(tw_shp, tw_bbox)

# plot the Taiwan shp
ggplot() +
  geom_sf(
    data = tw_shp_crop,
    fill = "blue",
    color = "white"
  ) +
  labs(
    title = "Taiwan counties"
  )

## Underlay ggmap on Taiwan sf plot ----

### Request ggmap of Taiwan
library(ggmap)


#### Taiwan bbox
tw_bbox <- st_bbox(tw_shp_crop)

names(tw_bbox)
# given names of bbox be "xmin" "ymin" "xmax" "ymax"
# change the names to "left" "bottom" "right" "top"

names(tw_bbox) <- c("left", "bottom", "right", "top")
tw_bbox

# get stadia map of Taiwan
tw_map <- ggmap::get_stadiamap(
  bbox = tw_bbox,
  zoom = 7,
  maptype = "stamen_toner_lite"
)

# plot the Taiwan map
ggmap(tw_map) +
  geom_sf(
    data = tw_shp_crop,
    fill = "blue",
    color = "white",
    alpha = 0.3,
    inherit.aes = FALSE
  ) +
  labs(
    title = "Taiwan counties overlay on Stadia map",
    subtitle="no crs adjustment"
  )

# Adjust the crs of Taiwan sf to EPSG:3857
tw_shp_crop_3857 <-
  tw_shp_crop |>
  st_set_crs(3857) |>
  st_transform(crs = 3857)

ggplot() +
  geom_sf(
    data = tw_shp_crop_3857
  )

# plot the Taiwan map with crs of EPSG:3857
ggmap(tw_map) +
  geom_polygon(
    data = tw_shp_crop_3857,
    fill = "blue",
    color = "white",
    alpha = 0.5
  ) +
  labs(
    title = "Taiwan counties overlay on Stadia map",
    subtitle="crs adjustment to EPSG:3857"
  )

# hacking bbox of ggmap ------

# Define a function to fix the bbox to be in EPSG:3857
ggmap_bbox <- function(map) {
  if (!inherits(map, "ggmap")) stop("map must be a ggmap object")
  # Extract the bounding box (in lat/lon) from the ggmap to a numeric vector, 
  # and set the names to what sf::st_bbox expects:
  map_bbox <- setNames(unlist(attr(map, "bb")), 
                       c("ymin", "xmin", "ymax", "xmax"))

  # Coonvert the bbox to an sf polygon, transform it to 3857, 
  # and convert back to a bbox (convoluted, but it works)
  bbox_3857 <- st_bbox(st_transform(st_as_sfc(st_bbox(map_bbox, crs = 4326)), 3857))

  # Overwrite the bbox of the ggmap object with the transformed coordinates 
  attr(map, "bb")$ll.lat <- bbox_3857["ymin"]
  attr(map, "bb")$ll.lon <- bbox_3857["xmin"]
  attr(map, "bb")$ur.lat <- bbox_3857["ymax"]
  attr(map, "bb")$ur.lon <- bbox_3857["xmax"]
  map
}

# Use the function:
tw_map_hack <- ggmap_bbox(tw_map)

ggmap(tw_map_hack) + 
  coord_sf(crs = st_crs(3857)) + # force the ggplot2 map to be in 3857
  geom_sf(
    data = tw_shp_crop |>
           st_transform(crs = 3857),
    fill = "blue",
    color = "white",
    alpha = 0.5,
    inherit.aes = FALSE
  )


# OSM data ----
library(osmdata)
bbox_osm <- c(xmin = 121.35977, ymin = 24.93562, xmax = 121.38521, ymax = 24.94999)

# request OSM data where feature key is "building" and feature value is "university"
# using open pass query (OPQ) language

osmdata_query <- opq(bbox_osm) %>%
  add_osm_feature(key = "building", value = "university")

# obtain osmdata using the query
osmdata <- osmdata_sf(osmdata_query)

osmdata

print(osmdata$osm_polygons)

# ntpu building sf
ntpu_building_sf <- osmdata$osm_polygons

# plot ntpu building sf
ggplot() +
  geom_sf(
    data = ntpu_building_sf
  )

# ggmap to get the map
library(ggmap)
## register stadia api key
register_stadiamaps(key = "8db6e629-ddc9-4331-9b37-4116f5664e7d", write = T)

names(bbox_osm) <- c("left", "bottom", "right", "top")

# get the map
ntpu_map <- get_stadiamap(
  bbox_osm,
  zoom = 15,
  maptype = "stamen_toner_lite"
)


# others ----

ggmap(ntpu_map) +
  geom_sf(
    data = ntpu_building_sf,
    inherit.aes = FALSE
  )

# Stadia map crs
browseURL("https://stackoverflow.com/questions/74733975/setting-crs-for-plotting-with-stamenmaps")
