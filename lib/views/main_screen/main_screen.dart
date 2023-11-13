import 'package:coding_challenge_weather/views/main_screen/carousel_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:coding_challenge_weather/models/weather_model.dart';
import 'package:coding_challenge_weather/services/api/weather_api.dart';
import 'package:coding_challenge_weather/constants/constants.dart';

class MainScreen extends ConsumerWidget {
  const MainScreen({
    super.key,
    required this.constraints,
  });

  final BoxConstraints constraints;

  Future<List<WeatherModel>> get weatherData async {
    final coordinates = await addCoordinates();
    final weatherData = await fetchWeatherForecasts(coordinates);
    return weatherData;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref)  {

    return Scaffold(
      backgroundColor: Constants.textColor,
      body: FutureBuilder(
        future: weatherData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.data!;
            return CarouselView(data: data);
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('Error'),
            );
          } else {
            return const LoadingIndicator();
          }
        },
      ),
    );
  }
}

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
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
}
