// ignore_for_file: prefer_const_constructors

import 'package:coding_challenge_weather/constants/constants.dart';
import 'package:coding_challenge_weather/models/isar_city_collection.dart';
import 'package:coding_challenge_weather/models/weather_model.dart';
import 'package:coding_challenge_weather/services/isar_db/isar_services.dart';
import 'package:coding_challenge_weather/services/provider/weather_data_provider.dart';
import 'package:coding_challenge_weather/views/search_view/animated_search_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_carousel_slider/carousel_slider.dart';
import 'package:google_fonts/google_fonts.dart';

class CarouselView extends ConsumerStatefulWidget {
  const CarouselView({
    super.key,
    required this.data,
  });

  final List<WeatherModel> data;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CarouselViewState();
}

class _CarouselViewState extends ConsumerState<CarouselView> {
  IsarService isarService = IsarService();
  City city = City();

  final bool isPlaying = false;
  GlobalKey sliderKey = GlobalKey();
  GlobalKey scollKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    List<Color> colors = ref.watch(colorListProvider(widget.data));

    return CarouselSlider.builder(
      // key: sliderKey,
      unlimitedMode: false,
      slideBuilder: (colorIndex) {
        return Scaffold(
          backgroundColor: colors[colorIndex],
          appBar: AppBar(
            elevation: 0.0,
            backgroundColor: colors[colorIndex],
            leading: colorIndex == 0
                ? AnimatedSearchContainer(color: colors[colorIndex])
                : null, // If colorIndex is not 0, no leading widget is shown
            title: Text(
              widget.data[colorIndex].cityName,
              style: GoogleFonts.inter(
                color: Constants.textColor,
                fontSize: 24,
                fontWeight: FontWeight.w900,
                letterSpacing: -0.3,
              ),
            ),
            actions: colorIndex != 0
                ? [
                    IconButton(
                      splashColor: Constants.transparent,
                      onPressed: () async {
                        await isarService
                            .deleteName(widget.data[colorIndex].cityName);
                        setState(() {
                          widget.data.removeAt(colorIndex);
                          colors.removeAt(colorIndex);
                        });
                      },
                      icon: Icon(
                        Icons.delete_outline_rounded,
                        color: Constants.textColor,
                        size: 36,
                      ),
                    ),
                  ]
                : null, // If colorIndex is 0, no actions are added
          ),
          body: SingleChildScrollView(
            child: Container(
              color: colors[colorIndex],
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: Constants.extraExtraExtraLargePadding,
                ),
                child: Column(
                  children: [
                    DateView(
                      data: widget.data[colorIndex],
                      color: colors[colorIndex],
                    ),
                    DescriptionView(
                      data: widget.data[colorIndex],
                    ),
                    TemperatureView(
                      data: widget.data[colorIndex],
                    ),
                    SummaryView(
                      data: widget.data[colorIndex],
                    ),
                    BlackCardView(
                      data: widget.data[colorIndex],
                      color: colors[colorIndex],
                    ),
                    ForecastView(
                      data: widget.data[colorIndex],
                      color: colors[colorIndex],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
      slideTransform: const CubeTransform(),
      slideIndicator: CircularSlideIndicator(
        padding:
            const EdgeInsets.only(bottom: Constants.extraExtraLargePadding),
      ),
      itemCount: colors.length,
    );
  }
}

class ForecastView extends ConsumerWidget {
  const ForecastView({
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
        SizedBox(height: Constants.extraExtraLargePadding),
        Row(
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
            IconButton(
              splashColor: Constants.transparent,
              onPressed: () {
                //print('pressed arrow');
              },
              icon: Icon(
                Icons.arrow_circle_right_rounded,
                color: Constants.textColor,
                size: 36,
              ),
            ),
          ],
        ),
        SizedBox(height: Constants.extraLargePadding),
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: data.forecast.length > 8 ? 8 : data.forecast.length,
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
                      SizedBox(height: Constants.lagrePadding),
                      Text(
                        '${data.forecast[index].temperature}°',
                        style: GoogleFonts.inter(
                          color: Constants.textColor,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Image.network(
                        'https://openweathermap.org/img/wn/${data.forecast[index].icon}.png',
                        width: 36,
                        color: Constants.textColor,
                      ),
                      Text(
                        '${data.forecast[index].formattedDate}\n${data.forecast[index].formattedTime}',
                        style: GoogleFonts.inter(
                          color: Constants.textColor,
                          fontSize: 10.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: Constants.normalPadding),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        SizedBox(height: Constants.extraExtraExtraLargePadding),
      ],
    );
  }
}

class DescriptionView extends ConsumerWidget {
  const DescriptionView({
    super.key,
    required this.data,
  });

  final WeatherModel data;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Align(
      alignment: Alignment.center,
      child: Text(
        data.description,
        style: GoogleFonts.inter(
          color: Constants.textColor,
          fontSize: 16.0,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class TemperatureView extends ConsumerWidget {
  const TemperatureView({
    super.key,
    required this.data,
  });

  final WeatherModel data;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Align(
      alignment: Alignment.center,
      child: SizedBox(
        height: 180.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              data.currentTemp.toString(),
              textHeightBehavior: const TextHeightBehavior(
                  applyHeightToLastDescent: true,
                  applyHeightToFirstAscent: false,
                  leadingDistribution: TextLeadingDistribution.even),
              style: GoogleFonts.inter(
                color: Constants.textColor,
                fontSize: 150.0,
                letterSpacing: -1.0,
                fontWeight: FontWeight.w400,
              ),
            ).animate().moveY().fadeIn(),
            Text(
              '°',
              style: GoogleFonts.inter(
                color: Constants.textColor,
                fontSize: 100.0,
                fontWeight: FontWeight.w500,
              ),
            ).animate().moveX().fadeIn(),
          ],
        ),
      ),
    );
  }
}

class SummaryView extends ConsumerWidget {
  const SummaryView({
    super.key,
    required this.data,
  });

  final WeatherModel data;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Daily Summary',
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
        SizedBox(height: Constants.normalPadding),
        Text(
          'Now it feels like ${data.feelsLikeTemp}°, actually ${data.currentTemp}°.\nToday, the temperture will be between ${data.minTemp}° and ${data.maxTemp}°.',
          style: GoogleFonts.inter(
            letterSpacing: -0.3,
            color: Constants.textColor,
            fontSize: 12.0,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: Constants.extraExtraLargePadding),
      ],
    );
  }
}

class BlackCardView extends ConsumerWidget {
  const BlackCardView({
    super.key,
    required this.data,
    required this.color,
  });

  final WeatherModel data;
  final Color color;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
        decoration: BoxDecoration(
          color: Constants.textColor,
          borderRadius: BorderRadius.circular(Constants.extraLargePadding),
        ),
        child: Padding(
          padding: const EdgeInsets.all(Constants.extraExtraLargePadding),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    Icons.air_outlined,
                    color: color,
                    size: 36,
                  ),
                  SizedBox(height: Constants.lagrePadding),
                  Text(
                    '${data.windSpeed} km/h',
                    style: TextStyle(
                      color: color,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Wind',
                    style: TextStyle(
                      color: color,
                      fontSize: 10.0,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              SizedBox(height: Constants.lagrePadding),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    Icons.water_drop_outlined,
                    color: color,
                    size: 36,
                  ),
                  SizedBox(height: Constants.lagrePadding),
                  Text(
                    '${data.humidity}%',
                    style: TextStyle(
                      color: color,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Humidity',
                    style: TextStyle(
                      color: color,
                      fontSize: 10.0,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              SizedBox(height: Constants.lagrePadding),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    Icons.visibility_outlined,
                    color: color,
                    size: 36,
                  ),
                  SizedBox(height: Constants.lagrePadding),
                  Text(
                    '${data.visibility} km',
                    style: TextStyle(
                      color: color,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Visibility',
                    style: TextStyle(
                      color: color,
                      fontSize: 10.0,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}

class DateView extends ConsumerWidget {
  const DateView({
    super.key,
    required this.data,
    required this.color,
  });

  final WeatherModel data;
  final Color color;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(Constants.extraLargePadding),
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            color: Constants.textColor,
            borderRadius: BorderRadius.circular(Constants.extraLargePadding),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 4.0,
            ),
            child: Text(
              data.formattedDate,
              style: GoogleFonts.inter(
                color: color,
                fontSize: 12.0,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
