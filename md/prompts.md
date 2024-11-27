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