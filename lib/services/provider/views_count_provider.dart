import 'package:coding_challenge_weather/services/isar_db/isar_services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final viewsCountProvider = FutureProvider.autoDispose<int>((ref) async {
  final cities = await IsarService().getAllCities();
  return cities.length;
});
