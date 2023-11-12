import 'package:coding_challenge_weather/models/isar_city_collection.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class IsarService {
  late Future<Isar> db;

  IsarService() {
    db = openDB();
  }

  Future<void> saveName(CityNameIsar newCity) async {
    final isar = await db;
    isar.writeTxnSync<int>(() => isar.cityNameIsars.putSync(newCity));
  }

  Future<void> deleteName(CityNameIsar city) async {
    final isar = await db;
    isar.writeTxnSync(() async => await isar.cityNameIsars.delete(city.id));
  }

  Future<List<CityNameIsar>> getAllCityNames() async {
    final isar = await db;
    return await isar.cityNameIsars.where().findAll();
  }

  Future<void> cleanDb() async {
    final isar = await db;
    await isar.writeTxn(() => isar.clear());
  }

  Future<Isar> openDB() async {
    final dir = await getApplicationDocumentsDirectory();
    if (Isar.instanceNames.isEmpty) {
      return await Isar.open(
        [CityNameIsarSchema],
        directory: dir.path,
        inspector: true,
      );
    }

    return Future.value(Isar.getInstance());
  }
}
