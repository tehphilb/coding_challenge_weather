// ignore_for_file: prefer_const_constructors

import 'package:coding_challenge_weather/constants/constants.dart';
import 'package:coding_challenge_weather/models/forecast_model.dart';
import 'package:coding_challenge_weather/models/weather_model.dart';
import 'package:coding_challenge_weather/services/icon_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

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
    Map<String, List<Forecast>> groupedForecasts = {};

    DateTime today = DateTime.now();
    DateTime justToday = DateTime(today.year, today.month, today.day);

    for (var forecast in data.forecast) {
      DateTime forecastDate = DateTime.parse(forecast.date.toString());
      DateTime justForecastDate =
          DateTime(forecastDate.year, forecastDate.month, forecastDate.day);

      // Skip the forecast if the date is today
      if (justToday.isAtSameMomentAs(justForecastDate)) {
        continue;
      }

      // Skip the forecast if the time is not between 09:00 and 21:00
      if (forecastDate.hour < 9 || forecastDate.hour > 21) {
        continue;
      }

      String formattedDate = forecast.dayName;

      if (!groupedForecasts.containsKey(formattedDate)) {
        groupedForecasts[formattedDate] = [];
      }

      groupedForecasts[formattedDate]!.add(forecast);
    }

    print(groupedForecasts.entries.elementAt(2));

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
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
              bottom: Constants.extraExtraExtraLargePadding,
              left: Constants.extraExtraExtraLargePadding,
              right: Constants.extraExtraExtraLargePadding,
              top: Constants.extraExtraLargePadding),
          child: Column(
            children: [
              for (var forecast in groupedForecasts.entries)
                Column(
                  children: [
                    SizedBox(height: Constants.extraLargePadding),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height / 5,
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius:
                            BorderRadius.circular(Constants.extraLargePadding),
                        border: Border.all(color: Constants.textColor),
                      ),
                      child: Padding(
                        padding:
                            const EdgeInsets.all(Constants.extraLargePadding),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              forecast.key,
                              style: GoogleFonts.inter(
                                color: Constants.textColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                            SizedBox(
                              height: Constants.normalPadding,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                for (var forecastItem in forecast.value)
                                  Column(
                                    children: [
                                      SizedBox(height: Constants.normalPadding),
                                      Text(
                                        forecastItem.formattedTime,
                                        style: GoogleFonts.inter(
                                          color: Constants.textColor,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      SizedBox(height: Constants.smallPadding),
                                      SvgPicture.asset(
                                        WeatherIconMapper.getIconPath(
                                            forecastItem.icon),
                                        width: 32,
                                      ),
                                      SizedBox(height: Constants.smallPadding),
                                      Text(
                                        '${forecastItem.temperature}°C',
                                        style: GoogleFonts.inter(
                                          color: Constants.textColor,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: Constants.extraLargePadding),
                  ],
                ),
            ],
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
    return Padding(
      padding: const EdgeInsets.only(top: Constants.largePadding),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, color: color, size: 24),
          SizedBox(height: Constants.normalPadding),
          Text(mainText,
              style: TextStyle(
                  color: color, fontSize: 14.0, fontWeight: FontWeight.bold)),
          SizedBox(height: Constants.smallPadding),
          Text(subtitle,
              style: TextStyle(
                  color: color, fontSize: 10.0, fontWeight: FontWeight.w400)),
        ],
      ),
    );
  }
}
