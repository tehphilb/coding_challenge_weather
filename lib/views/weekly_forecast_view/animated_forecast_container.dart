import 'package:animations/animations.dart';
import 'package:coding_challenge_weather/constants/constants.dart';
import 'package:coding_challenge_weather/models/weather_model.dart';
import 'package:coding_challenge_weather/views/weekly_forecast_view/weekly_forecast_view.dart';
import 'package:flutter/material.dart';

class AnimatedForecastContainer extends StatefulWidget {
  const AnimatedForecastContainer(
      {super.key, required this.color, required this.data});

  final Color color;
  final WeatherModel data;

  @override
  State<AnimatedForecastContainer> createState() =>
      _AnimatedForecastContainerState();
}

class _AnimatedForecastContainerState extends State<AnimatedForecastContainer> {
  @override
  Widget build(BuildContext context) {
    ContainerTransitionType containerTransitionType =
        ContainerTransitionType.fade;

    return OpenContainer(
      transitionType: containerTransitionType,
      transitionDuration: const Duration(milliseconds: 500),
      openBuilder: (context, _) =>
          WeeklyForecastView(color: widget.color, data: widget.data),
      closedElevation: 1,
      closedColor: widget.color,
      closedShape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(36),
        ),
      ),
      closedBuilder: (context, _) => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(36),
          color: widget.color,
        ),
        child: const Icon(
          Icons.arrow_circle_right_rounded,
          color: Constants.textColor,
          size: 36,
        ),
      ),
    );
  }
}
