import 'package:animations/animations.dart';
import 'package:coding_challenge_weather/constants/constants.dart';
import 'package:coding_challenge_weather/views/search_view/search_view.dart';
import 'package:flutter/material.dart';

class AnimatedSearchContainer extends StatefulWidget {
  const AnimatedSearchContainer({super.key, required this.color});

  final Color color;

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
      transitionDuration: const Duration(milliseconds: 500),
      openBuilder: (context, _) => SearchView(color: widget.color),
      closedElevation: 0,
      closedColor: widget.color,
      closedShape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(36),
        ),
      ),
      closedBuilder: (context, _) => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(36),
          color: widget.color,
        ),
        child: const Icon(
          Icons.add_rounded,
          color: Constants.textColor,
          size: 36,
        ),
      ),
    );
  }
}
