# Recap

Connect a google sheet to Looker and create a time series plot.

  - Google sheet "flightDestination": <https://docs.google.com/spreadsheets/d/1-jX-3EK_yspYDgPIy5vwnRKHntw9-dQIpFVhLc5JcXc/edit?gid=423449012#gid=423449012>  
  - Looker studio: <https://lookerstudio.google.com/>

> :exclamation: date range dimension的對應欄位在Google sheet中必須是日期格式，否則無法在Looker中使用time series plot。 而Google sheet中只有細到"日"的欄位才可能被視為日期格式，若是細到"月"或"年"的欄位，則無法被視為日期格式。

  - [無法被視為日期格式的例子](https://docs.google.com/spreadsheets/d/1-jX-3EK_yspYDgPIy5vwnRKHntw9-dQIpFVhLc5JcXc/edit?gid=1662522658#gid=1662522658)  
  - [可以被視為日期格式的例子](https://docs.google.com/spreadsheets/d/1-jX-3EK_yspYDgPIy5vwnRKHntw9-dQIpFVhLc5JcXc/edit?gid=1550447151#gid=1550447151)