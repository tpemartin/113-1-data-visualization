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
  ) +
  theme_void()

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
    subtitle = "no crs adjustment"
  ) +
  theme_void()

# 取得修訂過的地圖
revised_map <- ntpudatavis::ggmap_bbox(tw_map)

# 繪製地圖並疊加簡單特徵數據
ggmap(revised_map) +
  geom_sf(
    data = st_transform(tw_shp_crop, crs = 3857),
    fill = "blue", color = "white", alpha = 0.3,
    inherit.aes = FALSE
  ) +
  theme_void() +
  labs(
    title = "Taiwan counties overlay on Stadia map",
    subtitle = "crs adjustment to EPSG:3857"
  )

# save a png
# Create the ggplot object with specified adjustments
adjustable_plot <- ggmap(revised_map) +
  geom_sf(
    data = st_transform(tw_shp_crop, crs = 3857),
    fill = "blue", color = "white", alpha = 0.3,
    inherit.aes = FALSE
  ) +
  theme_void() +
  labs(
    title = "Taiwan counties overlay on Stadia map",
    subtitle = "crs adjustment to EPSG:3857"
  )

# Set font sizes
adj <- 1.6
adjustable_plot <- adjustable_plot +
  theme(
    plot.title = element_text(size = 16 * adj, margin = margin(b = 10)),  # Add margin to title
    plot.subtitle = element_text(size = 14 * adj, margin = margin(b = 10)),  # Add margin to subtitle
    # plot.title = element_text(size = 16 * adj),
    # plot.subtitle = element_text(size = 14 * adj),
    axis.title = element_text(size = 12 * adj),
    axis.text = element_text(size = 10 * adj),
    plot.caption = element_text(size = 12 * adj)
  )

# Save the plot as PNG
ggsave("taiwan_counties_overlay.png",
 bg="white",
 plot = adjustable_plot, width = 29.7 * 0.8, height = 21 * 0.8 * (3/4), units = "cm", dpi = 300)


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
