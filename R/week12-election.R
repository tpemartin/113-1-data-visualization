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

# plot the Taiwan shp
ggplot() +
    geom_sf(
        data = tw_shp_crop
    )

glimpse(tw_shp_crop)

# 引入總統選舉資料-----

library(readxl)
election <- read_excel("data/2024-taiwan-presidential-election/總統-各投票所得票明細及概況(Excel檔)/總統-A05-1-候選人得票數一覽表(中　央).xlsx", skip = 1)

election |> names()
election[1, 2:4] |>
    unlist() -> names(election)[2:4]

election |> names()

glimpse(election)

election <- election[-c(1:3), ]

glimpse(election)

# parse column 2:4 as numeric
election[2:4] <- lapply(election[2:4], as.numeric)

# parse last column as numeric
last_col <- ncol(election)
election[last_col] <- lapply(election[last_col], as.numeric)

glimpse(election)

# 去除election變數名稱中非中文及英文，和數字的字元-----

election |>
    names() |>
    str_replace_all("[^[:alnum:]]|[A-Z]|[0-9]", "") -> names(election)

names(election)

# remove " " in $行政區別
election$行政區別 |> str_trim() -> election$行政區別


election_long <- election |>
    tidyr::pivot_longer(cols = 2:4, names_to = "candidate", values_to = "votes")

glimpse(election_long)

names(election_long)
# 計算不同candidate的得票率 = votes / sum(votes)

election_long |>
    group_by(行政區別) |>
    mutate(
        votes_rate = votes / sum(votes)
    ) |>
    ungroup() -> election_long


# merge election_long with tw_shp_crop -----

election_long2 <- election_long |>
    left_join(tw_shp_crop, by = c("行政區別" = "COUNTYNAME"))

class(election_long2)

## Must use sf object as the target to join,
## i.e. augment the columns of sf, but not the other way around
tw_shp_crop2 <- tw_shp_crop |>
    left_join(
        election_long,
        by = c("COUNTYNAME" = "行政區別")
    )

tw_shp_crop2 |> class()

## plot candidate == "賴清德蕭美琴" 的votes_rate choropleth map

ggplot() +
    geom_sf(
        data = tw_shp_crop2,
        aes(fill = votes_rate),
        color = "white"
    ) +
    scale_fill_viridis_c() +
    labs(
        title = "賴清德蕭美琴得票率",
        subtitle = "2024總統選舉"
    ) +
    theme_void()

## modify the fill color
ggplot() +
    geom_sf(
        data = tw_shp_crop2,
        aes(fill = `votes_rate`),
        color = "white",
        inherit.aes = FALSE
    ) +
    scale_fill_gradientn(
        colors = c("white", "#009b01"),
        values = scales::rescale(c(0, 1)), # Rescale to map 0 to white and 1 to the green color
        na.value = "grey" # Color for NA values, optional
    ) +
    theme_void() +
    labs(
        title = "賴清德/蕭美琴得票率",
        subtitle = "2024總統選舉",
        fill = "得票率"
    )

#
glimpse(tw_shp_crop2)

# column chart

library(dplyr)
library(ggplot2)

# Step 1: Create a tidy data frame with total votes rate for the specified candidate
total_votes <- tw_shp_crop2 %>%
    dplyr::filter(`candidate` == "賴清德蕭美琴") %>%
    group_by(`COUNTYNAME`) %>%
    summarise(total_votes_rate = sum(`votes_rate`, na.rm = TRUE)) %>%
    arrange(desc(total_votes_rate))

# Step 2: Create the stacked column plot
ggplot(tw_shp_crop2, aes(
    x = reorder(`COUNTYNAME`, match(`COUNTYNAME`, total_votes$COUNTYNAME)),
    y = `votes_rate`,
    fill = `candidate`
)) +
    geom_col() +
    scale_x_discrete(limits = total_votes$COUNTYNAME) + # Order x-axis by total votes
    labs(x = "County Name", y = "Votes Rate", title = "Stacked Column Plot of Votes Rate by Candidate") +
    theme_minimal() +
    theme(axis.text.x = element_text(angle = 45, hjust = 1))

tw_shp_crop2 <- tw_shp_crop2 |>
    mutate(
        candidate = factor(candidate)
    )

levels(tw_shp_crop2$candidate)

tw_shp_crop2 <- tw_shp_crop2 |>
    mutate(
        candidate = factor(candidate,
            levels = c("賴清德蕭美琴", "韓國瑜張善政", "柯文哲陳其邁")
        )
    )

library(dplyr)
library(ggplot2)

# Step 1: Create a tidy data frame with total votes rate for the specified candidate
total_votes <- tw_shp_crop2 %>%
    filter(`candidate` == "賴清德蕭美琴") %>%
    group_by(`COUNTYNAME`) %>%
    summarise(total_votes_rate = sum(`votes_rate`, na.rm = TRUE)) %>%
    arrange(desc(total_votes_rate))

# Step 2: Create the stacked column plot with specified fill colors
ggplot(tw_shp_crop2, aes(
    x = reorder(`COUNTYNAME`, match(`COUNTYNAME`, total_votes$COUNTYNAME)),
    y = `votes_rate`,
    fill = `candidate`
)) +
    geom_col() +
    scale_x_discrete(limits = total_votes$COUNTYNAME) + # Order x-axis by total votes
    scale_fill_manual(values = c(
        "侯友宜趙少康" = "#0215aa",
        "柯文哲吳欣盈" = "#60c4c6",
        "賴清德蕭美琴" = "#009b01"
    )) +
    labs(x = "County Name", y = "Votes Rate", title = "Stacked Column Plot of Votes Rate by Candidate") +
    theme_minimal() +
    theme(axis.text.x = element_text(angle = 45, hjust = 1))

library(dplyr)
library(ggplot2)

# Step 1: Create a tidy data frame with total votes rate for the specified candidate
total_votes <- tw_shp_crop2 %>%
    filter(`candidate` == "賴清德蕭美琴") %>%
    group_by(`COUNTYNAME`) %>%
    summarise(total_votes_rate = sum(`votes_rate`, na.rm = TRUE)) %>%
    arrange(desc(total_votes_rate))

# Step 2: Create the stacked column plot with specified fill colors and modifications
ggplot(tw_shp_crop2, aes(
    x = reorder(`COUNTYNAME`, match(`COUNTYNAME`, total_votes$COUNTYNAME)),
    y = `votes_rate`,
    fill = `candidate`
)) +
    geom_col() +
    scale_x_discrete(limits = total_votes$COUNTYNAME) + # Order x-axis by total votes
    scale_fill_manual(values = c(
        "侯友宜趙少康" = "#0215aa",
        "柯文哲吳欣盈" = "#60c4c6",
        "賴清德蕭美琴" = "#009b01"
    )) +
    geom_hline(yintercept = 0.5, linetype = "dashed", color = "red") + # Horizontal line at y=0.5
    labs(x = "County Name", y = "Votes Rate", title = "Stacked Column Plot of Votes Rate by Candidate") +
    coord_flip() + # Flip the coordinates
    theme_minimal() +
    theme(
        axis.text.x = element_text(angle = 45, hjust = 1),
        legend.position = "bottom"
    ) # Position legend at the bottom

library(dplyr)
library(ggplot2)

# Step 1: Create a tidy data frame with total votes rate for the specified candidate
total_votes <- tw_shp_crop2 %>%
    dplyr::filter(`candidate` == "賴清德蕭美琴") %>%
    group_by(`COUNTYNAME`) %>%
    summarise(total_votes_rate = sum(`votes_rate`, na.rm = TRUE)) %>%
    arrange(desc(total_votes_rate))

# Step 2: Create the stacked column plot with specified fill colors and modifications
ggplot(tw_shp_crop2, aes(
    x = reorder(`COUNTYNAME`, -match(`COUNTYNAME`, total_votes$COUNTYNAME)),
    y = `votes_rate`,
    fill = `candidate`
)) +
    geom_col() +
    scale_x_discrete(limits = rev(total_votes$COUNTYNAME)) + # Order x-axis by total votes
    scale_fill_manual(values = c(
        "侯友宜趙少康" = "#0215aa",
        "柯文哲吳欣盈" = "#60c4c6",
        "賴清德蕭美琴" = "#009b01"
    )) +
    geom_hline(yintercept = 0.5, linetype = "dashed", color = "#ffffff") + # Horizontal line at y=0.5
    labs(x = "County Name", y = "Votes Rate", title = "Stacked Column Plot of Votes Rate by Candidate") +
    coord_flip() + # Flip the coordinates
    theme_minimal() +
    theme(
        axis.text.x = element_text(angle = 45, hjust = 1),
        legend.position = "bottom"
    ) # Position legend at the bottom

library(dplyr)
library(ggplot2)

# Step 1: Create a tidy data frame with total votes rate for the specified candidate
total_votes <- tw_shp_crop2 %>%
    filter(`candidate` == "賴清德蕭美琴") %>%
    group_by(`COUNTYNAME`) %>%
    summarise(total_votes_rate = sum(`votes_rate`, na.rm = TRUE)) %>%
    arrange(desc(total_votes_rate))

# Step 2: Create the stacked column plot with specified fill colors and modifications
ggplot(tw_shp_crop2, aes(
    x = reorder(`COUNTYNAME`, -match(`COUNTYNAME`, total_votes$COUNTYNAME)),
    y = `votes_rate`,
    fill = `candidate`
)) +
    geom_col() +
    scale_x_discrete(limits = rev(total_votes$COUNTYNAME), expand = c(0, 0)) + # Remove expand limits for x axis
    scale_y_continuous(expand = c(0, 0)) + # Remove expand limits for y axis
    scale_fill_manual(values = c(
        "侯友宜趙少康" = "#0215aa",
        "柯文哲吳欣盈" = "#60c4c6",
        "賴清德蕭美琴" = "#009b01"
    )) +
    geom_hline(yintercept = 0.5, linetype = "dashed", color = "#fafafa") + # Horizontal line at y=0.5
    labs(
        x = NULL, y = NULL,
        fill = NULL,
        title = "2024總統大選各組候選人得票率"
    ) +
    coord_flip() + # Flip the coordinates
    theme_minimal() +
    theme(legend.position = "bottom") # Position legend at the bottom

library(dplyr)
library(ggplot2)


## Reorder the counties based on the total votes rate for the specified candidate ----
# Step 1: Create a tidy data frame with total votes rate for the specified candidate
total_votes <- tw_shp_crop2 %>%
    dplyr::filter(`candidate` == "賴清德蕭美琴") %>%
    group_by(`COUNTYNAME`) %>%
    summarise(total_votes_rate = sum(`votes_rate`, na.rm = TRUE)) %>%
    arrange(desc(total_votes_rate)) %>%
    pull(`COUNTYNAME`) # Extract ordered county names as a vector

# Step 2: Convert COUNTYNAME to a factor with specified levels for plotting
tw_shp_crop2 <- tw_shp_crop2 %>%
    mutate(`COUNTYNAME` = factor(`COUNTYNAME`, levels = total_votes))

# Step 3: Create the stacked column plot with specified fill colors and modifications
ggplot(tw_shp_crop2, aes(
    x = `COUNTYNAME`,
    y = `votes_rate`,
    fill = `candidate`
)) +
    geom_col() +
    scale_x_discrete(expand = c(0, 0)) + # Remove expand limits for x axis
    scale_y_continuous(expand = c(0, 0)) + # Remove expand limits for y axis
    scale_fill_manual(values = c(
        "侯友宜趙少康" = "#0215aa",
        "柯文哲吳欣盈" = "#60c4c6",
        "賴清德蕭美琴" = "#009b01"
    )) +
    geom_hline(yintercept = 0.5, linetype = "dashed", color = "white") + # Horizontal line at y=0.5
    labs(x = "County Name", y = "Votes Rate", title = "Stacked Column Plot of Votes Rate by Candidate") +
    coord_flip() + # Flip the coordinates
    labs(
        x = NULL, y = NULL,
        fill = NULL,
        title = "2024總統大選各組候選人得票率"
    ) +
    theme_minimal() +
    theme(
        axis.text.x = element_text(angle = 45, hjust = 1),
        legend.position = "bottom"
    ) # Position legend at the bottom

# upload to google sheets without geometry column
gsUrl <- "https://docs.google.com/spreadsheets/d/1-jX-3EK_yspYDgPIy5vwnRKHntw9-dQIpFVhLc5JcXc/edit?gid=0#gid=0"
sheetname <- "2024-總統大選-looker"

# convert sf object tw_shp_crop2 to data frame without geometry column
tw_shp_crop2_df <- tw_shp_crop2 |>
    st_drop_geometry()

# export to google sheets
googlesheets4::write_sheet(tw_shp_crop2_df, gsUrl, sheet = sheetname)

# levels of $COUNTYNAME

levels(tw_shp_crop2$COUNTYNAME) |> 
length()

# levels of $candidate

levels(tw_shp_crop2$candidate)

