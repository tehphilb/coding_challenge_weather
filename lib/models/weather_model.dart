import 'package:intl/intl.dart';

class WeatherModel {
  final String cityName;
  final String formattedDate;
  final int currentTemp;
  final int feelsLikeTemp;
  final int windSpeed;
  final int humidity;
  final int visibility;
  final String icon;
  final String description;

  WeatherModel({
    required this.cityName,
    required this.formattedDate,
    required this.currentTemp,
    required this.feelsLikeTemp,
    required this.windSpeed,
    required this.humidity,
    required this.visibility,
    required this.icon,
    required this.description,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    final cityData = json['city'];
    final currentWeatherData = json['list'][0];
    final dateTime = DateTime.parse(currentWeatherData['dt_txt']);
    final formattedDate = DateFormat('EEEE, dd MMMM').format(dateTime);

    return WeatherModel(
      cityName: cityData['name'],
      formattedDate: formattedDate,
      currentTemp: (currentWeatherData['main']['temp'] as double).round(),
      feelsLikeTemp:
          (currentWeatherData['main']['feels_like'] as double).round(),
      windSpeed: (currentWeatherData['wind']['speed'] as double).round(),
      humidity: currentWeatherData['main']['humidity'],
      visibility: ((currentWeatherData['visibility'] / 1000) as double).round(),
      icon: currentWeatherData['weather'][0]['icon'],
      description: currentWeatherData['weather'][0]['description'],
    );
  }
}
