# Print out settings

## Recap: AI prompts guidelines

  1. **Clear direction**: Provide a clear and concise description of the task you want to accomplish.
  2. **Provide example**: Provide an example of the input data or code you are working with.  
  3. **Specify output/result format**: Specify the format of the output or result you want to achieve.
  4. **Divide task**: Divide your task into smaller tasks.
  5. **Evaluate quality**: Evaluate the quality of the code provided by the AI assistant.

## Example Dataset 

[GDP growth](https://docs.google.com/spreadsheets/d/1-jX-3EK_yspYDgPIy5vwnRKHntw9-dQIpFVhLc5JcXc/edit?gid=892490556#gid=892490556) dataset comes from World Bank [Data Bank](https://databank.worldbank.org/home.aspx).

Our task is to visualize the GDP growth rates of each country from year 2000 to 2015, and save the graph as a PNG file properly.

Suppose you import the data set as `gdpGrowth`. Consider the following prompt:

```diff
- In the global environment `gdpGrowth` data frame has the following structure:
Rows: 2
Columns: 20
$ `Series Name`   <chr> "GDP growth (annual %)", "GDP growth (annual …
$ `Series Code`   <chr> "NY.GDP.MKTP.KD.ZG", "NY.GDP.MKTP.KD.ZG"
$ `Country Name`  <chr> "Korea, Rep.", "Japan"
$ `Country Code`  <chr> "KOR", "JPN"
$ `2000 [YR2000]` <dbl> 9.060833, 2.764648
$ `2001 [YR2001]` <dbl> 4.8523996, 0.3861034
$ `2002 [YR2002]` <dbl> 7.7251427, 0.0419625
$ `2003 [YR2003]` <dbl> 3.147291, 1.535125
$ `2004 [YR2004]` <dbl> 5.197391, 2.186116
$ `2005 [YR2005]` <dbl> 4.308543, 1.803901
$ `2006 [YR2006]` <dbl> 5.264327, 1.372350
$ `2007 [YR2007]` <dbl> 5.799548, 1.483969
$ `2008 [YR2008]` <dbl> 3.012985, -1.224289
$ `2009 [YR2009]` <dbl> 0.792699, -5.693236
$ `2010 [YR2010]` <dbl> 6.804825, 4.097918
$ `2011 [YR2011]` <dbl> 3.68566778, 0.02380952
$ `2012 [YR2012]` <dbl> 2.402531, 1.374751
$ `2013 [YR2013]` <dbl> 3.164709, 2.005100
$ `2014 [YR2014]` <dbl> 3.2024538, 0.2962055
$ `2015 [YR2015]` <dbl> 2.809103, 1.560627
It is a data set that contains the GDP growth rate of several countries from year 2000 to 2015. Properly visualize the GDP growth rates of each country
```

This prompts has three parts:

  1. "In the global environment `gdpGrowth` data frame...": 
     - "In the global enviroment" tells AI NO NEED to create an example object.  
     -  Mentioning object name `gdpGrowth` is to ensure the codes can be continuously applied when task is divided.  
  2. Use `dgpGrowth |> head(2) |> glimpse()` to show first 2 observations of the data frame and its structure: 
```
Rows: 2
Columns: 20
$ `Series Name`   <chr> "GDP growth (annual %)", "GDP growth (annual …
$ `Series Code`   <chr> "NY.GDP.MKTP.KD.ZG", "NY.GDP.MKTP.KD.ZG"
$ `Country Name`  <chr> "Korea, Rep.", "Japan"
$ `Country Code`  <chr> "KOR", "JPN"
$ `2000 [YR2000]` <dbl> 9.060833, 2.764648
:
$ `2014 [YR2014]` <dbl> 3.2024538, 0.2962055
$ `2015 [YR2015]` <dbl> 2.809103, 1.560627
```

  1. "It is a data set that contains the GDP growth rate of several countries from year 2000 to 2015.": provide context to make your direction clear.   
  2. "Properly visualize the GDP growth rates of each country": specify result format.  

# AI preset

To include font size and print out guidelines:

```diff
You are using RStudio to conduct R programming tasks in POSIT remote server with preloaded tidyverse package. If the task is programming related, the programming style should follow tidyverse style as closely as possible, i.e. if certain task can be done in both base R and tidyverse, use tidyverse.

+ When an object is mentioned to be in the Global environment, don't create an example object.

+ The font sizes of title, subtitle, caption, axis labels, and axis text should be 16, 14, 12, 12, and 10 respectively. Other text size should be 10. 

+ When ask to make font size scalable, put `adj <- 1` and have all font sizes time `adj` 

+ When ask to save the graph, set the aspect ratio to be 4:3. The width should be 80% width of an A4 paper unless specified otherwise.  
```

# Looker exercise


## AI prompt

> How to upload `gdpGrowth_long` data frame to a Google sheets named "GDP Growth" under the sheet named "Asia countries"?
>

## AI response


```r
# upload to google sheets ----
gdpGrowth_long <- gdpGrowth_long %>%
  select(Year, GDP_Growth, `Country Name`)

# Install and load the googlesheets4 package
install.packages("googlesheets4")
library(googlesheets4)

# Authenticate your Google account
gs4_auth()

# Create a new Google Sheet named "GDP Growth" (or access it if it already exists)
sheet <- gs4_create("GDP Growth")

# Upload the dataframe to the sheet named "Asia countries"
sheet_write(gdpGrowth_long, ss = sheet, sheet = "Asia countries")

```