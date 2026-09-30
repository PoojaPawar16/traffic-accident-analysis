# ============================================================
# TRAFFIC ACCIDENT ANALYSIS AND VISUALIZATION
# Visualization Script
# ============================================================

library(tidyverse)
library(lubridate)
library(corrplot)
library(leaflet)
library(viridis)
library(readxl)
library(ggplot2)

# Import cleaned dataset
accident_data <- read_excel("data/Road Accident Data.xlsx")

# Create accident hour
accident_data$Accident_Hour <- as.integer(
  format(accident_data$Time, "%H")
)

# Create accident month
accident_data$Accident_Month <- format(
  accident_data$`Accident Date`,
  "%Y-%m"
)

head(accident_data$Accident_Month)

# ============================================================
# GRAPH 1: MONTHLY ACCIDENT TREND
# ============================================================

monthly_accidents <- accident_data %>%
  count(Accident_Month)

ggplot(monthly_accidents,
       aes(x = Accident_Month, y = n, group = 1)) +
  geom_line() +
  geom_point() +
  labs(
    title = "Monthly Accident Trend (2021–2022)",
    x = "Month",
    y = "Number of Accidents"
  ) +
  theme_minimal() +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1)
  )

ggsave("plots/monthly_accident_trend.png", width = 10, height = 6)

severity_counts <- as.data.frame(table(accident_data$Accident_Severity))

names(severity_counts) <- c("Severity", "Count")

severity_counts

ggplot(severity_counts, aes(x = Severity, y = Count, fill = Severity)) +
  geom_col() +
  geom_text(
    aes(label = Count),
    vjust = -0.3
  ) +
  scale_y_continuous(
    labels = scales::comma
  ) +
  labs(
    title = "Accident Severity Distribution",
    x = "Accident Severity",
    y = "Number of Accidents"
  ) +
  theme_minimal() +
  theme(
    legend.position = "none"
  )
ggsave("plots/accident_severity_distribution.png",width = 10,height = 6)

day_counts <- as.data.frame(table(accident_data$Day_of_Week))

names(day_counts) <- c("Day", "Count")

day_counts

ggplot(day_counts, aes(x = Count, y = reorder(Day, Count))) +
  geom_point(size = 4) +
  geom_text(
    aes(label = Count),
    hjust = -0.2
  ) +
  labs(
    title = "Accidents by Day of Week",
    x = "Number of Accidents",
    y = "Day of Week"
  ) +
  scale_x_continuous(
    labels = scales::comma,
    expand = expansion(mult = c(0, 0.12))
  ) +
  theme_minimal()

ggsave("plots/accidents_by_day_of_week.png",width = 10,height = 6)

ggplot(accident_data, aes(x = Accident_Hour)) +
  geom_histogram(
    binwidth = 1,
    boundary = -0.5
  ) +
  labs(
    title = "Accidents by Hour of Day",
    x = "Hour of Day",
    y = "Number of Accidents"
  ) +
  scale_x_continuous(
    breaks = 0:23
  ) +
  scale_y_continuous(
    labels = scales::comma
  ) +
  theme_minimal()

ggsave("plots/accidents_by_hour.png",width = 10,height = 6)

day_hour_counts <- as.data.frame(table(accident_data$Day_of_Week,
  accident_data$Accident_Hour)
)

names(day_hour_counts) <- c("Day", "Hour", "Count")

day_hour_counts$Day <- factor(
  day_hour_counts$Day,
  levels = c(
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
    "Sunday"
  )
)

day_hour_counts$Hour <- as.numeric(as.character(day_hour_counts$Hour))

ggplot(day_hour_counts, aes(x = Hour, y = Day, fill = Count)) +
  geom_tile(color = "white", linewidth = 0.3) +
  scale_fill_viridis_c(
    option = "C",
    labels = scales::comma
  ) +
  scale_x_continuous(
    breaks = seq(0, 23, by = 2)
  ) +
  labs(
    title = "Accident Frequency by Day and Hour",
    x = "Hour of Day",
    y = "Day of Week",
    fill = "Accidents"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(
      size = 16,
      face = "bold",
      hjust = 0.5
    ),
    axis.title = element_text(size = 12),
    axis.text = element_text(size = 10),
    panel.grid = element_blank()
  )

ggsave("plots/accidents_by_day_and_hour_heatmap.png",width = 11,height = 6,dpi = 300)

ggplot(
  accident_data,
  aes(
    x = Number_of_Vehicles,
    y = Number_of_Casualties
  )
) +
  geom_jitter(
    width = 0.15,
    height = 0.15,
    alpha = 0.25,
    size = 1.2
  ) +
  labs(
    title = "Vehicles Involved vs Number of Casualties",
    x = "Number of Vehicles",
    y = "Number of Casualties"
  ) +
  scale_x_continuous(
    breaks = seq(0, 32, by = 2)
  ) +
  scale_y_continuous(
    breaks = seq(0, 50, by = 5)
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(
      size = 16,
      face = "bold",
      hjust = 0.5
    ),
    axis.title = element_text(size = 12),
    panel.grid.minor = element_blank()
  )
ggsave("plots/vehicles_vs_casualties_scatter.png",width = 10,height = 6,dpi = 300)

ggplot(
  accident_data,
  aes(x = Number_of_Casualties)
) +
  geom_density(
    fill = "steelblue",
    alpha = 0.6
  ) +
  labs(
    title = "Distribution of Number of Casualties",
    x = "Number of Casualties",
    y = "Density"
  ) +
  coord_cartesian(
    xlim = c(1, 10)
  ) +
  scale_x_continuous(
    breaks = 1:10
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(
      size = 16,
      face = "bold",
      hjust = 0.5
    ),
    axis.title = element_text(size = 12),
    panel.grid.minor = element_blank()
  )

ggsave("plots/casualty_distribution_density.png",width = 10,height = 6,dpi = 300)

ggplot(
  accident_data,
  aes(
    x = Road_Type,
    y = Number_of_Casualties
  )
) +
  geom_boxplot(
    alpha = 0.7
  ) +
  labs(
    title = "Distribution of Casualties by Road Type",
    x = "Road Type",
    y = "Number of Casualties"
  ) +
  scale_y_continuous(
    breaks = seq(0, 50, by = 5)
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(
      size = 16,
      face = "bold",
      hjust = 0.5
    ),
    axis.title = element_text(size = 12),
    axis.text.x = element_text(
      angle = 0,
      hjust = 0.5
    ),
    panel.grid.minor = element_blank()
  )

ggsave("plots/casualties_by_road_type_boxplot.png",width = 10,height = 6,dpi = 300)

set.seed(123)

map_data <- accident_data[
  sample(
    nrow(accident_data),
    20000
  ),
]

sum(is.na(map_data$Latitude))

sum(is.na(map_data$Longitude))

accident_map <- leaflet(map_data) %>%
  addProviderTiles(
    providers$Esri.WorldStreetMap
  ) %>%
  addCircleMarkers(
    lng = ~Longitude,
    lat = ~Latitude,
    radius = 3,
    stroke = FALSE,
    fillOpacity = 0.5,
    clusterOptions = markerClusterOptions()
  ) %>%
  addControl(
    "Traffic Accident Locations",
    position = "topright"
  )

accident_map

htmlwidgets::saveWidget(accident_map,"plots/accident_location_map.html",selfcontained = TRUE)

weather_counts <- as.data.frame(table(accident_data$Weather_Conditions))

names(weather_counts) <- c("Weather", "Count")

weather_counts

names(accident_data)

weather_counts$Weather_Short <- c(
  "Fine + High Wind",
  "Fine",
  "Fog/Mist",
  "Other",
  "Rain + High Wind",
  "Rain",
  "Snow + High Wind",
  "Snow"
)

ggplot(
  weather_counts,
  aes(
    x = Count,
    y = reorder(Weather_Short, Count)
  )
) +
  geom_col() +
  geom_text(
    aes(label = scales::comma(Count)),
    hjust = -0.1
  ) +
  scale_x_continuous(
    labels = scales::comma,
    expand = expansion(mult = c(0, 0.12))
  ) +
  labs(
    title = "Accidents by Weather Condition",
    x = "Number of Accidents",
    y = "Weather Condition"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(
      size = 16,
      face = "bold",
      hjust = 0.5
    ),
    axis.title = element_text(size = 12),
    axis.text = element_text(size = 10)
  )

ggsave("plots/accidents_by_weather_condition.png",width = 10,height = 6,dpi = 300)

