import 'package:coding_challenge_weather/constants/constants.dart';
import 'package:coding_challenge_weather/models/forecast_model.dart';
import 'package:coding_challenge_weather/models/weather_model.dart';
import 'package:coding_challenge_weather/services/icon_wrapper.dart';
import 'package:coding_challenge_weather/views/weekly_forecast_view/animated_forecast_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class DailyForecastView extends ConsumerWidget {
  const DailyForecastView({
    super.key,
    required this.data,
    required this.color,
  });

  final WeatherModel data;
  final Color color;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: Constants.extraExtraLargePadding),
        WeeklyForecast(color: color, data: data),
        const SizedBox(height: Constants.extraLargePadding),
        DailyForecast(data: data),
        const SizedBox(height: Constants.extraExtraExtraLargePadding),
      ],
    );
  }
}

class DailyForecast extends StatefulWidget {
  const DailyForecast({
    Key? key,
    required this.data,
  }) : super(key: key);

  final WeatherModel data;

  @override
  DailyForecastState createState() => DailyForecastState();
}

class DailyForecastState extends State<DailyForecast> {
  @override
  Widget build(BuildContext context) {
    List<Widget> forecastWidgets = [];

    int itemCount =
        widget.data.forecast.length > 8 ? 8 : widget.data.forecast.length;
    for (int index = 0; index < itemCount; index++) {
      Forecast forecast = widget.data.forecast[index];
      Widget forecastItem = Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: 80,
          decoration: BoxDecoration(
            border: Border.all(color: Constants.textColor),
            borderRadius: BorderRadius.circular(Constants.extraLargePadding),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(height: Constants.largePadding),
              Text(
                '${forecast.temperature}°',
                style: GoogleFonts.inter(
                  color: Constants.textColor,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SvgPicture.asset(
                WeatherIconMapper.getIconPath(forecast.icon),
                width: 40,
              ),
              Column(
                children: [
                  Text(
                    forecast.formattedDate,
                    style: GoogleFonts.inter(
                      color: Constants.textColor,
                      fontSize: 10.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    forecast.formattedTime,
                    style: GoogleFonts.inter(
                      color: Constants.textColor,
                      fontSize: 10.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: Constants.normalPadding),
            ],
          ),
        ),
      )
          .animate()
          .fadeIn(
              delay: Duration(milliseconds: 300 * index),
              duration: const Duration(milliseconds: 500))
          .moveY(
            duration: Duration(milliseconds: 300 * index),
            begin: 40,
          );

      forecastWidgets.add(forecastItem);
    }

    return SizedBox(
      height: 120,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(children: forecastWidgets),
      ),
    );
  }
}

class WeeklyForecast extends StatelessWidget {
  const WeeklyForecast({
    super.key,
    required this.color,
    required this.data,
  });

  final Color color;
  final WeatherModel data;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Weekly forecast',
          textHeightBehavior: const TextHeightBehavior(
              applyHeightToLastDescent: true,
              applyHeightToFirstAscent: false,
              leadingDistribution: TextLeadingDistribution.even),
          style: GoogleFonts.inter(
            color: Constants.textColor,
            fontSize: 16.0,
            fontWeight: FontWeight.w900,
          ),
        ),
        AnimatedForecastContainer(color: color, data: data)
      ],
    );
  }
}
