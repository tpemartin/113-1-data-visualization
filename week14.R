# taipei mrt -----
library(sf)

taipei_mrt <- sf::st_read("https://raw.githubusercontent.com/tpemartin/113-1-data-visualization/refs/heads/main/public-data/TpeMRTRoutes_TWD97_%E8%87%BA%E5%8C%97%E9%83%BD%E6%9C%83%E5%8D%80%E5%A4%A7%E7%9C%BE%E6%8D%B7%E9%81%8B%E7%B3%BB%E7%B5%B1%E8%B7%AF%E7%B6%B2%E5%9C%96-121208.json")

ggplot()+
  geom_sf(data=taipei_mrt) 

library(ggmap)
library(sf)
example_sf_4326 <- st_transform(taipei_mrt, crs = 4326)
source_bbox <- sf::st_bbox(example_sf_4326)

names(source_bbox) <- c("left", "bottom", "right", "top")

tw_map <- get_stadiamap(
  source_bbox,
  zoom = 12,
  maptype = "stamen_toner_lite"
)

# 為了疊加簡單特徵`example_sf_4326`
revised_map <- ntpudatavis::ggmap_bbox(tw_map)

ggmap(revised_map) +
  geom_sf(data = st_transform(example_sf_4326, crs = 3857), inherit.aes = FALSE) +
  theme_void()

