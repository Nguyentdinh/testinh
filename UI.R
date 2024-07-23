library(shiny)
library(shinydashboard)
library(leaflet)
library(httr)
library(plotly)

# UI of the application
dashboardPage(
  dashboardHeader(title = "Weather App"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Current Weather", tabName = "current_weather", icon = icon("sun")),
      menuItem("Forecast", tabName = "forecast", icon = icon("info-circle"))
    )
  ),
  dashboardBody(
    tags$head(
      tags$meta(charset = "UTF-8"),
      tags$meta(name = "viewport", content = "width=device-width, initial-scale=1.0"),
      tags$title("Current Weather"),
      tags$link(rel = "stylesheet", href = "https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css"),
      tags$style(HTML("
        .container {
          width: 100%;
        }
        .title {
          font-size: 66px;
          font-weight: 900;
          color: #333333; /* Change title text color */
        }
        .title-map {
          font-weight: 900;
          color: #333333; /* Change map title text color */
        }
        .weather-container {
          display: flex;
          justify-content: space-between;
          flex-wrap: wrap;
        }
        .weather-container-left {
          width: 45%;
          padding: 20px;
          background-color: #f0f0f0; /* Change left container background color */
          border-radius: 10px; /* Round corners */
        }
        .weather-container-right {
          width: 50%;
          padding: 20px;
          background-color: #f0f0f0; /* Change right container background color */
          border-radius: 10px; /* Round corners */
        }
        .title-small {
          font-size: 50px;
          font-weight: 900;
        }
        .date {
          font-weight: 700;
          padding: 10px 0;
          color: #f0f0f0; /* Change date text color */
        }
        .title-temperature {
          font-size: 30px;
          padding: 10px 0;
          color: #f0f0f0; /* Change temperature title text color */
        }
        .temperature {
          font-size: 30px;
          color: #ff5722; /* Change temperature text color */
        }
        .temperature-top {
          display: flex;
          flex-wrap: wrap;
        }
        .body-item {
          flex: 1;
          margin: 10px;
          border: 1px solid #8f1d1d;
          border-radius: 4px;
          min-width: 200px; /* Ensure minimum width for containers */
        }
        .title-item {
          color: #fff;
          border: 1px solid #8f1d1d;
          border-color: transparent transparent ##8f1d1d transparent;
          padding: 10px;
        }
        .temperature-top .title-item.title-item-1 {
          background-color: #8f1d1d;
        }
        .temperature-top .title-item.title-item-2 {
          background-color: #8f1d1d;
        }
        .temperature-top .title-item.title-item-3 {
          background-color: #8f1d1d;
        }
        .temperature-top .title-item.title-item-4 {
          background-color: #8f1d1d;
        }
        .temperature-top .title-item.title-item-5 {
          background-color: #8f1d1d;
        }
        .temperature-top .title-item.title-item-6 {
          background-color: #8f1d1d;
        }
        .temperature-item {
          padding: 10px;
          color: #8f1d1d; /* Change content text color */
        }
        .weather-container-right {
          border: 1px solid #ccc;
        }
        .location-container {
          display: inline-flex;
          align-items: center;
          font-size: 35px; /* Increase text size */
          font-weight: 900; /* Bold text */
          color: #8f1d1d; /* Change location text color */
        }
        .location-container i {
          margin-right: 10px;
        }
      "))
    ),
    tabItems(
      tabItem(
        tabName = "current_weather",
        div(class = "container",
            h1(class = "title", "Current Weather"),
            div(class = "weather-container",
                div(class = "weather-container-left",
                    div(class = "location-container",
                        icon("location-crosshairs"),
                        textOutput("location")
                    ),
                    div(class = "date", textOutput("date")),
                    div(class = "title-temperature", icon("temperature-three-quarters"), " Current Temperature"),
                    div(class = "temperature", textOutput("temperature")),
                    div(class = "temperature-top",
                        div(class = "body-item",
                            div(class = "title-item title-item-1", "Feels Like"),
                            div(class = "temperature-item", textOutput("feels_like"))
                        ),
                        div(class = "body-item",
                            div(class = "title-item title-item-2", "Humidity"),
                            div(class = "temperature-item", textOutput("humidity"))
                        ),
                        div(class = "body-item",
                            div(class = "title-item title-item-3", "Weather Condition"),
                            div(class = "temperature-item", textOutput("weather"))
                        ),
                        div(class = "body-item",
                            div(class = "title-item title-item-4", "Visibility"),
                            div(class = "temperature-item", textOutput("visibility"))
                        ),
                        div(class = "body-item",
                            div(class = "title-item title-item-5", "Wind Speed"),
                            div(class = "temperature-item", textOutput("wind_speed"))
                        ),
                        div(class = "body-item",
                            div(class = "title-item title-item-6", "Air Pressure"),
                            div(class = "temperature-item", textOutput("pressure"))
                        )
                    )
                ),
                div(class = "weather-container-right",
                    div(class = "title-map", "MAP"),
                    leafletOutput("map"),
                    verbatimTextOutput("weather_info")
                )
            )
        )
      ),
      tabItem(
        tabName = "forecast",
        h2("Forecast"),
        selectInput("feature", "Select Feature", choices = c("temp", "feels_like", "temp_min", "temp_max", "pressure", "sea_level", "grnd_level", "humidity", "speed", "deg", "gust")),
        plotlyOutput("line_chart")
      )
    )
  )
)
