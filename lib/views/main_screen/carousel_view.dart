import 'package:coding_challenge_weather/constants/constants.dart';
import 'package:coding_challenge_weather/models/weather_model.dart';
import 'package:coding_challenge_weather/services/isar_db/isar_services.dart';
import 'package:coding_challenge_weather/services/provider/views_count_provider.dart';
import 'package:coding_challenge_weather/services/provider/weather_data_provider.dart';
import 'package:coding_challenge_weather/views/main_screen/daily_forecast_view.dart';
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
  late CarouselSliderController sliderController;
  ScrollController scollController = ScrollController();
  final bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    sliderController = CarouselSliderController();
  }

  @override
  Widget build(BuildContext context) {
    List<Color> colors = ref.watch(colorListProvider(widget.data));
    final viewsCount = ref.watch(viewsCountProvider).asData?.value;

    return CarouselSlider.builder(
      controller: sliderController,
      unlimitedMode: false,
      slideBuilder: (index) {
        return Scaffold(
          backgroundColor: colors[index],
          appBar: AppBar(
            elevation: 0.0,
            backgroundColor: colors[index],
            leading: AnimatedSearchContainer(color: colors[index]),
            title: Text(
              widget.data[index].cityName,
              style: GoogleFonts.inter(
                color: Constants.textColor,
                fontSize: 24,
                fontWeight: FontWeight.w900,
                letterSpacing: -0.3,
              ),
            ),
            actions: index != 0
                ? [
                    Padding(
                      padding:
                          const EdgeInsets.only(right: Constants.smallPadding),
                      child: IconButton(
                        splashColor: Constants.transparent,
                        onPressed: () async {
                          await IsarService()
                              .deleteName(widget.data[index].cityName);
                          setState(() {
                            widget.data.removeAt(index);
                            colors.removeAt(index);
                          });
                        },
                        icon: const Icon(
                          Icons.delete_outline_rounded,
                          color: Constants.textColor,
                          size: 36,
                        ),
                      ),
                    ),
                  ]
                : [
                    Padding(
                      padding:
                          const EdgeInsets.only(right: Constants.smallPadding),
                      child: IconButton(
                        splashRadius: 1,
                        splashColor: Constants.transparent,
                        onPressed: () async {},
                        icon: const Icon(
                          Icons.refresh_rounded,
                          color: Constants.textColor,
                          size: 36,
                        ),
                      ),
                    ),
                  ], //TODO: Add refresh button and functionality
          ),
          body: SingleChildScrollView(
            child: Container(
              color: colors[index],
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: Constants.extraExtraExtraLargePadding,
                ),
                child: Column(
                  children: [
                    DateView(
                      data: widget.data[index],
                      color: colors[index],
                    ),
                    DescriptionView(
                      data: widget.data[index],
                    ),
                    TemperatureView(
                      data: widget.data[index],
                    ),
                    SummaryView(
                      data: widget.data[index],
                    )
                        .animate()
                        .moveY(
                          delay: const Duration(milliseconds: 100),
                          duration: const Duration(milliseconds: 400),
                          begin: 60,
                        )
                        .fadeIn(
                          duration: const Duration(milliseconds: 300),
                        ),
                    BlackCardView(
                      data: widget.data[index],
                      color: colors[index],
                    )
                        .animate()
                        .moveY(
                          delay: const Duration(milliseconds: 200),
                          duration: const Duration(milliseconds: 400),
                          begin: 50,
                        )
                        .fadeIn(
                          duration: const Duration(milliseconds: 700),
                        ),
                    DailyForecastView(
                      data: widget.data[index],
                      color: colors[index],
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
    const Duration animationDuration = Duration(milliseconds: 1000);
    const Duration animationDelay = Duration(milliseconds: 300);

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
            ).animate().fadeIn(duration: animationDuration).moveY(
                  delay: animationDelay,
                  duration: const Duration(milliseconds: 200),
                  begin: 20,
                ),
            Text(
              '°',
              style: GoogleFonts.inter(
                color: Constants.textColor,
                fontSize: 100.0,
                fontWeight: FontWeight.w500,
              ),
            )
                .animate()
                .fadeIn(duration: animationDuration)
                .moveY(
                  delay: animationDelay,
                  duration: const Duration(milliseconds: 200),
                  begin: 10,
                )
                .then()
                .fadeIn(duration: animationDuration)
                .moveX(
                  duration: const Duration(milliseconds: 500),
                  begin: -40,
                ),
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
      crossAxisAlignment: CrossAxisAlignment.stretch,
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
        const SizedBox(height: Constants.normalPadding),
        Text(
          data.openAIDailySummary,
          style: GoogleFonts.inter(
            letterSpacing: -0.3,
            color: Constants.textColor,
            fontSize: 12.0,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: Constants.extraLargePadding),
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
            WeatherInfoColumn(
              icon: Icons.air_outlined,
              mainText: '${data.windSpeed} km/h',
              subtitle: 'Wind',
              color: color,
            ),
            const SizedBox(height: Constants.largePadding),
            WeatherInfoColumn(
              icon: Icons.water_drop_outlined,
              mainText: '${data.humidity}%',
              subtitle: 'Humidity',
              color: color,
            ),
            const SizedBox(height: Constants.largePadding),
            WeatherInfoColumn(
              icon: Icons.visibility_outlined,
              mainText: '${data.visibility} km',
              subtitle: 'Visibility',
              color: color,
            ),
          ],
        ),
      ).animate().shimmer(
          curve: Curves.fastOutSlowIn,
          delay: const Duration(milliseconds: 1575),
          duration: const Duration(milliseconds: 800),
          // color: Colors.white
          colors: [
            color,
            Colors.grey[300]!,
            Colors.white,
            Colors.grey[300]!,
            color,
          ]),
    );
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
        const SizedBox(height: Constants.largePadding),
        Text(
          mainText,
          style: TextStyle(
            color: color,
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: Constants.largePadding),
        Text(
          subtitle,
          style: TextStyle(
            color: color,
            fontSize: 10.0,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
