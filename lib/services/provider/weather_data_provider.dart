import 'package:coding_challenge_weather/constants/constants.dart';
import 'package:coding_challenge_weather/models/weather_model.dart';
import 'package:coding_challenge_weather/services/api/weather_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final weatherProvider =
    FutureProvider.autoDispose<List<WeatherModel>>((ref) async {
  return getCompleteWeatherModel();
});

final colorListProvider = StateProvider.autoDispose
    .family<List<Color>, List<WeatherModel>>((ref, data) {
  return Constants.colors.take(data.length).toList();
});

