Modify the code below:
```r
ggplot() +
  geom_sf(
    data = tw_shp_crop2,
    aes(fill = votes_rate),
    color = "white"
  )
```

where the `fill` aesthetic goes to "#009b01" when votes rate is 1, and "white" when votes rate is 0. 

```r

For the data frame `tw_shp_crop2`:
Create a stacked column plot of the $votes_rate by $candidate, where x is $COUNTYNAME, the x axis is sorted by the total votes rate in descending order for $canditate == "賴清德蕭美琴".

The fill color for the $candidate values,  "侯友宜趙少康" "柯文哲吳欣盈" "賴清德蕭美琴", should be
"#0215aa", "#60c4c6"，"#009b01" respectively.

Put a horizontal line at y=0.5, then flip the x and y axis, and put the leged on the bottom.

Reverse the $COUNTYNAME order.

Remove expand limits for x and y axis.

```r
```{r}


## get map 

When asked to get stadia map using ggmap and the bbox from a simple feature data frame (say `source_bbox`), if I did not provide zoom level or map type ask me, then use the following code to get the map:

```r
library(ggmap)
names(source_bbox) <- c("left", "bottom", "right", "top")

tw_map <- get_stadia_map(
  source_bbox,
  zoom = the zoom level I answer, 
  maptype = the map type I answer
)
```
Be careful, never use `get_stamenmap` but always use `get_stadiamap` instead.


Then use `ntpudatavis::ggmap_bbox(tw_map)` to get the revised map `tw_map_hack` and overlay the simple feature data `tw_shp_crop` on the ggmap.


Create a choropleth map use `sf_candidate_lai` simple feature data where fill determined by variable `votes_rate`, and the color is "#009b01" when votes rate is 1, and "white" when votes rate is 0.

get a stadia map using `sf_candidate_lai` bbox, and overlay the chorepleth map on the ggmap based on the obtained stadia map.

split the `tw_shp_crop_election` into three simple feature data based on which `candidate` has the highest `votes_rate` in the `COUNTYNAME`.

and create a choropleth map for each of them.


When graph uses gradient fill aesthetic but no limits are provided, ask for the limits. When limits are provided, use the limits. If the limits are not provided, use the limits from the data. 

I have a simple feature data frame `tw_shp_crop_election2024` with a multi-polygon geometry column `geometry`. I want to upload it to BigQuery. And later connect to Google Looker for map visualization. How can I do that?

glimpse(taiwan_map_division1)
Rows: 22
Columns: 2
$ COUNTYNAME <chr> "連江縣", "宜蘭縣", "彰化縣", "南投縣", "雲林縣", "屏東縣", "基隆市", "臺北市", "新北市", "臺中市", "臺南市", "桃園市", "苗栗縣", "嘉義市", "嘉義縣", "金門縣", "高雄市", "臺東縣", "花蓮縣"…
$ geometry   <chr> "MULTIPOLYGON (((119.9645 25.94553, 119.9645 25.94554, 119.9645 25.94555, 119.9645 25.94556, 119.9645 25.94557, 119.9646 25.94561, 119.9646 25.94563, 119.9646 25.94565, 119.9646 25.94566, …

provide code to upload the data to BigQuery with `$geometry` as the GEOGRAPHY type column.