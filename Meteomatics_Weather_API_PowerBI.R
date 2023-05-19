#Meteomatics Weather API Connector

#Set working directory
#setwd('')#edit your own path
#Connecting with the query_api_time.R
source('query_api_PowerBI.R')

#Choose if timeseries or domain
request_type = "domain"#,"timeseries"

#Data
username = "mwra_greeley"
password = "kk4U3R3cJm"

time_zone = "America/New_York"
startdate = ISOdatetime(year = strtoi(strftime(today(),'%Y')),
                        month = strtoi(strftime(today(),'%m'), 10),
                        day = strtoi(strftime(today(),'%d'), 10),
                        hour = 00, min = 00, sec = 00, tz = "America/New_York")
enddate = ISOdatetime(year = strtoi(strftime(today(),'%Y')),
                      month = strtoi(strftime(today(),'%m'), 10),
                      day = strtoi(strftime(today(),'%d'), 10)+1,
                      hour = 00, min = 00, sec = 00, tz = "America/New_York")
interval = "PT1H"

if (request_type == "timeseries"){
    parameters = "precip_1h:mm" #only one parameter
    coordinate = "42.392794587,,-71.084942664" #Rectangle
} else {
  #startdate is used
  parameters = "precip_1h:mm" #only one parameter
  coordinate = "42.392794587,,-71.084942664" #Rectangle
}

#Data from the API
output = query_api(username, password, startdate, enddate, interval, parameters, coordinate, time_zone = time_zone)
