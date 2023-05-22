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



####COMBINES OLD AND NEW BUT DOES NOT REMOVE DUPLICATES!!!
Old_data <- read_csv('rainfall_data.csv')
#Old_data <- group_by(Old_data, site)
#Yest_data <- group_by(Yest_data, site)
New_data <- rbind(Old_data,Yest_data)


rm(res,x,Yest_data_site)
