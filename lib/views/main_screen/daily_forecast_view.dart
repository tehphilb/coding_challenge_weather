import 'package:coding_challenge_weather/constants/constants.dart';
import 'package:coding_challenge_weather/models/weather_model.dart';
import 'package:coding_challenge_weather/services/icon_wrapper.dart';
import 'package:coding_challenge_weather/views/weekly_forecast_view/animated_forecast_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
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
        DailyForcast(data: data),
        const SizedBox(height: Constants.extraExtraExtraLargePadding),
      ],
    );
  }
}

class DailyForcast extends StatefulWidget {
  const DailyForcast({
    super.key,
    required this.data,
  });

  final WeatherModel data;

  @override
  State<DailyForcast> createState() => _DailyForcastState();
}

class _DailyForcastState extends State<DailyForcast> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount:
            widget.data.forecast.length > 8 ? 8 : widget.data.forecast.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Container(
              width: 80,
              decoration: BoxDecoration(
                border: Border.all(color: Constants.textColor),
                // color: Constants.textColor,
                borderRadius:
                    BorderRadius.circular(Constants.extraLargePadding),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(height: Constants.lagrePadding),
                  Text(
                    '${widget.data.forecast[index].temperature}°',
                    style: GoogleFonts.inter(
                      color: Constants.textColor,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SvgPicture.asset(
                    WeatherIconMapper.getIconPath(
                        widget.data.forecast[index].icon),
                    width: 40,
                    // You can set other properties as needed
                  ),
                  // Image.network(
                  //   'https://openweathermap.org/img/wn/${widget.data.forecast[index].icon}.png',
                  //   width: 52,
                  //   // color: Constants.textColor,
                  // ), //TODO: change icons
                  Column(
                    children: [
                      Text(
                        widget.data.forecast[index].formattedDate,
                        style: GoogleFonts.inter(
                          color: Constants.textColor,
                          fontSize: 10.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        widget.data.forecast[index].formattedTime,
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
          );
        },
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
