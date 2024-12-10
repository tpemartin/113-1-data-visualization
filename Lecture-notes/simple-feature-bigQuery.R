library(sf)
library(bigrquery)

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
table_name <- "taipei_mrt2"
bq_table_upload(
    x = bq_table(ds, table_name),
    values = taipei_mrt_bq,
    fields = fields,
    create_disposition = "CREATE_IF_NEEDED"
)
