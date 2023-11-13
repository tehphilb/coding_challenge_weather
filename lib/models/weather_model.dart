import 'package:intl/intl.dart';
import 'package:coding_challenge_weather/models/forecast_model.dart';

class WeatherModel {
  final String cityName;
  final String formattedDate;
  final int currentTemp;
  final int feelsLikeTemp;
  final int minTemp;
  final int maxTemp;
  final int windSpeed;
  final int humidity;
  final int visibility;
  final String icon;
  final String description;
  final List<Forecast> forecast;

  WeatherModel({
    required this.cityName,
    required this.formattedDate,
    required this.currentTemp,
    required this.feelsLikeTemp,
    required this.minTemp,
    required this.maxTemp,
    required this.windSpeed,
    required this.humidity,
    required this.visibility,
    required this.icon,
    required this.description,
    required this.forecast,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    final cityData = json['city'];
    final currentWeatherData =
        json['list'][0]; // current weather is the first item in the list
    final dateTime = DateTime.parse(currentWeatherData['dt_txt']);
    final formattedDate = DateFormat('EEEE, dd MMMM').format(dateTime);

    // Extract the forecast data into a list of Forecast objects
    List<Forecast> forecastList = json['list'].map<Forecast>((item) {
      return Forecast.fromJson(item);
    }).toList();

    return WeatherModel(
      cityName: cityData['name'],
      formattedDate: formattedDate,
      currentTemp: (currentWeatherData['main']['temp'] as double).round(),
      feelsLikeTemp:
          (currentWeatherData['main']['feels_like'] as double).round(),
      minTemp: (currentWeatherData['main']['temp_min'] as double).round(),
      maxTemp: (currentWeatherData['main']['temp_max'] as double).round(),
      windSpeed: (currentWeatherData['wind']['speed'] as double).round(),
      humidity: currentWeatherData['main']['humidity'],
      visibility: ((currentWeatherData['visibility'] / 1000) as double).round(),
      icon: currentWeatherData['weather'][0]['icon'],
      description: currentWeatherData['weather'][0]['description'],
      forecast: forecastList, // Assign the forecast list here
    );
  }
}
