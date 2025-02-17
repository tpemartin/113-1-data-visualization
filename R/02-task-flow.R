library(tidyverse)
myData <- read_csv("data/歷年中華民國國民出國目的地人數統計2002-2023.csv")



# 將數據中的所有年度列轉換為字符型，避免類型不一致的問題
myData_clean <- myData %>%
  mutate(across(starts_with("20"), as.character))  # 將所有以 "20" 開頭的列轉換為字符型

# 轉換為長格式
myData_long <- myData_clean %>%
  pivot_longer(cols = starts_with("20"),  # 轉長格式，選擇所有以20開頭的列
               names_to = "年度", 
               values_to = "人數") %>%
  mutate(人數 = str_replace_all(人數, ",", ""),  # 移除千位符
         人數 = as.numeric(ifelse(人數 == "-", NA, 人數)))  # 將 "-" 轉為 NA，並轉為 numeric

# 移除細分中出現 "合計" 的資料
myData_long_filtered <- myData_long %>%
  filter(!str_detect(細分, "合計"))  # 過濾掉包含 "合計" 的行

# 計算各年度對應的總人數
總人數_by_country <- myData_long_filtered %>%
  group_by(首站抵達地, 年度) %>%
  summarise(總人數 = sum(人數, na.rm = TRUE), .groups = 'drop')  # 計算總人數並移除分組

# 繪製圖形
ggplot(總人數_by_country, aes(x = 年度, y = 總人數, color = 首站抵達地)) +
  geom_line() +
  geom_point() +
  labs(title = "不同首站抵達地的年度總人數",
       x = "年度",
       y = "總人數") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) -> g  # 調整 x 軸標籤角度

g
