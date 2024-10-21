# Stacked graph （堆疊圖）

分成一般的Stacked graph和100% Stacked graph的變形。

## 一般的Stacked graph

Stacked Area Chart
![](../img/stacked-area.svg)

<svg width="20%" height="100%" viewBox="0 0 48 36" xmlns="http://www.w3.org/2000/svg" fit="" preserveAspectRatio="xMidYMid meet" focusable="false">
    <g fill="none">
        <path stroke="#eddafd" fill="#eddafd" d="M4 21.986l13.75-8.753L24 15.977l11.793-5.828L44 6.5v23.26H4z"></path>
        <path stroke="#d9e7fd" fill="#d9e7fd" stroke-linecap="square" d="M4 29.694l5.816-.555 6.57-5.577 6.251 2.617 7.306-6.77 6.461 4.153L44 15.5v16.93H4z"></path>
        <path stroke="#4285f4" stroke-linecap="square" d="M4 29.694l5.816-.555 6.57-5.577 6.251 2.617 7.306-6.77 6.461 4.153L44 15.5"></path>
        <path stroke="#a142f4" stroke-linecap="square" d="M4 21.906l13.807-8.688L24 15.898l11.793-5.828L43.89 6.5"></path>
    </g>
</svg> 

Stacked Column Chart 

<svg width="20%" height="100%" viewBox="0 0 48 36" xmlns="http://www.w3.org/2000/svg" fit="" preserveAspectRatio="xMidYMid meet" focusable="false">
    <g fill="none">
        <path fill="#fa7b17" d="M4.25 13.414H8v18.103H4.25zm9-6.517H17v24.62h-3.75zm8.25 6.517h3.75v18.103H21.5zM30.5 4h3.75v27.517H30.5zm9 8.69h3.75v18.827H39.5z"></path>
        <path fill="#4285f4" d="M4.25 19.931H8v11.586H4.25zm9-6.517H17v18.103h-3.75zm8.25 8.689h3.75v9.414H21.5zm9-6.517h3.75v15.931H30.5zm9 5.794h3.75v10.137H39.5z"></path>
    </g>
</svg>

Stacked Bar Chart 

<svg width="20%" height="100%" viewBox="0 0 48 36" xmlns="http://www.w3.org/2000/svg" fit="" preserveAspectRatio="xMidYMid meet" focusable="false">
    <g fill="none">
        <path d="M19.75 5v3.75h-15V5zm12 7.5v3.75h-27V12.5zm-9 7.5v3.75h-18V20zm18 7.5v3.75h-36V27.5z" fill="#4285f4"></path>
        <path fill="#fa7b17" d="M34 12.5v3.75H22V12.5zM22.75 5v3.75H13V5zM28 20v3.75h-9.75V20zm13.5 7.5v3.75H22V27.5z"></path>
    </g>
</svg>

  * 底層的資料最容易判讀（儘量留給故事主角類別）。
  * 總高度有"總計"的概念。

> :exclamation: 當故事有"主角"類別且"總計"也是重要的時候，Stacked graph是一個好選擇。

  * Column/Bar chart的差別在於，各類別資料的長度，前者是欄位給定，後者是該類別的資料筆數。

## 100% Stacked graph

100% Stacked Area Chart

<svg width="20%" height="100%" viewBox="0 0 48 36" xmlns="http://www.w3.org/2000/svg" fit="" preserveAspectRatio="xMidYMid meet" focusable="false">
    <g fill="none">
        <path stroke="#eddafd" fill="#eddafd" d="M3.955 4.64h40.09v22.5H3.955z"></path>
        <path stroke="#eddafd" fill="#fee5d1" d="M3.955 22.674l13.78-8.205L24 17.04l11.82-5.463 8.225-3.422v21.807H3.955z"></path>
        <path stroke="#d9e7fd" fill="#d9e7fd" stroke-linecap="square" d="M3.955 29.9l5.829-.52 6.585-5.228 6.265 2.454 7.322-6.348 6.476 3.894 7.613-7.558v15.872H3.955z"></path>
        <path stroke="#4285f4" stroke-linecap="square" d="M3.955 29.9l5.829-.52 6.585-5.228 6.265 2.454 7.322-6.348 6.476 3.894 7.613-7.558"></path>
        <path stroke="#fa7b17" stroke-linecap="square" d="M3.955 22.6l13.837-8.146L24 16.967l11.82-5.464 8.115-3.347"></path>
        <path d="M3.597 4.29h40.806" stroke="#a142f4"></path>
    </g>
</svg>

100% Stacked Column Chart

<svg width="20%" height="100%" viewBox="0 0 48 36" xmlns="http://www.w3.org/2000/svg" fit="" preserveAspectRatio="xMidYMid meet" focusable="false">
    <g fill="none">
        <path fill="#fa7b17" d="M4.25 4.656H8v26.907H4.25zm9 0H17v26.907h-3.75zm8.25 0h3.75v26.907H21.5zm9 0h3.75v26.907H30.5zm9 0h3.75v26.907H39.5z"></path>
        <path fill="#a142f4" d="M4.25 15.156H8v16.407H4.25zm9-5.906H17v22.313h-3.75zm8.25 5.906h3.75v16.407H21.5zm9-7.218h3.75v23.625H30.5zm9 6.562h3.75v17.063H39.5z"></path>
        <path fill="#4285f4" d="M4.25 21.063H8v10.5H4.25zm9-5.907H17v16.407h-3.75zm8.25 7.875h3.75v8.532H21.5zm9-5.906h3.75v14.438H30.5zm9 5.25h3.75v9.188H39.5z"></path>
    </g>
</svg>

100% Stack Bar Chart

<svg width="20%" height="100%" viewBox="0 0 48 36" xmlns="http://www.w3.org/2000/svg" fit="" preserveAspectRatio="xMidYMid meet" focusable="false">
    <g fill="none">
        <path fill="#4285f4" d="M19.75 5v3.75h-15V5zm12 7.5v3.75h-27V12.5zm-9 7.5v3.75h-18V20zm18 7.5v3.75h-36V27.5z"></path>
        <path fill="#a142f4" d="M35 12.5v3.75H23V12.5zM32 5v3.75H17.75V5zm0 15v3.75H19.25V20z"></path>
        <path fill="#fa7b17" d="M43.5 12.5v3.75H30.75V12.5zm0-7.5v3.75H27.75V5zm0 22.5v3.75H24V27.5zm0-7.5v3.75H27.75V20z"></path>
    </g>
</svg>

  * 每個類別的資料長度都是100%。  
  * 堆疊的最低層和最高層的變化趨勢最容易判讀。  
  
> :exclamation: 當故事有"1～2個重要角色"且"佔比"也是重要的時候，100% Stacked graph是一個好選擇。

## Stacking Order

  * It follows the levels of the factor variable. `levels()` function can be used to check the order of the levels.
  