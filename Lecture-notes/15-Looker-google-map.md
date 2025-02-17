# Maps

There are two types of maps in Looker Studio:

1. [Google Maps](https://support.google.com/looker-studio/answer/9713352?hl=en&ref_topic=7059081&sjid=5262228410167545820-AP): Best for precise, interactive geolocation data, suitable for displaying individual data points with rich functionality. Can be complicated to set up and may require API keys.
   
2. [Geo Chart](https://support.google.com/looker-studio/answer/7065037?hl=en&ref_topic=7059081&sjid=5262228410167545820-AP): Ideal for visualizing aggregated data by regions, where the focus is on data trends across larger areas rather than specific locations. Easy to use and does not require API keys.

## Geo data for BigQuery

### AI prompt

> How to upload simple feature data in R to BigQuery as a geo data

<details>
<summary>Answer</summary>

Uploading simple feature data (like spatial data) to Google BigQuery in R involves a few steps. Here's how you can perform the operation using the `sf` package for handling spatial data and the `bigrquery` package for interacting with BigQuery.

### Prerequisites
1. **Install the required packages:** Make sure you have the necessary libraries installed. You can install them using:

   ```R
   install.packages(c("sf", "bigrquery"))
   ```

2. **Set up Google Cloud Platform:**
   - Create a Google Cloud project.
   - Enable the BigQuery API.
   - Set up a service account and download the JSON key file. 

3. **Authenticate:** Authenticate using the service account key. You can set your Google Cloud project ID using the `bigrquery` package.

### Steps to Upload Simple Feature Data to BigQuery

1. **Load necessary libraries:**

   ```R
   library(sf)
   library(bigrquery)
   ```

2. **Authenticate with your Google Cloud project:**

   ```R
   bq_auth(path = "path/to/your/service-account-key.json")
   ```

3. **Read your Simple Features (SF) data:**

   If you have your data in a shapefile or another format that `sf` supports:

   ```R
   sf_data <- st_read("path/to/your/data.shp")  # Adjust the path and format as necessary
   ```

4. **Prepare your data for uploading:**

   BigQuery requires specific formatting for geospatial data. You'll need to convert the geometry column to a format that BigQuery understands. You can convert it to Well-Known Binary (WKB) or Well-Known Text (WKT).

   ```R
   sf_data$geom <- st_as_text(sf_data$geometry)  # Convert geometry to WKT
   ```

5. **Save the dataframe in the correct format:**

   Convert the `sf` object to a regular dataframe and ensure you have a valid BigQuery schema:

   ```R
   data_to_upload <- sf::st_drop_geometry(sf_data)  # Drop geometry if not using WKT/WKB
   ```

   If you are maintaining the geometry:

   ```R
   data_to_upload <- sf_data  # Keep geometry if converted to WKT/WKB
   ```

6. **Upload the data to BigQuery:**

   You can now write the data to a BigQuery table. Specify your dataset and table name:

   ```R
   project_id <- "your-project-id"  # Replace with your project ID
   dataset <- "your_dataset_name"  # Replace with your dataset name
   table <- "your_table_name"       # Replace with your desired table name

   bq_table <- bq_table(project_id, dataset, table)

   bq_table_upload(bq_table, data_to_upload, overwrite = TRUE)
   ```

### Complete Example Code

Here is a complete code snippet for reference:

```R
library(sf)
library(bigrquery)

# Authenticate with your Google Cloud account
bq_auth(path = "path/to/your/service-account-key.json")

# Read in the spatial data
sf_data <- st_read("path/to/your/data.shp")  # Specify your shapefile or spatial data source

# Convert geometry to WKT format
sf_data$geom <- st_as_text(sf_data$geometry)

# Optionally, drop the geometry if you only need attributes
# data_to_upload <- sf::st_drop_geometry(sf_data)  
data_to_upload <- sf_data  # If keeping the WKT geometry

# Prepare to upload to BigQuery
project_id <- "your-project-id"
dataset <- "your_dataset_name"
table <- "your_table_name"

bq_table <- bq_table(project_id, dataset, table)

# Upload the data to BigQuery
bq_table_upload(bq_table, data_to_upload, overwrite = TRUE)
```

Make sure to replace the placeholders with your actual file paths, project ID, dataset, and table names. This process allows you to upload your geospatial data into BigQuery successfully.

</details>

### Simple Feature

Simple Feature is a data structure for spatial data, including the following geometry types:

  - Point
  - Line string
  - Polygon
  - Multi point
  - Multi line string
  - Multi polygon

There are also:

    - Bounding box: the boundary box of spatial data
    - CRS (coordinate reference system): the coordinate reference system of spatial data

### 