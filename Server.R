library(shiny)
library(leaflet)
library(httr)
library(plotly)

# Function to get weather data from the API
get_weather_data <- function(lat, lon) {
  api_key <- "a175feb619623627bd5c47efcde20aa0" # Replace YOUR_API_KEY with your actual API key from OpenWeatherMap
  url <- paste0("https://api.openweathermap.org/data/2.5/weather?q=Hanoi&units=metric&appid=", api_key)
  response <- GET(url)
  content(response, "parsed")
}

# Define the server logic of the Shiny app
server <- function(input, output, session) {
  
  # Render the initial leaflet map
  output$map <- renderLeaflet({
    leaflet() %>%
      addTiles() %>%
      setView(lng = 105.85, lat = 21.02, zoom = 10) # Default center coordinates are Hanoi
  })
  
  # Observe map clicks to get weather data
  observeEvent(input$map_click, {
    click <- input$map_click
    lat <- click$lat
    lon <- click$lng
    
    weather_data <- get_weather_data(lat, lon)
    
    # Render location name
    output$location <- renderText({
      if (!is.null(weather_data)) {
        weather_data$name
      } else {
        "N/A"
      }
    })
    
    # Render current date
    output$date <- renderText({
      if (!is.null(weather_data)) {
        format(Sys.Date(), "%d-%m-%Y")
      } else {
        "N/A"
      }
    })
    
    # Render temperature
    output$temperature <- renderText({
      if (!is.null(weather_data)) {
        paste(weather_data$main$temp, "°C")
      } else {
        "N/A"
      }
    })
    
    # Render feels like temperature
    output$feels_like <- renderText({
      if (!is.null(weather_data)) {
        paste(weather_data$main$feels_like, "°C")
      } else {
        "N/A"
      }
    })
    
    # Render weather description
    output$weather <- renderText({
      if (!is.null(weather_data)) {
        weather_data$weather[[1]]$description
      } else {
        "N/A"
      }
    })
    
    # Render humidity
    output$humidity <- renderText({
      if (!is.null(weather_data)) {
        paste(weather_data$main$humidity, "%")
      } else {
        "N/A"
      }
    })
    
    # Render visibility
    output$visibility <- renderText({
      if (!is.null(weather_data)) {
        if (!is.null(weather_data$visibility)) {
          paste(weather_data$visibility / 1000, "km")
        } else {
          "N/A"
        }
      } else {
        "N/A"
      }
    })
    
    # Render wind speed
    output$wind_speed <- renderText({
      if (!is.null(weather_data)) {
        paste(weather_data$wind$speed, "m/s")
      } else {
        "N/A"
      }
    })
    
    # Render pressure
    output$pressure <- renderText({
      if (!is.null(weather_data)) {
        paste(weather_data$main$pressure, "hPa")
      } else {
        "N/A"
      }
    })
  })
  
  # Render a Plotly line chart
  output$line_chart <- renderPlotly({
    # Example data for the chart
    times <- rep(c("00:00", "06:00", "12:00", "18:00"), 7)  # Example times for 7 days
    dates <- seq(from = as.Date(Sys.Date()), by = "day", length.out = 7)  # Example dates for 7 days
    
    # Generate example data based on selected feature
    feature <- switch(input$feature,
                      "temp" = runif(28, min = 20, max = 30),
                      "feels_like" = runif(28, min = 18, max = 28),
                      "temp_min" = runif(28, min = 15, max = 25),
                      "temp_max" = runif(28, min = 25, max = 35),
                      "pressure" = runif(28, min = 990, max = 1010),
                      "sea_level" = runif(28, min = 990, max = 1010),
                      "grnd_level" = runif(28, min = 980, max = 1000),
                      "humidity" = runif(28, min = 50, max = 90),
                      "speed" = runif(28, min = 0, max = 10),
                      "deg" = sample(0:360, 28, replace = TRUE),
                      "gust" = runif(28, min = 0, max = 15),
                      "default" = runif(28, min = 0, max = 100))  # Default data if no match
    
    # Combine time, date, and feature data into a data frame
    data <- data.frame(DateTime = paste(rep(dates, each = 4), times),
                       Feature = feature)
    
    # Create a Plotly chart
    plot_ly(data, x = ~DateTime, y = ~Feature, type = 'scatter', mode = 'lines+markers') %>%
      layout(title = paste("Feature:", input$feature),
             xaxis = list(title = "DateTime"),
             yaxis = list(title = input$feature))
  })
}
