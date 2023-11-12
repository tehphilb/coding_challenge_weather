// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:coding_challenge_weather/constants/constants.dart';
import 'package:coding_challenge_weather/models/city_names_model.dart';
import 'package:coding_challenge_weather/services/api/city_names_api.dart';
import 'package:flutter/material.dart';

class Search extends StatefulWidget {
  const Search({
    super.key,
  });

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final controller = TextEditingController();
  Timer? _debounce;
  List<CityNames> nameSuggestions = [];
  final geocodingService = CityNamesApi();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.textColor,
      appBar: AppBar(
        backgroundColor: Constants.transparent,
        elevation: 0,
        leading: IconButton(
          splashColor: Constants.transparent,
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_rounded,
            color: Constants.appWhite,
            size: 36,
          ),
        ),
        title: Text(
          'Search',
          style: TextStyle(
            color: Constants.appWhite,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: controller,
              style: TextStyle(
                color: Constants.appWhite,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              decoration: InputDecoration(
                hintText: 'Search',
                hintStyle: TextStyle(
                  color: Constants.appWhite,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                border: InputBorder.none,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: nameSuggestions.length,
              itemBuilder: (context, index) {
                print('NameSuggestions ${nameSuggestions[0].name}');
                final suggestion = nameSuggestions[index];
                return ListTile(
                  title: Text(
                    suggestion.name,
                    style: TextStyle(
                      color: Constants.appWhite,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    suggestion.country,
                    style: TextStyle(
                      color: Constants.appWhite,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  trailing: IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.add_rounded,
                      color: Constants.appWhite,
                      size: 36,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
