
flightDestinationAsia in the global environment has the following glimpse structure:
Rows: 378
Columns: 4
$ 首站抵達地 <chr> "亞洲地區", "亞洲地區", "亞洲地區", "亞洲地區", "亞洲地區", "亞洲地區", "亞洲地區", "亞…
$ 細分       <chr> "日本Japan", "日本Japan", "日本Japan", "日本Japan", "日本Japan", "日本Japan", "日本Japan…
$ Year       <dttm> 2002-01-01, 2003-01-01, 2004-01-01, 2005-01-01, 2006-01-01, 2007-01-01, 2008-01-01, 200…
$ Counts     <dbl> 797460, 731330, 1051954, 1180406, 1214058, 1280853, 1309847, 1113857, 1377957, 1136394, …
畫出不同`細分`的`Counts`之時間趨勢圖，並以不同顏色區分不同`細分`。

flightDestinationAsio$細分 的levels順序依照其`Counts`的總和由大到小排序。

flightDestinationAsio$細分是factor class variable, 產生"細分2"欄位，它是`細分`的levels只留下前四類，剩餘類別合併成"其他"一類。


