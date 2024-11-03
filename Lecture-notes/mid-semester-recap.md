# Mid-semester recap

## What we have learned so far  

  1. class setup: Google classroom, Posit, ChatGPT  
  2. data visualization task flow: data import, data tidying, data visualization, data connection, Looker Studio.  
  3. the importance of **variable classes** in R and **column format** in Google Sheets: tidy in R before uploading to Google Sheets. 
  4. The basic three in Looker studio: dimension, metric, and breakdown dimension. 
  5. Categorical data: the importance of factor level order in R and the importance of sorting in Looker Studio.


## 亞洲首站抵達地點

繪製歷年不同亞洲首站抵達地點人次比例的面積圖（area chart）。

 1. [原始資料引入](https://docs.google.com/spreadsheets/d/1-jX-3EK_yspYDgPIy5vwnRKHntw9-dQIpFVhLc5JcXc/edit?gid=1662522658#gid=1662522658)  
 2. Tidy data: 
    1. 產生"歷年"所對應variable的**date class** variable in R, and its **date format** in Google Sheets.  [flightDestinationAsia-looker](https://docs.google.com/spreadsheets/d/1-jX-3EK_yspYDgPIy5vwnRKHntw9-dQIpFVhLc5JcXc/edit?gid=1550447151#gid=1550447151)  
    2. 減少首站抵達地點細分的factor level數量，只留下大中國（中，港澳），日本及其他，同時產生對應levels順序的欄位"細分2order"。  [flightDestinationAsia-looker-2](https://docs.google.com/spreadsheets/d/1-jX-3EK_yspYDgPIy5vwnRKHntw9-dQIpFVhLc5JcXc/edit?gid=71141138#gid=71141138)  
 3. R與Looker圖形繪製.  