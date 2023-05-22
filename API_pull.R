#############
#   Pulls API data for single points contained in 'rain_sites.xlsx
#   


library(jsonlite)
library(httr)
library(dplyr)
library(tidyverse)
library(readr)
library(readxl)

x <-read_xlsx('rain_sites.xlsx', col_types = 'text' )
source('build_api_string_func.R')
if(exists('Yest_data')){
    rm(Yest_data)
}

for (i in 1:nrow(x)) {
res <- GET(build_APIstring(x$Lat[i], x$Lon[i]),
        authenticate('mwra_greeley','kk4U3R3cJm'))
res <- fromJSON(rawToChar(res$content))

Yest_data_site <- res$data$coordinates[[1]][[3]][[1]] %>%
    mutate(lat = res$data$coordinates[[1]][[1]],
           lon = res$data$coordinates[[1]][[2]],
           site = x$Site[i])
Yest_data <- 
    if(exists('Yest_data')){
    rbind(Yest_data, Yest_data_site)
    } else {Yest_data_site}
    
}
rm(i)
##pulls old data from n
Yest_data$date <- Yest_data$date %>%
    as.POSIXct(format="%Y-%m-%dT%H:%M:%OSZ", tz = 'UTC') %>%
    format(tz = 'EST') %>%
    as.POSIXct()

Old_data <- read_csv('rainfall_data.csv')
Old_data <- anti_join(Old_data, Yest_data, by = c("date", "site"))##removes old data

##bind API pull from Yesterday into old data table
New_data <- rbind(Old_data,Yest_data)
write_csv(New_data,"rainfall_data.csv")

rm(res,x,Yest_data_site,Old_data,Yest_data)

