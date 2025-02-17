library(sf) 
## Taiwan shp 

# load the Taiwan shp file 
tw_shp <- st_read("data/直轄市、縣(市)界線檔(TWD97經緯度)1130719/COUNTY_MOI_1130718.shp") 

glimpse(tw_shp)


