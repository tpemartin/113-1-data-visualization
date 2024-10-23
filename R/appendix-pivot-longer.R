library(tidyverse)

glimpse(relig_income)

tidy_relig_income <- relig_income %>% 
  pivot_longer(
    cols = !religion, 
    names_to = "income", 
    values_to = "count"
  )

ggplot(tidy_relig_income, aes(x = income, y = count)) +
  geom_col()
