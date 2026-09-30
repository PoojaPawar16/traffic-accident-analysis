library(tidyverse)
library(readxl)
library(lubridate)
library(janitor)
library(corrplot)
library(leaflet)
library(viridis)
library(readxl)

# Import accident dataset
accident_data <- read_excel("data/Road Accident Data.xlsx")

dim(accident_data)

names(accident_data)

str(accident_data)

summary(accident_data)

colSums(is.na(accident_data))

accident_data[is.na(accident_data$Carriageway_Hazards), ]

accident_data[is.na(accident_data$Time), ]

accident_data$Carriageway_Hazards[is.na(accident_data$Carriageway_Hazards)] <- "Unknown"

sum(is.na(accident_data$Carriageway_Hazards))

summary(accident_data$Time)

accident_data$Accident_Hour <- as.integer(format(accident_data$Time, "%H"))

summary(accident_data$Accident_Hour)

sum(duplicated(accident_data))

sum(duplicated(accident_data$Accident_Index))

table(accident_data$Accident_Severity)

accident_data[accident_data$Accident_Severity == "Fetal", ]

summary(accident_data$Number_of_Casualties[accident_data$Accident_Severity == "Fetal"])

table(accident_data$Number_of_Casualties[accident_data$Accident_Severity == "Fetal"])

summary(accident_data[, c("Latitude", "Longitude",
                          "Number_of_Casualties",
                          "Number_of_Vehicles",
                          "Speed_limit")])

table(accident_data$Urban_or_Rural_Area)

table(accident_data$Day_of_Week)

table(accident_data$Weather_Conditions)
