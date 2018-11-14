library(tidyverse)
library(lubridate)
library(rio)

mapPR_crime <- function(.data_format = 'all_data', .intial_date = '2017-01-01', .final_date = '2017-12-01'){

    .base_url <- 'https://github.com/OpenDataPR/PR_Crime_Data/raw/master/data/'

    .url <- paste0(.base_url, .data_format, '.feather')
    .data <- rio::import(.url)

    .data %>%
        filter(incident_date > ymd(.initial_date),
               incident_date < ymd(.final_date)) ->
        .data

    return(.data)
}
