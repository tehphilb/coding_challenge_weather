// ignore_for_file: prefer_const_constructors

import 'dart:math';

import 'package:coding_challenge_weather/constants/constants.dart';
import 'package:coding_challenge_weather/models/forecast_model.dart';
import 'package:coding_challenge_weather/models/weather_model.dart';
import 'package:coding_challenge_weather/services/icon_wrapper.dart';
import 'package:fl_chart/fl_chart.dart';
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
      // if (forecastDate.hour < 6 || forecastDate.hour > 21) {
      //   continue;
      // }

      String formattedDate = forecast.dayName;

      if (!groupedForecasts.containsKey(formattedDate)) {
        groupedForecasts[formattedDate] = [];
      }

      groupedForecasts[formattedDate]!.add(forecast);
    }

    Map<String, List<double>> temperaturesByDay = {};
    Map<String, List<String>> iconsByDay = {};
    Map<String, List<String>> timesByDay = {};
    Map<String, List<double>> windSpeedByDay = {};

    for (var entry in groupedForecasts.entries) {
      String dayName = entry.key;

      // Initialize empty lists for temperatures, icons, and times if the dayName key doesn't exist
      temperaturesByDay.putIfAbsent(dayName, () => []);
      iconsByDay.putIfAbsent(dayName, () => []);
      timesByDay.putIfAbsent(dayName, () => []);
      windSpeedByDay.putIfAbsent(dayName, () => []);

      // Iterate over each forecast in the list for this day
      for (var forecast in entry.value) {
        // Add the temperature, icon, and formatted time to the appropriate lists
        temperaturesByDay[dayName]!.add(forecast.temperature.toDouble());
        iconsByDay[dayName]!.add(forecast.icon);
        timesByDay[dayName]!.add(forecast.formattedTime);
        windSpeedByDay[dayName]!.add(forecast.windSpeed.toDouble());
      }
    }

    print(iconsByDay);

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
                      height: MediaQuery.of(context).size.height / 3,
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius:
                            BorderRadius.circular(Constants.extraLargePadding),
                        border:
                            Border.all(color: Constants.textColor, width: 2),
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
                              height: Constants.extraLargePadding,
                            ),
                            //ForecastRow(forecast: forecast),
                            WDLineChart(
                              temperatures: temperaturesByDay[forecast.key]!,
                              icons: iconsByDay[forecast.key]!,
                              times: timesByDay[forecast.key]!,
                              windSpeeds: windSpeedByDay[forecast.key]!,
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

class WDLineChart extends StatelessWidget {
  const WDLineChart({
    super.key,
    required this.temperatures,
    required this.icons,
    required this.times,
    required this.windSpeeds,
  });

  final List<double> temperatures;
  final List<String> icons;
  final List<String> times;
  final List<double> windSpeeds;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            drawVerticalLine: true,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: Constants.textColor,
                strokeWidth: .7,
              );
            },
            getDrawingVerticalLine: (value) {
              return FlLine(
                color: Constants.textColor,
                strokeWidth: .7,
              );
            },
          ),
          titlesData: FlTitlesData(
            rightTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (double value, TitleMeta meta) {
                  double text = windSpeeds[value.toInt() % windSpeeds.length];
                  // Adjust text as needed
                  return SideTitleWidget(
                    axisSide: meta.axisSide,
                    child: Row(
                      children: [
                        Text(
                          text.toInt().toString(),
                          style: TextStyle(
                              color: Constants.textColor,
                              fontSize: 10,
                              fontWeight: FontWeight.w700),
                        ),
                        Text(
                          'm/s',
                          style: TextStyle(
                              color: Constants.textColor,
                              fontSize: 8,
                              fontWeight: FontWeight.w700),
                        )
                      ],
                    ),
                  );
                },
                reservedSize: 35,
                interval: 1, // Adjust the interval as needed
              ),
            ),
            topTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (double value, TitleMeta meta) {
                  // Adjust the index as necessary
                  SvgPicture icon = SvgPicture.asset(
                    WeatherIconMapper.getIconPath(
                        icons[value.toInt() % icons.length]),
                    width: 28,
                  );
                  return SideTitleWidget(
                    axisSide: meta.axisSide,
                    child: Column(
                      children: [
                        icon,
                      ],
                    ),
                  );
                },
                reservedSize: 36,
                interval: 1, // Adjust the interval as needed
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (double value, TitleMeta meta) {
                  // Adjust the index as necessary
                  String text = times[value.toInt() % times.length];

                  return SideTitleWidget(
                    axisSide: meta.axisSide,
                    child: Column(
                      children: [
                        Text(
                          text,
                          style: TextStyle(
                            color: Constants.textColor,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  );
                },
                reservedSize: 30,
                interval: 1, // Adjust the interval as needed
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (double value, TitleMeta meta) {
                  String text = '${value.toInt()}°'; // Adjust text as needed
                  return SideTitleWidget(
                    axisSide: meta.axisSide,
                    child: Text(
                      text,
                      style: TextStyle(
                          color: Constants.textColor,
                          fontSize: 10,
                          fontWeight: FontWeight.w700),
                    ),
                  );
                },
                reservedSize: 30,
                interval: 1, // Adjust the interval as needed
              ),
            ),
          ),

          borderData: FlBorderData(
            show: true,
            border: Border.all(color: const Color(0xff37434d), width: 2),
          ),
          minX: 0,
          maxX: (times.length - 1).toDouble(),
          minY: temperatures.reduce(min),
          maxY: temperatures.reduce(max), // Adjust as necessary
          lineBarsData: [
            LineChartBarData(
              spots: List.generate(temperatures.length, (index) {
                return FlSpot(index.toDouble(), temperatures[index]);
              }),
              isCurved: true,
              color: Constants.appWhite,
              // other properties...
            ),
          ],
        ),
      ),
    );
  }
}

class ForecastRow extends StatelessWidget {
  const ForecastRow({
    super.key,
    required this.forecast,
  });

  final MapEntry<String, List<Forecast>> forecast;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          for (var forecastItem in forecast.value)
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Container(
                height: MediaQuery.of(context).size.height / 6,
                width: MediaQuery.of(context).size.width / 6,
                decoration: BoxDecoration(
                  border: Border.all(color: Constants.textColor),
                  borderRadius:
                      BorderRadius.circular(Constants.extraLargePadding),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                      WeatherIconMapper.getIconPath(forecastItem.icon),
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
              ),
            ),
        ],
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
