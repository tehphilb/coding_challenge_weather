import 'dart:convert';

import 'package:coding_challenge_weather/env/env.dart';
import 'package:coding_challenge_weather/services/api/open_ai_api.dart';
import 'package:coding_challenge_weather/services/isar_db/isar_services.dart';
import 'package:http/http.dart' as http;

import 'package:coding_challenge_weather/services/api/geo_api.dart';
import 'package:coding_challenge_weather/models/weather_model.dart';

Future<List<List<double>>> addCoordinates() async {
  List<List<double>> listOfCoordinates = [];
  final position = await Location().getCurrentPosition();
  listOfCoordinates.add([position.latitude, position.longitude]);

  final cities = await IsarService().getAllCities();
  if (cities.isNotEmpty) {
    for (var city in cities) {
      listOfCoordinates.add([city.latitude!, city.longitude!]);
    }
  }

  return listOfCoordinates;
}

Future<List<WeatherModel>> fetchWeatherForecasts(
    List<List<double>> listOfCoordinates) async {
  List<Future<WeatherModel>> forecastFutures = [];

  for (var coordinates in listOfCoordinates) {
    final latitude = coordinates[0];
    final longitude = coordinates[1];

    final url = Uri.parse(
        'https://api.openweathermap.org/data/2.5/forecast?lat=$latitude&lon=$longitude&units=metric&appid=${Env.weatherApiKey}');

    forecastFutures.add(
      http.get(url).then((response) {
        if (response.statusCode == 200) {
          final json = jsonDecode(response.body);
          return WeatherModel.fromJson(json);
        } else {
          throw Exception(
              'Failed to load weather forecast for coordinates ($latitude, $longitude)');
        }
      }).catchError((e) {
        throw Exception('Failed to load weather forecast: $e'); //TODO: handle error
      }),
    );
  }

  final forecasts = await Future.wait(forecastFutures);
  return forecasts;
}

Future<List<WeatherModel>> getCompleteWeatherModel() async {
  final coordinates = await addCoordinates();
  List<WeatherModel> weatherModels = await fetchWeatherForecasts(coordinates);

  List<WeatherModel> updatedWeatherModels = [];

  for (WeatherModel model in weatherModels) {
    try {
      String summary = await runOpenAI(model);
      updatedWeatherModels.add(model.copyWith(openAIDailySummary: summary));
    } catch (e) {
      print(
          'Error fetching summary for ${model.cityName}: $e'); //TODO: handle error

      updatedWeatherModels.add(model);
    }
  }

  return updatedWeatherModels;
}
