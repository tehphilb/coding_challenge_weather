import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:coding_challenge_weather/models/weather_model.dart';
import 'package:coding_challenge_weather/services/api/weather_api.dart';
import 'package:coding_challenge_weather/constants/constants.dart';

class LoadingScreen extends ConsumerWidget {
  const LoadingScreen({
    super.key,
    required this.constraints,
  });

  final BoxConstraints constraints;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Future<WeatherModel> weatherData = fetchWeatherForecast();

    return Scaffold(
      body: Container(
        color: Constants.primaryBackgroundColor,
        child: FutureBuilder(
          future: weatherData,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final data = snapshot.data!;
              return Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(data.cityName),
                  Text(data.formattedDate),
                  Text(data.description),
                  Text(data.currentTemp.toString()),
                  Text(
                      'Now is feels like ${data.feelsLikeTemp.toString()}, actually ${data.currentTemp.toString()}'),
                  Text('${data.windSpeed.toString()}km/h\nWind'),
                  Text('${data.humidity.toString()}%\nHumidity'),
                  Text('${data.visibility.toString()}km\nVisibility'),
                ],
              ));
            } else if (snapshot.hasError) {
              return const Center(
                child: Text('Error'),
              );
            } else {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      color: Constants.textColor,
                    ),
                    SizedBox(height: 20),
                    Text('Loading your position...'),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
