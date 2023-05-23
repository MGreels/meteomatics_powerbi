#############
#   Pulls API data for single points contained in 'rain_sites.xlsx
#   A daily run will include the historical data for 


library(jsonlite)
library(httr)
library(dplyr)
library(tidyverse)
library(readr)
library(readxl)

Sys.setenv(TZ='est') ##trimble doesn't recognize Daylight Savings time, so set to standard time
site_path <- 'rain_sites.xlsx'
output_path <- 'rainfall_data.csv'
setwd('//chelsea3/Users/Greeley_M/projects/meteomatics_powerbi/')##sets wd for task scheduler


x <-read_xlsx(site_path, col_types = 'text' )

##creates the build string funciton
source('build_api_string_func.R')
##R
if(exists('Yest_data')){
    rm(Yest_data)
}

## runs a for loop, for every site, long,lat combo in "rain_sites.xlsx" 
## creates an API link and pull the data from the meteopmatics API.
## Pulls hourly rainfall totals from each site from yesterday.
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
## converts the character date data to POSIXct then converts from UTC to EST
Yest_data$date <- Yest_data$date %>%
    as.POSIXct(format="%Y-%m-%dT%H:%M:%OSZ", tz = 'UTC') %>%
    format(tz = 'EST') %>%
    as.POSIXct()

## Pulls in current CSV file and compares old data to new data
## This step throws out any repeat time-site combos
## script will replaces with the new data if there is a conflict.
if(!file.exists(output_path)) {
    write_csv(Yest_data,output_path)
} else {
    Old_data <- read_csv(output_path)
    Old_data <- anti_join(Old_data, Yest_data, by = c("date", "site"))
    
    ##bind API pull from Yesterday into old data table
    New_data <- rbind(Old_data,Yest_data)
    
    ## writes new csv file including yesterday's data.
    write_csv(New_data,output_path)
    rm(Old_data, New_data)
} 

rm(res,x,Yest_data_site,Yest_data, build_APIstring, output_path, site_path)
