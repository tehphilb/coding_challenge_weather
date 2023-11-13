// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:coding_challenge_weather/constants/constants.dart';
import 'package:coding_challenge_weather/models/city_names_model.dart';
import 'package:coding_challenge_weather/models/isar_city_collection.dart';
import 'package:coding_challenge_weather/services/api/city_names_api.dart';
import 'package:coding_challenge_weather/services/isar_db/isar_services.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SearchView extends StatefulWidget {
  const SearchView({
    super.key,
    required this.color,
  });

  final Color color;

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final service = IsarService();
  final geocodingService = CityNamesApi();
  final controller = TextEditingController();

  Timer? _debounce;
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
    _debounce?.cancel();
    super.dispose();
  }

  void onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(
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

  void saveExit(CityName suggestion) {
    service.saveName(
      City()
        ..name = suggestion.name
        ..latitude = suggestion.latitude
        ..longitude = suggestion.longitude
        ..country = suggestion.country
        ..state = suggestion.state,
    );
    Navigator.pop(context);
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
                      onPressed: (() => saveExit(suggestion)),
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
