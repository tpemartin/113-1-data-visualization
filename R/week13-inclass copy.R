library(tidyverse)
library(sf)
library(ntpudatavis)

# Create a choropleth map 
 choropleth_map2020 <- ggplot() + 
     geom_sf( 
         data = st_transform( 
             tw_shp_crop_election2020 %>% 
                 dplyr::filter(party == "國民黨"), 
             crs = 3857 
         ), 
         aes(fill = votes_rate), 
         inherit.aes = FALSE 
     ) + 
     scale_fill_gradient( 
         low = "white", high = "#0215aa", na.value = "transparent", 
         guide = "legend", labels = scales::percent_format(scale = 100) 
     ) + 
     theme_void() 
  
 choropleth_map2024 <- ggplot() + 
     geom_sf( 
         data = st_transform( 
             tw_shp_crop_election2024 %>% 
                 dplyr::filter(party == "國民黨"), 
             crs = 3857 
         ), 
         aes(fill = votes_rate), 
         inherit.aes = FALSE 
     ) + 
     scale_fill_gradient( 
         low = "white", high = "#0215aa", na.value = "transparent", 
         guide = "legend", labels = scales::percent_format(scale = 100) 
     ) + 
     theme_void() 

# 合併成一張圖, 標題為 "2020 2024 國民黨得票率" 
  
 library(patchwork) 
  
 choropleth_map2020 + choropleth_map2024 + 
     plot_annotation(title = "2020 2024 國民黨得票率") 
