# Simpe Feature and BigQuery

## 台北捷運線

### GeoJSON

  - <https://data.gov.tw/dataset/121208>
  
### 引入


### 繪圖






# BigQuery

BigQuery is a serverless, highly scalable, and cost-effective multi-cloud data warehouse designed for business agility. It enables super-fast SQL queries using the processing power of Google's infrastructure. Simply move your data into BigQuery and let us handle the hard work. You can control access to both the project and your data based on your business needs, such as giving others the ability to view or query your data.


To upload a feature with a geometry column as a GEOGRAPHY data type to BigQuery using R, you can follow these steps:

1. **Install the Necessary Packages**:
   Ensure that you have the `bigrquery`, `sf`, and `dplyr` packages installed. You can install them using:

   ```r
   install.packages("bigrquery")
   install.packages("sf")
   install.packages("dplyr")
   ```

2. **Load the Required Libraries**:
   Load the libraries in your R script or R session:

   ```r
   library(bigrquery)
   library(sf)
   library(dplyr)
   ```

3. **Authenticate with BigQuery**:
   Use your Google Cloud credentials to authenticate:

   ```r
   bq_auth(path = "path/to/your/service-account-key.json")
   ```

4. **Create Your Spatial Data**:
   Create an `sf` object. For example, create a simple feature collection with a GEOMETRY column:

   ```r
   # Create a simple data frame
   data <- data.frame(
     id = 1,
     wkt = "POINT(121.5654 25.0330)" # WKT for a point in Taipei
   )

   # Convert to an sf object
   sf_data <- st_as_sf(data, wkt = "wkt", crs = 4326) # Using WGS 84
   ```

5. **Convert the SF Object to a DataFrame with a GEOGRAPHY Column**:
   Convert the geometry to a GEOGRAPHY type understood by BigQuery:

   ```r
   sf_data$geography <- st_as_text(sf_data$geometry) 
   sf_data <- sf_data %>%
     select(id, geography)
   ```

6. **Upload to BigQuery**:
   Use the `bq_table_upload()` function to upload your data to a BigQuery table. Specify the dataset and table name.

   ```r
   project_id <- "your-gcloud-project-id"
   dataset_id <- "your_dataset"
   table_id <- "your_table"

   # Define the BigQuery table
   bq_table <- bq_table(project_id, dataset_id, table_id)

   # Upload data to BigQuery
   bq_table_upload(
     x = bq_table,
     values = sf_data,
     schema = bq_schema(
       id = "INTEGER",
       geography = "GEOGRAPHY"
     ),
     create_disposition = "CREATE_IF_NEEDED",
     write_disposition = "WRITE_TRUNCATE"
   )
   ```

This sequence first creates a simple feature, converts it to an appropriate format for BigQuery, and uploads it with the correct schema. Adjust the dataset, table names, and authentication details according to your setup.

## Taipei MRT

### GeoJSON

  - <https://data.gov.tw/dataset/121208>