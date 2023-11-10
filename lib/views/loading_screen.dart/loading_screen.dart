import 'package:coding_challenge_weather/services/api/geo_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:coding_challenge_weather/constants/constants.dart';

class LoadingScreen extends ConsumerWidget {
  const LoadingScreen({
    super.key,
    required this.constraints,
  });

  final BoxConstraints constraints;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Container(
        color: Constants.primaryBackgroundColor,
        child: FutureBuilder(
          future: Location().getCurrentPosition(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final position = snapshot.data!;
              return Center(
                child: Text(position.toString()),
              );
            } else if (snapshot.hasError) {
              return const Center(
                child: Text('Error'),
              );
            } else {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 20),
                    Text('Loading your position...'),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
