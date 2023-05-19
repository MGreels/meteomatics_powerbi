library(jsonlite)
library(httr)
library(dplyr)
library(tidyverse)

res <- GET('https://api.meteomatics.com/yesterdayT00:00:00.000-04:00--yesterdayT23:59:59.000-04:00:PT1H/precip_1h:mm/42.392794587,-71.084942664/json',
        authenticate('mwra_greeley','kk4U3R3cJm'))
data <- fromJSON(rawToChar(res$content))

Yest_data <- data$data$coordinates[[1]][[3]][[1]] %>%
    mutate(lat = data$data$coordinates[[1]][[1]],
           lon = data$data$coordinates[[1]][[2]]
           )


