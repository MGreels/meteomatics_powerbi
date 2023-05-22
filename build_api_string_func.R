build_APIstring <- function(lat, lon) {

api1 <-'https://api.meteomatics.com/yesterdayT00:00:00.000-04:00--yesterdayT23:59:59.000-04:00:PT1H/precip_1h:mm/'
    
api2 <-    ','
    
api3 <-    '/json'

paste(api1,lat,api2, lon, api3, sep = '')
        

}

