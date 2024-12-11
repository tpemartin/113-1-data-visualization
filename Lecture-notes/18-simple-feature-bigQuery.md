# Simpe Feature and BigQuery

Looker studio對於simple feature要求必需是來自BigQuery的GEOGRAPHY data type：

   - 如何將simple feature上傳到BigQuery成為GEOGRAPHY data

1. 轉換simple feature
   - crs轉換成4326，確保座標系統為Google map使用的格式。
   - geometry成WKT格式[^1]的單純character class。
   - 將simple feature轉換成單純的data frame。
2. 準備在BigQuery中的fields (相當於R裡的class parsing)
   - 將geometry field設定為GEOGRAPHY data type。
3. 準備上傳BigQuery成為一個table (相當於R裡的data frame)  
   - project id, date set id, table name 設定。
   - 準備好的fields設定。
   - 轉換好的data frame。


# BigQuery

BigQuery is a serverless, highly scalable, and cost-effective multi-cloud data warehouse designed for business agility. It enables super-fast SQL queries using the processing power of Google's infrastructure.

**Install the Necessary Packages**:
   
   ```r
   install.packages("bigrquery")
   ```

![](../img/2024-12-11-09-24-24.png)

**Open BigQuery**

[課程Bq dataset分享連結](https://console.cloud.google.com/bigquery?ws=!1m4!1m3!3m2!1sdata-science-teaching!2sdata_visualization)

Need to authorize for the first time.  
![](../img/2024-12-11-09-32-40.png)

Find the table and export to Looker Studio.  
![](../img/2024-12-11-09-56-20.png)

# AI preset

## 台北捷運線

### GeoJSON

  - <https://data.gov.tw/dataset/121208>

> GeoJSON 是另一種可以用來儲存地理資訊的格式，它是一種基於 JSON 的格式，可以用來表示地理特徵、空間物件、坐標點等等。GeoJSON 是一種開放的格式，可以用來儲存地理資訊，並且可以被許多地理資訊系統所支援。引入到R中一樣會是個simple feature data frame。

### 引入

```r
# taipei mrt -----
library(sf)

taipei_mrt <- sf::st_read("https://raw.githubusercontent.com/tpemartin/113-1-data-visualization/refs/heads/main/public-data/TpeMRTRoutes_TWD97_%E8%87%BA%E5%8C%97%E9%83%BD%E6%9C%83%E5%8D%80%E5%A4%A7%E7%9C%BE%E6%8D%B7%E9%81%8B%E7%B3%BB%E7%B5%B1%E8%B7%AF%E7%B6%B2%E5%9C%96-121208.json")
```

  - 試著使用AI畫出有stadia map底圖的捷運路線圖[^2]。
  



[^1]: WKT (Well-Known Text) is a text markup language for representing vector geometry objects. It is used to describe the spatial data in a human-readable format.  
[^2]: [參考對話](https://github.com/tpemartin/113-1-data-visualization/blob/main/chat/taipei-mrt-overly-stadia-map.txt)