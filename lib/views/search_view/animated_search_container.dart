import 'package:animations/animations.dart';
import 'package:coding_challenge_weather/constants/constants.dart';
import 'package:coding_challenge_weather/views/search_view/search_view.dart';
import 'package:flutter/material.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  @override
  Widget build(BuildContext context) {
    ContainerTransitionType containerTransitionType =
        ContainerTransitionType.fade;

    return OpenContainer(
      transitionType: containerTransitionType,
      transitionDuration: Duration(milliseconds: 600),
      openBuilder: (context, _) => Search(),
      closedElevation: 0,
      closedColor:
          Constants.transparent, //TODO: ugly UI side effect need to fix
      closedBuilder: (context, _) => Icon(
        Icons.add_rounded,
        color: Constants.textColor,
        size: 36,
      ),
    );
  }
}
