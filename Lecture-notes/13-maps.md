# Map: ggmap

## ggmap package

<https://cran.r-project.org/web/packages/ggmap/readme/README.html>

### 1. Stadia maps

You can explore the map centering Taiwan through

<https://stadiamaps.com/explore-the-map/#map=7.67/23.51/120.869>

    - `#map=zoom/latitude/longitude`

#### Register API

Dashboard > Manage Properties & Authentication 

![](../img/2024-11-13-10-25-50.png)

Once you have your API key, invoke the registration function: `register_stadiamaps("YOUR-API-KEY", write = FALSE)`. Note that setting write = TRUE will update your ~/.Renviron file by replacing/adding the relevant line. If you use the former, know that you’ll need to re-do it every time you reset R.


## Looker studio

[![](../img/2024-11-13-11-19-22.png)](https://lookerstudio.google.com/u/0/reporting/9d82030f-08db-465d-9df8-824cd1910412/page/p_91frx26vmd)

## Exercise

Ubereats 2024-9-27 with rating color

  - R script: <https://github.com/tpemartin/113-1-data-visualization/blob/main/R/week10-in-class.R>  
  - Google sheets: <https://docs.google.com/spreadsheets/d/1-jX-3EK_yspYDgPIy5vwnRKHntw9-dQIpFVhLc5JcXc/edit?gid=35887012#gid=35887012>  
  - Looker studio: <https://lookerstudio.google.com/u/0/reporting/9d82030f-08db-465d-9df8-824cd1910412/page/p_2v0oa3iwmd>