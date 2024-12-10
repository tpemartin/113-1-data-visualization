# load Taiwan shp ---- 
library(tidyverse) 
library(ntpudatavis) 

class(tw_shp_crop) 
print(tw_shp_crop) 

ggplot() + 
  geom_sf(data = tw_shp_crop) 

### load election data ---- 

library(googlesheets4) 
gsUrl <- "https://docs.google.com/spreadsheets/d/1-jX-3EK_yspYDgPIy5vwnRKHntw9-dQIpFVhLc5JcXc/edit?gid=900775092#gid=900775092" 
election <- read_sheet(gsUrl, sheet = "2024-總統大選-looker") 

glimpse(election) 
class(election)

### 各COUNTYNAME各candidate, 計算得票率 ---- 

election <- election |> 
  group_by(COUNTYNAME) |> 
  dplyr::mutate( 
    support_rate = votes / sum(votes) 
  ) |> 
  ungroup() 

### merge data ---- 

tw_shp_crop_election <- tw_shp_crop |> 
  left_join(election, by = "COUNTYNAME") 

class(tw_shp_crop_election) # is a sf object 

election |> 
  left_join(tw_shp_crop, by = "COUNTYNAME") |> 
  class() # is NOT a sf object 

# Import 2024-總統大選 sheet 
 library(ntpudatavis) 
 library(googlesheets4) 
  
 gsUrl <- "https://docs.google.com/spreadsheets/d/1-jX-3EK_yspYDgPIy5vwnRKHntw9-dQIpFVhLc5JcXc/edit?gid=900775092#gid=900775092" 
 election2024 <- read_sheet(gsUrl, sheet = "2024-總統大選") 
  
 glimpse(election2024) 

# parse $ candidate to factor and check levels 
 election2024$candidate <- factor(election2024$candidate) 
 levels(election2024$candidate) 
 
 election2024$party <- election2024$candidate 
levels(election2024$party)

glimpse(election2024$party)

levels(election2024$party) <- c("民眾黨", "民進黨", "國民黨") 
head(election2024$party) 

# 計算各行政區別各candidate的得票率 
 election2024 <- election2024 %>% 
     group_by(行政區別) %>% 
     mutate(votes_rate = votes / sum(votes)) %>% 
     ungroup() 

glimpse(election2024)
glimpse(tw_shp_crop)

library(sf)

# merge election2024 with tw_shp_crop 
 tw_shp_crop_election2024 <- tw_shp_crop %>% 
     left_join(election2024, by = c("COUNTYNAME"="行政區別")) 
  
 glimpse(tw_shp_crop_election2024) 
 class(tw_shp_crop_election2024) 

tw_shp_crop_election2024 |>
 select(COUNTYNAME, votes_rate, party, geometry) |>
 glimpse()

tidy_tw_shp_crop_election2024 <- tw_shp_crop_election2024 |> 
  dplyr::filter(party == "國民黨")

tidy_tw_shp_crop_election2024 <- tw_shp_crop_election2024 |>
  filter(party == "國民黨")

# Create the plot using geom_sf
party_votes_rate_plot <- ggplot() +
  geom_sf(data = st_transform(tidy_tw_shp_crop_election2024, crs = 3857), 
          aes(fill = votes_rate), inherit.aes = FALSE) +
  scale_fill_viridis_c() + 
  theme_void()

# Display the plot
party_votes_rate_plot

party_votes_rate_plot

# Filter the data for the specified party
tidy_tw_shp_crop_election2024 <- tw_shp_crop_election2024 |>
  filter(party == "國民黨")

# Create the choropleth map
party_votes_rate_map <- ggplot() +
  geom_sf(data = st_transform(tidy_tw_shp_crop_election2024, crs = 3857), 
          aes(fill = votes_rate), inherit.aes = FALSE) +
  scale_fill_gradient(low = "white", high = "#170caa", name = "Votes Rate") +
  theme_void()

# Display the map
party_votes_rate_map

#  民進黨
tidy_tw_shp_crop_election2024 <- tw_shp_crop_election2024 |>
  dplyr::filter(party == "民進黨")

# Create the choropleth map
party_votes_rate_map <- ggplot() +
  geom_sf(data = st_transform(tidy_tw_shp_crop_election2024, crs = 3857), 
          aes(fill = votes_rate), inherit.aes = FALSE) +
  scale_fill_gradient(low = "white", high = "#2c9a00", name = "Votes Rate") +
  theme_void()

party_votes_rate_map



