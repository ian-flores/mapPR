library(tidyverse)
library(geojsonio)
library(jsonlite)
library(usethis)

barrios_url <- 'https://raw.githubusercontent.com/ian-flores/atlaspr/master/geotiles/barrios.json'
barrios <- geojson_read(barrios_url, what = 'sp')
barrios_points <- fortify(barrios, region = 'NAME')

usethis::use_data(barrios, overwrite = TRUE)

poverty_barrios_data <- fromJSON('https://raw.githubusercontent.com/ian-flores/atlaspr/master/data/barriosdata.json')[2:940, ]
poverty_barrios_data %>%
    mutate(barrio = str_remove(barrio, ' barrio(.*)')) %>%
    mutate(geo_id = str_remove(geo_id, '(^[0-9][0-9][0-9][0-9][0-9][0-9][^A-Z][A-Z][^0-9][0-9][0-9][0-9][0-9].)')) ->
    poverty_barrios_data

usethis::use_data(poverty_barrios_data, overwrite = TRUE)
