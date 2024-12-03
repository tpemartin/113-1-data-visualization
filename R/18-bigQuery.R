library(tidyverse)
library(ntpudatavis)

library(bigrquery)
library(sf)
# Upload simple feature data tw_shp_crop_election2024 to BigQuery

# Transform the geometry to WKT format
tw_shp_crop_election2024_bq <- tw_shp_crop_election2024 %>%
  mutate(geometry = st_as_text(geometry))# |>
  as.data.frame() # or st_as_wkt()

# Set your project ID and dataset name
project_id <- "data-science-teaching"  # Replace with your project ID
dataset_id <- "data_visualization"    # Replace with your dataset ID
table_id <- "tw_shp_crop_election2024"        # Replace with your desired table name

# Authenticate (if necessary, run this once in your R session)
bq_auth(path = "private/data-science-teaching-030ac96e881b.json")  # Replace with your service account path if applicable

# Create the BigQuery table and upload the data
bq_table <- bq_table(project_id, dataset_id, table_id)
bq_perform_upload(bq_table, tw_shp_crop_election2024_bq, overwrite = TRUE)

