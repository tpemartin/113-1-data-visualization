library(tidyverse)
library(osmdata)
library(sf)

library(osmdata)
library(sf)

# Define the bounding box using the provided coordinates
location_bbox <- c(left = 121.44467, bottom = 24.98053, right = 121.63436, top = 25.08140)

# Get the data from OpenStreetMap
subway_data <- opq(bbox = location_bbox) %>%
  add_osm_feature(key = "railway", value = "subway") %>%
  osmdata_sf()

# Extract the simple feature geometry and store it in a tidy data frame
tidy_subway_data <- subway_data$osm_lines

glimpse(tidy_subway_data)

tidy_subway_data |>
    dplyr::filter(
        str_detect(name,"線"),
        !str_detect(name,"[尾a-z]"),
        str_detect(name,"^捷運"),
    ) |>
    arrange(name) -> tidy_subway_data_filtered

# create a geo_length column
tidy_subway_data_filtered |>
    mutate(geo_length = st_length(geometry)) -> tidy_subway_data_filtered

tidy_subway_data_filtered |>
    group_by(name) |>
    arrange(desc(geo_length)) |>
    slice(1) |>
    ungroup() -> tidy_subway_data_longest

library(ggmap)

# Define the bounding box using the provided coordinates
location_bbox <- c(left = 121.44467, bottom = 24.98053, right = 121.63436, top = 25.08140)

# Prepare the bounding box for ggmap
names(location_bbox) <- c("left", "bottom", "right", "top")

# Get the stadia map
tw_map <- get_stadiamap(
  location_bbox,
  zoom = 14,
  maptype = "stamen_toner_lite"
)

ggmap(tw_map)

library(ntpudatavis)

# Transform the tidy subway data to the appropriate CRS
tidy_subway_transformed <- st_transform(tidy_subway_data, crs = 3857)

# Get the revised map for ggmap
revised_map <- ntpudatavis::ggmap_bbox(tw_map)

ggmap(revised_map) 

# Create the map with the subway overlay
ggmap(revised_map) +
  geom_sf(data = tidy_subway_transformed, inherit.aes = FALSE,
  color="green") +
  theme_void()

# GeoJSON ------
library(tidyverse)
library(sf)
# import taipei mrt geojson
path <- "data/TpeMRTRoutes_TWD97_臺北都會區大眾捷運系統路網圖-121208.json"
taipei_mrt <- sf::st_read(path)



ggplot()+
    geom_sf(data = taipei_mrt, color = "green")+
    theme_void()

# plot the map
## transform the CRS
taipei_mrt_3857 <- st_transform(taipei_mrt, crs = 3857)

ggmap(revised_map) +
  geom_sf(data = taipei_mrt_3857, inherit.aes = FALSE,
          color="green") +
  theme_void()

names(taipei_mrt_3857)

## find the center point lon, lat from the taipei_mrt data 
## store them in two variables
center_point <- taipei_mrt_3857 %>%
  st_centroid() %>%
  st_coordinates()

# save the center point in lon and lat variables in taipei_mrt
taipei_mrt_3857$lon <- center_point[,1]
taipei_mrt_3857$lat <- center_point[,2]



## label each linestring by its RouteName in the map
ggmap(revised_map) +
  geom_sf(data = taipei_mrt_3857, inherit.aes = FALSE,
          color="green") +
  geom_sf_label(data = taipei_mrt_3857, aes(label = RouteName), size = 2) +
  theme_void()

## taipei_mrt 
# import taipei mrt geojson
path <- "data/TpeMRTRoutes_TWD97_臺北都會區大眾捷運系統路網圖-121208.json"
taipei_mrt <- sf::st_read(path)

# transform the CRS to 4326
taipei_mrt_4326 <- st_transform(taipei_mrt, crs = 4326)


### tidy up for big query

## Select only RouteName and geometry columns

taipei_mrt_4326 %>%
    select(RouteName, geometry) -> taipei_mrt_bq

## Tidy up for BigQuery
library(bigrquery)

## convert geometry to WKT
taipei_mrt_bq %>%
    mutate(geometry = st_as_text(geometry)) -> taipei_mrt_bq

## obtain raw fields from data frame taipei_mrt_bq
fields <- as_bq_fields(taipei_mrt_bq)
## 
fields <- bq_fields(
  list(
    fields[[1]],
    bq_field(name = "geometry", type = "GEOGRAPHY"))
)

# Get data set
# Authenticate (if necessary, run this once in your R session)
bq_auth()

# Define the BigQuery table
# Set your project ID and dataset name
project_id <- "data-science-teaching"  # Replace with your project ID
dataset_id <- "data_visualization"    # Replace with your dataset ID

# get data set
ds <- bq_dataset(project_id, dataset_id)

# upload taipei_mrt_bq to BigQuery with the fields
bq_table_upload(
  x = bq_table(ds, "taipei_mrt"),
  values = taipei_mrt_bq |> as.data.frame(),
  fields = fields,
  create_disposition = "CREATE_IF_NEEDED",
  write_disposition = "WRITE_TRUNCATE"
)

# Ubereats ----
# import from gs
gsUrl <- "https://docs.google.com/spreadsheets/d/1-jX-3EK_yspYDgPIy5vwnRKHntw9-dQIpFVhLc5JcXc/edit?gid=215920315#gid=215920315"
sheetname <- "2024-6-29_UberEats"

## read the data from the google sheet
library(googlesheets4)
uber_eats <- read_sheet(gsUrl, sheet = sheetname)

## create lat and lon columns from shpLat and shopLng
uber_eats %>%
    mutate(lat = shopLat, lon = shopLng) -> uber_eats

uber_eats |>
  econDV2::augment_county_township_using_lon_lat() -> uber_eats

glimpse(uber_eats)

## create county_township column
uber_eats %>%
    mutate(county_township = paste0(county, township)) -> uber_eats

glimpse(uber_eats)

uber_eats %>%
    select(county_township, shopName, shopCode) -> uber_eats_selected

# upload to google sheets
write_sheet(uber_eats_selected, gsUrl, sheet = "2024-6-29 uber_eats_selected")
