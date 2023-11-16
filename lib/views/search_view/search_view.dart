// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:coding_challenge_weather/constants/constants.dart';
import 'package:coding_challenge_weather/models/city_names_model.dart';
import 'package:coding_challenge_weather/models/isar_city_collection.dart';
import 'package:coding_challenge_weather/services/api/city_names_api.dart';
import 'package:coding_challenge_weather/services/isar_db/isar_services.dart';
import 'package:coding_challenge_weather/services/provider/weather_data_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:isar/isar.dart';

// class SearchView
//  extends ConsumerStatefulWidget {
//   const SearchView
//   ({super.key});

//   @override
//   ConsumerState<ConsumerStatefulWidget> createState() => _SearchView
//   State();
// }

// class _SearchView
// State extends ConsumerState<SearchView
// > {

//   @override
//   Widget build(BuildContext context) {
//     return Container();
//   }
// }

class SearchView extends ConsumerStatefulWidget {
  const SearchView({
    super.key,
    required this.color,
  });

  final Color color;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SearchViewState();
}

class _SearchViewState extends ConsumerState<SearchView> {
  final isarService = IsarService();
  final geocodingService = CityNamesApi();
  final controller = TextEditingController();

  Timer? debounce;
  List<CityName> nameSuggestions = [];

  @override
  void initState() {
    super.initState();
    controller.addListener(onSearchChanged);
  }

  @override
  void dispose() {
    controller.removeListener(onSearchChanged);
    controller.dispose();
    debounce?.cancel();
    super.dispose();
  }

  void onSearchChanged() {
    if (debounce?.isActive ?? false) debounce!.cancel();
    debounce = Timer(
      const Duration(milliseconds: 500),
      () {
        if (controller.text.isEmpty) {
          setState(() {
            nameSuggestions = [];
          });
        } else {
          geocodingService.fetchCityNames(controller.text).then((suggestions) {
            setState(() {
              nameSuggestions = suggestions;
            });
          });
        }
      },
    );
  }

  // void listenToCityChanges(Isar isar, WidgetRef ref) {
  //   Stream<void> cityChanged = isar.citys.watchLazy();

  //   cityChanged.listen((_) {
  //     // Refresh the provider to fetch new weather data
  //     ref.read(weatherProvider);
  //     print('Post added');
  //   });
  // }

  void saveToIsar(CityName suggestion, WidgetRef ref) async {
    try {
      await isarService.saveName(
        City()
          ..name = suggestion.name
          ..latitude = suggestion.latitude
          ..longitude = suggestion.longitude
          ..country = suggestion.country
          ..state = suggestion.state,
      );

      // Refresh the weather data provider after the city is successfully saved
      ref.refresh(weatherProvider);
      print('City added and provider refreshed');
    } catch (e) {
      // Handle any errors here
      print('Error adding city: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.color,
      appBar: AppBar(
        backgroundColor: Constants.transparent,
        elevation: 0,
        leading: IconButton(
          color: Constants.textColor,
          splashRadius: 1,
          splashColor: Constants.transparent,
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_rounded,
            color: Constants.textColor,
            size: 36,
          ),
        ),
        title: Text(
          'Search',
          style: GoogleFonts.inter(
            color: Constants.textColor,
            fontSize: 24,
            fontWeight: FontWeight.w900,
            letterSpacing: -0.3,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: Constants.extraExtraExtraLargePadding,
        ),
        child: Column(
          children: [
            SizedBox(
              height: Constants.extraExtraLargePadding,
            ),
            SizedBox(
              height: 48,
              width: 300,
              child: TextField(
                controller: controller,
                style: GoogleFonts.inter(
                  color: Constants.textColor,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
                decoration: InputDecoration(
                  suffix: Icon(
                    Icons.search_rounded,
                    color: Constants.textColor,
                    size: 36,
                  ),
                  focusColor: Constants.textColor,
                  filled: true,
                  fillColor: widget.color,
                  hintText: 'Search for a city to add',
                  hintStyle: GoogleFonts.inter(
                    color: Constants.textColor.withOpacity(0.8),
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: nameSuggestions.length,
                itemBuilder: (context, index) {
                  final suggestion = nameSuggestions[index];
                  return ListTile(
                    // splashColor: Constants.transparent,
                    // onLongPress: () => saveExit(suggestion),
                    title: Text(
                      suggestion.name,
                      style: GoogleFonts.inter(
                        color: Constants.appWhite,
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    subtitle: Text(
                      '${suggestion.state}, ${suggestion.country}',
                      style: GoogleFonts.inter(
                        color: Constants.appWhite,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    trailing: IconButton(
                      splashColor: Constants.transparent,
                      onPressed: () {
                        saveToIsar(suggestion, ref);
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.add_rounded,
                        color: Constants.appWhite,
                        size: 20,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
