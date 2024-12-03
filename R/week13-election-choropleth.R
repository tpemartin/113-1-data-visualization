# choropleth chart

## Outline ----
### load sf data
### load election data
### merge data


## Load the data ----

### load sf data ----

library(tidyverse)
library(sf)

# 引入縣市simple feature-----

shpPath <- "data/直轄市、縣(市)界線檔(TWD97經緯度)1130719/COUNTY_MOI_1130718.shp"

# load the Taiwan shp file
tw_shp <- st_read(shpPath)

# simplify the Taiwan shp
tw_shp_simplified <- st_simplify(tw_shp, dTolerance = 0.01)

# Taiwan bbox
tw_bbox <- st_bbox(tw_shp_simplified)

# crop xmin to 21.5
tw_bbox["xmin"] <- 21.5

# crop Taiwan shp
tw_shp_crop <- st_crop(tw_shp, tw_bbox)
saveRDS(tw_shp_crop, "data/tw_shp_crop.rds")

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

candidate_colors <- list(
    "侯友宜趙少康" = "#0215aa",
    "柯文哲吳欣盈" = "#60c4c6",
    "賴清德蕭美琴" = "#009b01"
)

glimpse(tw_shp_crop_election)

sf_candidate_lai <- tw_shp_crop_election |>
    dplyr::filter(candidate == "賴清德蕭美琴")

summary(sf_candidate_lai$support_rate)

library(ggplot2)
library(sf)

# Create a choropleth map
choropleth_map <- ggplot() +
    geom_sf(
        data = st_transform(
            tw_shp_crop_election |>
                dplyr::filter(candidate == "賴清德蕭美琴"),
            crs = 3857
        ),
        aes(fill = support_rate),
        inherit.aes = FALSE
    ) +
    scale_fill_gradient(
        low = "white", high = candidate_colors[["賴清德蕭美琴"]], na.value = "transparent",
        guide = "legend", labels = scales::percent_format(scale = 100)
    ) +
    theme_void()

choropleth_map

# create choropleth map function with candidate as input ----

create_choropleth_map <- function(candidate_name) {
    choropleth_map <- ggplot() +
        geom_sf(
            data = st_transform(
                tw_shp_crop_election |>
                    dplyr::filter(candidate == candidate_name),
                crs = 3857
            ),
            aes(fill = support_rate),
            inherit.aes = FALSE
        ) +
        scale_fill_gradient(
            low = "white", high = candidate_colors[[candidate_name]], na.value = "transparent",
            guide = "legend", labels = scales::percent_format(scale = 100)
        ) +
        theme_void() +
        theme(
            legend.position = "bottom"
        )

    return(choropleth_map)
}

# create choropleth map for each candidate ----

choropleth_map_hou <- create_choropleth_map("侯友宜趙少康")
choropleth_map_ke <- create_choropleth_map("柯文哲吳欣盈")
choropleth_map_lai <- create_choropleth_map("賴清德蕭美琴")

choropleth_map_hou
choropleth_map_ke
choropleth_map_lai

# with limits for scale_fill_gradient ----
create_choropleth_map <- function(candidate_name, limits=NULL) {
    choropleth_map <- ggplot() +
        geom_sf(
            data = st_transform(
                tw_shp_crop_election |>
                    dplyr::filter(candidate == candidate_name),
                crs = 3857
            ),
            aes(fill = support_rate),
            inherit.aes = FALSE
        ) +
        scale_fill_gradient(
            limits = limits,
            low = "white", high = candidate_colors[[candidate_name]], na.value = "transparent",
            guide = "legend", labels = scales::percent_format(scale = 100)
        ) +
        theme_void() +
        theme(
            legend.position = "bottom"
        )+
        labs(
            fill=NULL
        )

    return(choropleth_map)
}

# create choropleth map for each candidate ----

## No limits
choropleth_map_hou <- create_choropleth_map("侯友宜趙少康")
choropleth_map_hou
choropleth_map_ke <- create_choropleth_map("柯文哲吳欣盈")
choropleth_map_ke
choropleth_map_lai <- create_choropleth_map("賴清德蕭美琴")
choropleth_map_lai

## With limits c(0,0.7)
choropleth_map_hou_limit <- create_choropleth_map("侯友宜趙少康", c(0, 0.7))
choropleth_map_ke_limit <- create_choropleth_map("柯文哲吳欣盈", c(0, 0.7))
choropleth_map_lai_limit <- create_choropleth_map("賴清德蕭美琴", c(0, 0.7))


# put maps together ----

library(patchwork)

# No limits with title "NO LIMITS"

choropleth_map_hou + choropleth_map_ke + choropleth_map_lai +
    plot_annotation(title = "NO LIMITS")

# With limits with title "LIMITS"

choropleth_map_hou_limit + choropleth_map_ke_limit + choropleth_map_lai_limit +
    plot_annotation(title = "LIMITS")



# overlay ggmap ----

library(ggmap)
library(ntpudatavis)

# Extract the bounding box
source_bbox <- sf::st_bbox(tw_shp_crop_election)
names(source_bbox) <- c("left", "bottom", "right", "top")

# Get the stadia map
tw_map <- get_stadiamap(
    source_bbox,
    zoom = 7,
    maptype = "stamen_toner_lite"
)

# Revise the map for ggmap
revised_map <- ntpudatavis::ggmap_bbox(tw_map)

# Create the choropleth map
choropleth_map <-
    ggmap(revised_map) +
    geom_sf(
        data = st_transform(sf_candidate_lai, crs = 3857),
        alpha = 0.5,
        aes(fill = votes_rate), inherit.aes = FALSE
    ) +
    scale_fill_gradient(
        low = "white", high = "#009b01", na.value = "transparent",
        guide = "legend", labels = scales::percent_format(scale = 100)
    ) +
    theme_void()

choropleth_map

# three candidates ----

library(dplyr)
library(sf)

# Determine the candidate with the highest votes_rate for each COUNTYNAME
highest_votes_rate <- tw_shp_crop_election %>%
    group_by(COUNTYNAME) %>%
    arrange(desc(votes_rate)) %>%
    slice(1)

glimpse(highest_votes_rate)

# Split the data into separate data frames based on the candidate
split_data <- highest_votes_rate %>%
    split(highest_votes_rate$candidate)

highest_votes_rate2 <- tw_shp_crop_election %>%
    group_by(COUNTYNAME) %>%
    arrange(desc(votes_rate)) %>%
    slice(1, 2)

glimpse(highest_votes_rate2)

unique(highest_votes_rate2$candidate)
unique(highest_votes_rate$candidate)

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
levels(election2024$party) <- c("民眾黨", "民進黨", "國民黨")

# 計算各行政區別各candidate的得票率
election2024 <- election2024 %>%
    group_by(行政區別) %>%
    mutate(votes_rate = votes / sum(votes)) %>%
    ungroup()

# merge election2024 with tw_shp_crop
tw_shp_crop_election2024 <- tw_shp_crop %>%
    left_join(election2024, by = c("COUNTYNAME"="行政區別"))

glimpse(tw_shp_crop_election2024)
class(tw_shp_crop_election2024)

