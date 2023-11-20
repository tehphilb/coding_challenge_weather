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
  final String openAIDailySummary;

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
    this.openAIDailySummary = '',
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    final cityData = json['city'];
    final currentWeatherData = json['list'][0];
    final dateTime = DateTime.parse(currentWeatherData['dt_txt']);
    final formattedDate = DateFormat('EEEE, dd MMMM, hh:mm').format(dateTime);

    List<Forecast> forecastList = json['list'].map<Forecast>((item) {
      return Forecast.fromJson(item);
    }).toList();

    return WeatherModel(
      cityName: cityData['name'],
      formattedDate: formattedDate,
      currentTemp: (currentWeatherData['main']['temp'].toDouble()).round(),
      feelsLikeTemp:
          (currentWeatherData['main']['feels_like'].toDouble()).round(),
      minTemp: (currentWeatherData['main']['temp_min'].toDouble()).round(),
      maxTemp: (currentWeatherData['main']['temp_max'].toDouble()).round(),
      windSpeed: (currentWeatherData['wind']['speed'].toDouble()).round(),
      humidity: currentWeatherData['main']['humidity'],
      visibility:
          ((currentWeatherData['visibility'] / 1000).toDouble()).round(),
      icon: currentWeatherData['weather'][0]['icon'],
      description: currentWeatherData['weather'][0]['description'],
      forecast: forecastList,
    );
  }

  WeatherModel copyWith({
    String? cityName,
    String? formattedDate,
    int? currentTemp,
    int? feelsLikeTemp,
    int? minTemp,
    int? maxTemp,
    int? windSpeed,
    int? humidity,
    int? visibility,
    String? icon,
    String? description,
    List<Forecast>? forecast,
    String? openAIDailySummary,
  }) {
    return WeatherModel(
      cityName: cityName ?? this.cityName,
      formattedDate: formattedDate ?? this.formattedDate,
      currentTemp: currentTemp ?? this.currentTemp,
      feelsLikeTemp: feelsLikeTemp ?? this.feelsLikeTemp,
      minTemp: minTemp ?? this.minTemp,
      maxTemp: maxTemp ?? this.maxTemp,
      windSpeed: windSpeed ?? this.windSpeed,
      humidity: humidity ?? this.humidity,
      visibility: visibility ?? this.visibility,
      icon: icon ?? this.icon,
      description: description ?? this.description,
      forecast: forecast ?? this.forecast,
      openAIDailySummary: openAIDailySummary ?? this.openAIDailySummary,
    );
  }

  @override
  String toString() {
    return 'WeatherModel(\n'
        '  cityName: $cityName,\n'
        '  formattedDate: $formattedDate,\n'
        '  currentTemp: $currentTemp°C,\n'
        '  feelsLikeTemp: $feelsLikeTemp°C,\n'
        '  minTemp: $minTemp°C,\n'
        '  maxTemp: $maxTemp°C,\n'
        '  windSpeed: $windSpeed km/h,\n'
        '  humidity: $humidity%,\n'
        '  visibility: $visibility km,\n'
        '  icon: $icon,\n'
        '  description: $description,\n'
        '  forecast: ${forecast.length} entries\n'
        '  openAIDailySummary: $openAIDailySummary\n'
        ')';
  }
}


