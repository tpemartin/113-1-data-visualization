library(sf)
library(bigrquery)
bq_auth()
# import taipei mrt geojson
path <- "data/TpeMRTRoutes_TWD97_臺北都會區大眾捷運系統路網圖-121208.json"
taipei_mrt <- sf::st_read(path)

# tidy up for big query
## 1. transform the CRS to 4326
taipei_mrt_4326 <- st_transform(taipei_mrt, crs = 4326)

## 2. convert geometry to WKT, and store it as a data frame
taipei_mrt_4326 %>%
    mutate(geometry = st_as_text(geometry)) |>
    as.data.frame() -> taipei_mrt_bq

## 3. create fields
fields <- taipei_mrt_bq |>
    select(-geometry) |>
    as_bq_fields()

fields <- bq_fields(
    list(
        fields,
        bq_field(name = "geometry", type = "GEOGRAPHY")
    )
)

## 4. obtain the data set from big query
project_id <- "data-science-teaching"  # Replace with your project ID
dataset_id <- "data_visualization"    # Replace with your dataset ID

# get data set
ds <- bq_dataset(project_id, dataset_id)

## 5. upload the data to big query in a specific table with the fields
table_name <- "taipei_mrt3"
bq_table_upload(
    x = bq_table(ds, table_name),
    values = taipei_mrt_bq,
    fields = fields,
    create_disposition = "CREATE_IF_NEEDED"
)


## Taiwan district sf

econDV2::Map() -> mp

mp$sf$get_sf_taiwan_simplified() -> tw_sf
tw_sf$台灣本島 -> tw_sf_mainland
tw_sf_mainland$鄉鎮區 -> tw_sf_district

glimpse(tw_sf_district)

# tidy up for big query
## 1. transform the CRS to 4326
tw_sf_district_4326 <- st_transform(tw_sf_district, crs = 4326)

## 2. convert geometry to WKT, and store it as a data frame
tw_sf_district_4326 %>%
    mutate(geometry = st_as_text(geometry)) |>
    as.data.frame() -> tw_sf_district_bq

## 3. create fields
fields <- tw_sf_district_bq |>
    select(-geometry) |>
    as_bq_fields()

fields <- bq_fields(
    list(
        fields,
        bq_field(name = "geometry", type = "GEOGRAPHY")
    )
)

## 4. obtain the data set from big query
project_id <- "data-science-teaching"  # Your project ID
dataset_id <- "data_visualization"       # Your dataset ID

# get data set
ds <- bq_dataset(project_id, dataset_id)

## 5. upload the data to big query in a specific table with the fields
table_name <- "臺灣本島鄉市鎮區"  # Your table name
bq_table_upload(
    x = bq_table(ds, table_name),
    values = tw_sf_district_bq,
    fields = fields,
    create_disposition = "CREATE_IF_NEEDED"
)

### clean names----
library(janitor)

# tidy up for big query
## 1. transform the CRS to 4326
tw_sf_district_4326 <- st_transform(tw_sf_district, crs = 4326)

## 2. convert geometry to WKT, and store it as a data frame
tw_sf_district_4326 %>%
    mutate(geometry = st_as_text(geometry)) |>
    as.data.frame() -> tw_sf_district_bq

## 3. clean column names to conform to BigQuery requirements
tw_sf_district_bq <- tw_sf_district_bq %>%
    clean_names()  # this function will convert names to snake_case

## 4. create fields
fields <- tw_sf_district_bq |>
    select(-geometry) |>
    as_bq_fields()

fields <- bq_fields(
    list(
        fields,
        bq_field(name = "geometry", type = "GEOGRAPHY")
    )
)

## 5. obtain the data set from big query
project_id <- "data-science-teaching"  # Your project ID
dataset_id <- "data_visualization"       # Your dataset ID

# get data set
ds <- bq_dataset(project_id, dataset_id)

## 6. upload the data to big query in a specific table with the fields
table_name <- "臺灣本島鄉市鎮區"  # Your table name
bq_table_upload(
    x = bq_table(ds, table_name),
    values = tw_sf_district_bq,
    fields = fields,
    create_disposition = "CREATE_IF_NEEDED"
)
