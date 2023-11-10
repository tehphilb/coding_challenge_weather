// ignore_for_file: prefer_const_constructors

import 'package:coding_challenge_weather/constants/constants.dart';
import 'package:coding_challenge_weather/models/weather_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_carousel_slider/carousel_slider.dart';

class CarouselView extends ConsumerStatefulWidget {
  const CarouselView({
    super.key,
    required this.data,
  });

  final WeatherModel data;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CarouselViewState();
}

class _CarouselViewState extends ConsumerState<CarouselView> {
  final List<Color> colors = [
    Constants.primaryBackgroundColor,
    Constants.secondaryBackgroundColor,
    Constants.thirdBackgroundColor
  ];
  final List<String> letters = [
    "A",
    "B",
    "C",
  ];

  final bool isPlaying = false;
  GlobalKey sliderKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return CarouselSlider.builder(
      key: sliderKey,
      unlimitedMode: true,
      slideBuilder: (index) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: colors[index],
            leading: IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.menu_rounded,
                color: Constants.textColor,
                size: 36,
              ),
            ),
            title: Text(
              'City Name',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.3),
            ),
          ),
          body: Container(
            color: colors[index],
            child: Center(
              child: Column(
                children: [
                  DateView(
                    colors: colors,
                    index: index,
                  ),
                  Center(
                      child: Text(
                    'Sunny',
                    style: TextStyle(
                      color: Constants.textColor,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ))
                ],
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

class DateView extends StatelessWidget {
  const DateView({
    super.key,
    required this.colors,
    required this.index,
  });

  final List<Color> colors;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            color: Constants.textColor,
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 4.0,
            ),
            child: Text(
              'Friday, o1 January',
              style: TextStyle(
                fontSize: 12,
                color: colors[index],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
