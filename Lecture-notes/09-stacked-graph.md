# Stacked graph （堆疊圖）

分成一般的Stacked graph和100% Stacked graph的變形。

## 一般的Stacked graph

Stacked Area Chart

| <img src="../img/stacked-area.svg" width="20%"/> | <img src="../img/stacked-column-chart.svg" width="20%"/> | <img src="../img/stacked-bar-chart.svg" width="20%"/> |
|:--:| :--: | :--: |
| Stacked Area Chart | Stacked Column Chart | Stacked Bar Chart |

  * 堆疊的最低層和最高層的變化趨勢最容易判讀。
  * 總高度有"總計"的概念。


Stacked Column Chart 



Stacked Bar Chart 

<img src="../img/stacked-bar-chart.svg" width="20%"/>

  * 底層的資料最容易判讀（儘量留給故事主角類別）。
  * 總高度有"總計"的概念。

> :exclamation: 當故事有"主角"類別且"總計"也是重要的時候，Stacked graph是一個好選擇。

  * Column/Bar chart的差別在於，各類別資料的長度，前者是欄位給定，後者是該類別的資料筆數。

## 100% Stacked graph

100% Stacked Area Chart

<img src="../img/percentage-stacked-area-chart.svg" width="20%"/>

100% Stacked Column Chart

<img src="../img/percentage-stacked-column-chart.svg" width="20%"/>

100% Stack Bar Chart

<img src="../img/percentage-stacked-bar-chart.svg" width="20%">


  * 每個類別的資料長度都是100%。  
  * 堆疊的最低層和最高層的變化趨勢最容易判讀。  
  
> :exclamation: 當故事有"1～2個重要角色"且"佔比"也是重要的時候，100% Stacked graph是一個好選擇。

## Stacking Order

  * It follows the levels of the factor variable. `levels()` function can be used to check the order of the levels.
  