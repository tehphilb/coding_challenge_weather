import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:coding_challenge_weather/constants/constants.dart';

class CustomAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(100);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      color: Constants.primaryBackgroundColor,
      child: const Row(
        children: [
          Icon(Icons.menu),
          Text('Hamburg'),
        ],
      ),
    );
  }
}
