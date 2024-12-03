library(tidyverse)
library(ntpudatavis)

library(bigrquery)
library(sf)
# Upload simple feature data tw_shp_crop_election2024 to BigQuery

# Transform the geometry to WKT format
tw_shp_crop_election2024_bq <- tw_shp_crop_election2024 %>%
  mutate(geometry = st_as_text(geometry))# |>
  as.data.frame() # or st_as_wkt()

taiwan_map_division1 <- tw_shp_crop |>
  mutate(
    geometry = st_as_text(geometry)
  ) |> 
  as.data.frame()

# Set your project ID and dataset name
project_id <- "data-science-teaching"  # Replace with your project ID
dataset_id <- "data_visualization"    # Replace with your dataset ID
table_id <- "taiwan_map_division1"        # Replace with your desired table name

# Authenticate (if necessary, run this once in your R session)
bq_auth(path = "private/data-science-teaching-030ac96e881b.json")  # Replace with your service account path if applicable

# Create the BigQuery table and upload the data
bq_table <- bq_table(project_id, dataset_id, table_id)
project_id <- "your-gcloud-project-id"
dataset_id <- "your_dataset"
table_id <- "your_table"

# Define the BigQuery table
bq_table <- bq_table(project_id, dataset_id, table_id)

# Upload data to BigQuery
bq_table_upload(
  x = bq_table,
  values = taiwan_map_division1,
  fields = list( # Manually specify the schema here
    list(name = "geometry", type = "GEOGRAPHY")
  ),
  create_disposition = "CREATE_IF_NEEDED",
  write_disposition = "WRITE_TRUNCATE"
)

# bq_perform_upload(bq_table, tw_shp_crop_election2024_bq, overwrite = TRUE)

