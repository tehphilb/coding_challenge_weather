// ignore_for_file: prefer_const_constructors

import 'package:coding_challenge_weather/constants/constants.dart';
import 'package:coding_challenge_weather/models/weather_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

class WeeklyForecastView extends StatelessWidget {
  const WeeklyForecastView({
    super.key,
    required this.color,
    required this.data,
  });

  final Color color;
  final WeatherModel data;

  @override
  Widget build(BuildContext context) {
    List forecast = data.forecast.map((e) => e.formattedDate).toList();
    print(forecast);
    return Scaffold(
      backgroundColor: color,
      appBar: AppBar(
        backgroundColor: color,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_rounded,
            size: 36,
            color: Constants.textColor,
          ),
        ),
        title: Text(
          "Weekly Forecast",
          style: GoogleFonts.inter(
            color: Constants.textColor,
            fontSize: 24,
            fontWeight: FontWeight.w900,
            letterSpacing: -0.3,
          ),
        ),
      ),
      body: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: Constants.extraExtraLargePadding),
        child: Center(
          child: Container(
            decoration: BoxDecoration(
              color: Constants.textColor,
              borderRadius: BorderRadius.circular(Constants.extraLargePadding),
            ),
            child: Padding(
              padding: const EdgeInsets.all(Constants.extraExtraLargePadding),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  WeatherInfoColumn(
                    icon: Icons.air_outlined,
                    mainText: '${data.windSpeed} km/h',
                    subtitle: 'Wind',
                    color: color,
                  ),
                  SizedBox(height: Constants.lagrePadding),
                  WeatherInfoColumn(
                    icon: Icons.water_drop_outlined,
                    mainText: '${data.humidity}%',
                    subtitle: 'Humidity',
                    color: color,
                  ),
                  SizedBox(height: Constants.lagrePadding),
                  WeatherInfoColumn(
                    icon: Icons.visibility_outlined,
                    mainText: '${data.visibility} km',
                    subtitle: 'Visibility',
                    color: color,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class WeatherInfoColumn extends StatelessWidget {
  final IconData icon;
  final String mainText;
  final String subtitle;
  final Color color;

  const WeatherInfoColumn({
    Key? key,
    required this.icon,
    required this.mainText,
    required this.subtitle,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Icon(icon, color: color, size: 36),
        SizedBox(height: Constants.lagrePadding),
        Text(mainText,
            style: TextStyle(
                color: color, fontSize: 16.0, fontWeight: FontWeight.bold)),
        Text(subtitle,
            style: TextStyle(
                color: color, fontSize: 10.0, fontWeight: FontWeight.w400)),
      ],
    );
  }
}
