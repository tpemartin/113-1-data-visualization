library(tidyverse)
library(DBI)
library(dplyr)

project_id <- "data-science-teaching"
data_set <- "data_visualization"

# create a connection
con <- dbConnect(
  bigrquery::bigquery(),
  project = project_id,
  dataset = data_set
)

# list all tables from the connection
