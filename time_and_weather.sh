#!/bin/bash
# Logan Square:41.9285,-87.7067
# https://api.weather.gov/points/41.9285,-87.7067
# https://api.weather.gov/gridpoints/LOT/73,75/forecast
current_weather=$(curl -s "https://api.weather.gov/gridpoints/LOT/73,75/forecast" | 
	jq -M -r '.properties.periods.[0].detailedForecast' )

date
echo "Current weather:"
echo $current_weather
