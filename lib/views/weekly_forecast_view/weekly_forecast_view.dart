import 'dart:math';

import 'package:coding_challenge_weather/constants/constants.dart';
import 'package:coding_challenge_weather/models/forecast_model.dart';
import 'package:coding_challenge_weather/models/weather_model.dart';
import 'package:coding_challenge_weather/services/icon_wrapper.dart';
import 'package:coding_challenge_weather/services/repos/weekly_forecast_repo.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
    WeeklyForecastRepo forecastRepo = WeeklyForecastRepo(data: data);
    Map<String, List<Forecast>> groupedForecasts =
        forecastRepo.getGroupedForecasts();
    Map<String, WeatherData> chartData = forecastRepo.prepareChartData();

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
          padding: const EdgeInsets.only(
              bottom: Constants.extraExtraExtraLargePadding,
              left: Constants.extraExtraExtraLargePadding,
              right: Constants.extraExtraExtraLargePadding,
              top: Constants.extraExtraLargePadding),
          child: Column(
            children: [
              for (var forecast in groupedForecasts.entries)
                Column(
                  children: [
                    const SizedBox(height: Constants.extraLargePadding),
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
                            const SizedBox(
                              height: Constants.extraLargePadding,
                            ),
                            //ForecastRow(forecast: forecast),
                            WDLineChart(
                              temperatures:
                                  chartData[forecast.key]!.temperatures,
                              icons: chartData[forecast.key]!.icons,
                              times: chartData[forecast.key]!.times,
                              windSpeeds: chartData[forecast.key]!.windSpeeds,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: Constants.extraLargePadding),
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
              return const FlLine(
                color: Constants.textColor,
                strokeWidth: .7,
              );
            },
            getDrawingVerticalLine: (value) {
              return const FlLine(
                color: Constants.textColor,
                strokeWidth: .7,
              );
            },
          ),
          titlesData: FlTitlesData(
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(
                showTitles: false,
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
                          style: const TextStyle(
                            color: Constants.textColor,
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
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
                      style: const TextStyle(
                          color: Constants.textColor,
                          fontSize: 10,
                          fontWeight: FontWeight.w800),
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
                curveSmoothness: 0.2,
                spots: List.generate(temperatures.length, (index) {
                  return FlSpot(index.toDouble(), temperatures[index]);
                }),
                isCurved: true,
                color: Constants.textColor,
                barWidth: 0.9),
          ],
        ),
      ),
    );
  }
}
