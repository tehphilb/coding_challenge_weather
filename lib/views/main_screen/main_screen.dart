import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:coding_challenge_weather/constants/constants.dart';
import 'package:coding_challenge_weather/services/provider/weather_data_provider.dart';
import 'package:coding_challenge_weather/views/main_screen/carousel_view.dart';

class MainScreen extends ConsumerWidget {
  const MainScreen({
    super.key,
    required this.constraints,
  });

  final BoxConstraints constraints;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weatherDataAsyncValue = ref.watch(weatherProvider);
    return Scaffold(
      backgroundColor: Constants.textColor,
      body: weatherDataAsyncValue.when(
        data: (data) => CarouselView(data: data),
        loading: () => const LoadingIndicator(),
        error: (e, _) => Center(child: Text('Error: $e')),
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
            color: Constants.appWhite,
          ),
          SizedBox(height: 20),
          Text(
            'Loading your position...',
            style: TextStyle(
              color: Constants.appWhite,
              fontSize: 24,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
