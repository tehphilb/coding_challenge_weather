// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:coding_challenge_weather/constants/constants.dart';
import 'package:coding_challenge_weather/models/city_names_model.dart';
import 'package:coding_challenge_weather/models/isar_city_collection.dart';
import 'package:coding_challenge_weather/services/api/city_names_api.dart';
import 'package:coding_challenge_weather/services/isar_db/isar_services.dart';
import 'package:coding_challenge_weather/services/provider/weather_data_provider.dart';
import 'package:coding_challenge_weather/views/search_view/confetti_effect.dart';
import 'package:coding_challenge_weather/views/search_view/search_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

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
  final GlobalKey<ConfettiEffectState> confettiKey =
      GlobalKey<ConfettiEffectState>();

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
      ref.refresh(weatherProvider);
    } catch (e) {
      print('Error adding city: $e'); //TODO: Add error handling
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.searchScreenWhite,
      appBar: PreferredSize(
        preferredSize: const Size(double.infinity, 65),
        child: SafeArea(
          child: Container(
            color: Constants.searchScreenWhite,
            alignment: Alignment.center,
            child: SearchField(
                searchFieldHeight: 40,
                //backIcon: Icons.arrow_back_rounded, // (icon, size
                backIconColor: Constants.textColor,
                centerTitle: 'Search',
                centerTitleStyle: GoogleFonts.inter(
                  color: Constants.textColor,
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.3,
                ),
                onChanged: (_) {},
                searchTextEditingController: controller,
                horizontalPadding: 5),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: Constants.extraExtraLargePadding,
        ),
        child: Stack(
          children: [
            Container(
              color: Constants.searchScreenWhite,
              child: ListView.builder(
                itemCount: nameSuggestions.length,
                itemBuilder: (context, index) {
                  final suggestion = nameSuggestions[index];
                  return Container(
                    margin: const EdgeInsets.symmetric(
                        vertical: 4.0, horizontal: 12.0),
                    child: ListTile(
                      onTap: () async {
                        saveToIsar(suggestion, ref);
                        confettiKey.currentState?.playCenter();
                        //confettiKey.currentState?.playTopCenter();
                        //confettiKey.currentState?.playBottomCenter();
                        await Future.delayed(
                          const Duration(seconds: 1),
                        );
                        if (mounted) {
                          Navigator.pop(context);
                        }
                      },
                      title: Text(
                        suggestion.name,
                        style: GoogleFonts.inter(
                          color: Constants.textColor,
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      subtitle: Text(
                        '${suggestion.state}, ${suggestion.country}',
                        style: GoogleFonts.inter(
                          color: Constants.textColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            ConfettiEffect(key: confettiKey),
          ],
        ),
      ),
    );
  }
}
