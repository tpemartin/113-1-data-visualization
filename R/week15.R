library(sf)
library(bigrquery)
taipei_mrt <- sf::st_read("https://raw.githubusercontent.com/tpemartin/113-1-data-visualization/refs/heads/main/public-data/TpeMRTRoutes_TWD97_%E8%87%BA%E5%8C%97%E9%83%BD%E6%9C%83%E5%8D%80%E5%A4%A7%E7%9C%BE%E6%8D%B7%E9%81%8B%E7%B3%BB%E7%B5%B1%E8%B7%AF%E7%B6%B2%E5%9C%96-121208.json")

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
project_id <- "data-science-teaching"  # Your project ID
dataset_id <- "data_visualization"       # Your dataset ID

# get data set
ds <- bq_dataset(project_id, dataset_id)

## 5. upload the data to big query in a specific table with the fields
table_name <- "taipei_mrt_practice"  # Your table name
bq_table_upload(
    x = bq_table(ds, table_name),
    values = taipei_mrt_bq,
    fields = fields,
    create_disposition = "CREATE_IF_NEEDED"
)


library(dplyr)

project_id <- "data-science-teaching"
data_set <- "data_visualization"

# create a connection
con <- dbConnect(
  bigrquery::bigquery(),
  project = project_id,
  dataset = data_set
)
