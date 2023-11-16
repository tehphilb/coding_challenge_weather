import 'package:coding_challenge_weather/models/isar_city_collection.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class IsarService {
  late Future<Isar> db;

  IsarService() {
    db = openDB();
  }

  Future<void> saveName(City newCity) async {
    final isar = await db;

    await isar.writeTxn(
      () async {
        final existingCities = await isar.citys
            .filter()
            .nameEqualTo(newCity.name)
            .and()
            .stateEqualTo(newCity.state)
            .and()
            .countryEqualTo(newCity.country)
            .findAll();
        if (existingCities.isEmpty) {
          await isar.citys.put(newCity);
        }
      },
    );
  }

  Future<void> deleteName(String cityName) async {
    final isar = await db;
    await isar.writeTxn(() async {
      final citiesToDelete =
          await isar.citys.filter().nameEqualTo(cityName).findAll();

      // Delete all cities that match the query
      for (var city in citiesToDelete) {
        await isar.citys.delete(city.id);
      }
    });
  }

  Future<List<City>> getAllCities() async {
    final isar = await db;
    return await isar.citys.where().findAll();
  }

  void listenToCityChanges(Isar isar) {
    Stream<void> cityChanged = isar.citys.watchLazy();

    cityChanged.listen((_) {
      print('A User changed');
    });
  }

  Future<void> cleanDb() async {
    final isar = await db;
    await isar.writeTxn(() => isar.clear());
  }

  Future<Isar> openDB() async {
    final dir = await getApplicationDocumentsDirectory();
    if (Isar.instanceNames.isEmpty) {
      return await Isar.open(
        [CitySchema],
        directory: dir.path,
        inspector: true,
      );
    }

    return Future.value(Isar.getInstance());
  }
}
