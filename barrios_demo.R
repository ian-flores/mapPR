## Leaflet Demo

library(tidyverse)
library(leaflet)

pal <- colorBin('YlOrRd', domain = barrios@data$below_poverty)

data <- fromJSON('https://raw.githubusercontent.com/ian-flores/atlaspr/master/data/barriosdata.json')[2:940, ]

data %>%
    mutate(barrio = str_remove(barrio, ' barrio(.*)')) %>%
    mutate(geo_id = str_remove(geo_id, '(^[0-9][0-9][0-9][0-9][0-9][0-9][^A-Z][A-Z][^0-9][0-9][0-9][0-9][0-9].)'))->
    data

barrios@data <- barrios@data %>%
    left_join(data, by = c('COUSUB' = 'geo_id')) 

leaflet(barrios) %>%
    addTiles() %>%
    addPolygons(fillColor = ~pal(below_poverty),
                weight = 2, 
                color = 'white', 
                opacity = 1, 
                dashArray = '3',
                fillOpacity = 0.7)

## ggplot2 Demo

barrios <- geojson_read(barrios_url, what = 'sp') ## Should be substituted by loading the dataset

barrios.points <- fortify(barrios, region = 'NAME') 

barrios.points %>%
    left_join(barrios@data, by = c("id" = "NAME")) ->
    barrios.points


barrios.points %>%
    left_join(data, by = c("COUSUB" = 'geo_id')) %>%
    filter(!is.na(below_poverty)) -> 
    barrios_clean


ggplot(barrios_clean, aes(x = long, y = lat)) +
    geom_polygon(aes(group = group, fill = below_poverty)) +
    coord_equal() +
    theme_minimal()
