import 'package:animations/animations.dart';
import 'package:coding_challenge_weather/constants/constants.dart';
import 'package:coding_challenge_weather/views/search_view/search_view.dart';
import 'package:flutter/material.dart';

class AnimatedSearchContainer extends StatefulWidget {
  const AnimatedSearchContainer({super.key});

  @override
  State<AnimatedSearchContainer> createState() =>
      _AnimatedSearchContainerState();
}

class _AnimatedSearchContainerState extends State<AnimatedSearchContainer> {
  @override
  Widget build(BuildContext context) {
    ContainerTransitionType containerTransitionType =
        ContainerTransitionType.fade;

    return OpenContainer(
      transitionType: containerTransitionType,
      transitionDuration: const Duration(milliseconds: 600),
      openBuilder: (context, _) => const SearchView(),
      closedElevation: 0,
      closedColor:
          Constants.transparent, //TODO: ugly UI side effect need to fix
      closedBuilder: (context, _) => const Icon(
        Icons.add_rounded,
        color: Constants.textColor,
        size: 36,
      ),
    );
  }
}
