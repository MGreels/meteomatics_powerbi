## Builds a function to accept longitude and latitude strings and create a
## point API link from meteomatics for hourly rainfall data at a specific point
## See Link Below for info on API
## https://www.meteomatics.com/en/api/getting-started/?ppc_keyword=meteomatics&gclid=CjwKCAjwpayjBhAnEiwA-7enawv9LQVyDluwDl8jLIftL_aN-0gLfF7v5LZJ-eA9HOPJBrozzwyU7RoCprQQAvD_BwE


build_APIstring <- function(lat, lon) {

    

api1 <-'https://api.meteomatics.com/yesterdayT00:00:00.000-05:00--yesterdayT23:59:59.000-05:00:PT1H/precip_1h:mm/'
    
api2 <-    ','
    
api3 <-    '/json'

## pastes 5 strings together to add the latitude and longitude portions 
## to the meteomatics API call
paste(api1,lat,api2, lon, api3, sep = '') 
        

}

