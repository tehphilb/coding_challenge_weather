import 'dart:convert';

import 'package:coding_challenge_weather/services/isar_db/isar_services.dart';
import 'package:http/http.dart' as http;

import 'package:coding_challenge_weather/api_keys.dart';
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

// Future<WeatherModel> fetchWeatherForecast() async {

//   addCoordinates();

//   final url = Uri.parse(
//       'https://api.openweathermap.org/data/2.5/forecast?lat=${position.latitude}&lon=${position.longitude}&units=metric&appid=$weatherApiKey');

//   try {
//     final response = await http.get(url);

//     if (response.statusCode == 200) {
//       final json = jsonDecode(response.body);
//       return WeatherModel.fromJson(json);
//     } else {
//       throw Exception('Failed to load weather forecast');
//     }
//   } catch (e) {
//     throw Exception('Failed to load weather forecast: $e');
//   }
// }

Future<List<WeatherModel>> fetchWeatherForecasts(
    List<List<double>> listOfCoordinates) async {
  // This will hold all the WeatherModel futures.
  List<Future<WeatherModel>> forecastFutures = [];

  for (var coordinates in listOfCoordinates) {
    final latitude = coordinates[0];
    final longitude = coordinates[1];

    // Construct the API call for each set of coordinates.
    final url = Uri.parse(
        'https://api.openweathermap.org/data/2.5/forecast?lat=$latitude&lon=$longitude&units=metric&appid=$weatherApiKey');

    // Add the http.get call to the list of futures.
    forecastFutures.add(http.get(url).then((response) {
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return WeatherModel.fromJson(json);
      } else {
        throw Exception(
            'Failed to load weather forecast for coordinates ($latitude, $longitude)');
      }
    }).catchError((e) {
      throw Exception('Failed to load weather forecast: $e');
    }));
  }

  // Wait for all the API calls to complete and return a list of WeatherModels.
  final forecasts = await Future.wait(forecastFutures);
  return forecasts;
}
