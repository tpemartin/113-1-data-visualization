# Color

## Hue

![](https://www.beachpainting.com/images/color_colorwheel.png)

## Saturation and Value 

![](https://i.ytimg.com/vi/clVjrPv5Xqc/maxresdefault.jpg)

  - Saturation: the intensity of the color. Color被完全飽和時，是最純粹的顏色，color被完全淡化時，是灰色。  
  - Value：the brightness of the color. Value越高，顏色越亮，Value越低，顏色越暗。
  
> :exclamation: 但在資料視覺化中，資料值越高，color value越低，顏色越暗。

## 顏色空間

  - 顏色數值的表示法有很多種，最常見的是RGB和Hexadecimal。
  - RGB: 三原色的比例，範圍是0~255。如：rgb(0, 0, 255)表示純藍色。
  - Hexadecimal: 用16進位表示，範圍是00~FF。如：#0000FF表示純藍色。
  - 顏色數值的表示法，可以用[Color Picker](https://www.google.com/search?q=color+picker)來找到。

## 顏色與資料視覺化

### 1. 資料數值與color value

  1. 數值及ordered factor有大小之分，所以使用Color Value的差異來表示數值的大小。**資料數值越大**，Color Value越低，**顏色越暗**。  
  2. 兩極化的數值，可以使用兩極化的顏色，如兩黨支持率，在極端值的顏色最暗，中間值的顏色最低。
  3. 在空間中，由數值來進行填色除了使用Value的差異，也可以使用兩個hue但不同value來建立調色盤（後續在地圖講到），這樣可以讓相鄰的區域有明顯的差異，如地圖上的海拔高度。
   
<details>

<summary>AI prompts</summary>

For numerical and ordered factor variables, large color value is for small data value, and small color value is for large data value. 

 </details>
   
### 2.主配角與色溫

    1. 色溫：暖色系和寒色系。暖色系有紅、橙、黃，寒色系有綠、藍、紫。暖色系的顏色會讓人感到溫暖，寒色系的顏色會讓人感到涼爽。
    2. 主配角：主要的資訊用暖色系，次要的資訊用寒色系。
   
![](https://www.colorpsychology.org/wp-content/uploads/2018/09/warm-cool-color-list-2-300x280.jpg)


<details>

<summary>AI prompts</summary>
 Warm colors are for main information, cool colors are for secondary information.
   
</details>

### 3.類別與色像hue

色彩學裡的color schemes是很好的選色依據。

  1. Color schemes: <https://www.webascender.com/blog/understanding-color-schemes-choosing-colors-for-your-website/> Common color schemes: supplementary, complementary, analogous, triadic, tetradic, monochromatic, achromatic.
  2. 若其他美學元素已呈現類別，如形狀、大小、線條、位置等，則不使用顏色美學在ggplot中。
  3. 截然不同類別，Hue的差異越大越好。 
  4. 相似類別（有大類又有小類時），可以固定Hue用Saturation和Value的差異形成子類，但有時也可以使用相近的Hue, 即analogous color。
  5. 類別若有主配角之分，主角是暖色系，配角是寒色系。

   
<details>

<summary>AI prompts</summary>

When apply color to factor variable (but excluding ordered factor), ask for what levels are main role (main information) and what levels are secondary role (secondary information). For main role, use warm colors scheme, for secondary role, use cool colors scheme. Different levels should have as different hue as possible within its color scheme. If I supply a range of hue to be the color scheme restriction, obey it as much as possible.


</details>

### 4.視線與色彩飽合度

色彩飽合度指得是眼睛感受逼的色彩鮮豔程度，越鮮艷，越吸睛。  
1. 顏色飽合度：飽和度越高，顏色越鮮豔，飽和度越低，顏色越灰暗。  
2. 來自相同類別變數的顏色，飽和度應盡量相同。  
3. Color value是一個顏色的明暗程度，飽和度是一個顏色的鮮豔程度。明暗度會影響飽和度的感受，但較暗的顏色不一定飽和度會比一個較明亮的顏色低。

<details>

<summary>AI prompts</summary>

Colors picked for the same factor variable (excluding ordered factor variable) should have the same saturation -- or as similar as possible. However, ordered factor variable should have different color values for different levels.

</details>

## 灰色

相同color value的紅、綠、藍混在一起，即灰色。灰色是中性色，可以用來表示中立、中間、中庸。

  - <https://hyp.is/1TjfXJcPEe-Qw2-ehVJh4Q/academy.datawrapper.de/article/140-what-to-consider-when-choosing-colors-for-data-visualization>

    1. 灰色是中性色，可以用來表示中立、中間、中庸。
    2. 灰色可以用來表示無資料、無意義、無法分類。
    3. 灰色可以用來表示不重要的資訊。
    4. 灰色可以用來表示不確定的資訊。
   
> :exclamation: 當視覺化覺得色彩太過於繽紛，可以考慮使用灰色來減少視覺干擾。加入灰色到彩色中，叫mute color。

> :exclamation: 顏色的hex code是由三個2位數數字組成前面再加上#，如#808080分別代表相同80 color value的紅、綠、藍。color value為16進位，所以0~255的數字，16進位是00~FF。顏色越白，color value越高，顏色越黑，color value越低，所以如果你相對圖形灰色的深淺調整，可以直接調整color value。