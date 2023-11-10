import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:coding_challenge_weather/api_keys.dart';
import 'package:coding_challenge_weather/services/api/geo_api.dart';
import 'package:coding_challenge_weather/models/weather_model.dart';

Future<WeatherModel> fetchWeatherForecast() async {
  final position = await Location().getCurrentPosition();
  final url = Uri.parse(
      'https://api.openweathermap.org/data/2.5/forecast?lat=${position.latitude}&lon=${position.longitude}&units=metric&appid=$apiKey');

  try {
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return WeatherModel.fromJson(json);
    } else {
      throw Exception('Failed to load weather forecast');
    }
  } catch (e) {
    throw Exception('Failed to load weather forecast: $e');
  }
}
