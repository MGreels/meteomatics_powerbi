library(jsonlite)
library(httr)

res=GET('https://api.meteomatics.com/yesterdayT00:00:00.000-04:00--tomorrow+2DT00:00:00.000-04:00:PT1H/precip_1h:mm/42.392794587,-71.084942664/json',
        authenticate('mwra_greeley','kk4U3R3cJm'))

