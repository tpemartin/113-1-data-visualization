policeForce <- read_csv("data/臺北市政府警察局警力員額統計-1130930.csv",
locale = locale(encoding = "BIG5"))
cars <- read_csv("data/桃園市機動車輛分類統計.csv")
youbike <- read_csv("data/YouBike2.0維修次數.csv",
locale = locale(encoding = "BIG5"))
finance <- read_csv("data/ma00181y1ac.csv",
locale = locale(encoding = "BIG5"))
finance2 <- read_csv("data/ma00181y2ac.csv",
locale = locale(encoding = "BIG5"))
suspects <- read_csv("data/臺北市政府警察局治安顧慮人口數量統計表.csv",
locale = locale(encoding = "BIG5"))
billdata <- read_csv("data/billdata.csv")

# Parsing 
library(dplyr)


tidy_policeForce <- policeForce %>%
  mutate(`年別` = as.numeric(gsub("年", "", `年別`)))

