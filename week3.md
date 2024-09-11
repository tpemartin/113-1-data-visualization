# week 3

- [week 3](#week-3)
  - [Package installation errors](#package-installation-errors)
  - [RStudio cloud (POSIT)](#rstudio-cloud-posit)
  - [Python in POSIT](#python-in-posit)
  - [Import Python pandas data frame](#import-python-pandas-data-frame)
    - [R reticulate](#r-reticulate)
    - [Create a data frame example in Python](#create-a-data-frame-example-in-python)
  - [](#)

## Package installation errors

Disable `.Rprofile` first.

## RStudio cloud (POSIT)

<https://github.com/tpemartin/112-2-R-EE/blob/main/Lecture%20notes/week2-session1.md>

## Python in POSIT

<https://support.posit.co/hc/en-us/articles/360023654474-Installing-and-Configuring-Python-with-Posit>

## Import Python pandas data frame

### R reticulate

R use `reticulate` package to communicate with Python interpreter.

``` r
installed.packages("reticulate")
```

         Package LibPath Version Priority Depends Imports LinkingTo Suggests
         Enhances License License_is_FOSS License_restricts_use OS_type Archs
         MD5sum NeedsCompilation Built

### Create a data frame example in Python

Suppose you already has used Python before.

``` python
import pandas as pd
import pickle

# Create a dictionary with some data
data = {'Name': ['Alice', 'Bob', 'Charlie', 'David'],
        'Age': [25, 30, 35, 40],
        'City': ['New York', 'Los Angeles', 'Chicago', 'Houston']}

# Create a pandas data frame from the dictionary
df = pd.DataFrame(data)

# Save the dataframe to a pickle file
with open('dataframe_pickle.pkl', 'wb') as file:
    pickle.dump(df, file)

print("Data frame saved to 'dataframe_pickle.pkl'")
```

    Data frame saved to 'dataframe_pickle.pkl'

Import the data frame

``` r
library(reticulate)
# Load the python object containing pickled data frame
df <- py_load_object("dataframe_pickle.pkl")
```

## 
