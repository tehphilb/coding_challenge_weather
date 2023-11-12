import 'package:isar/isar.dart';

part 'isar_city_collection.g.dart';

@collection
class CityNameIsar {
  Id id = Isar.autoIncrement;

  String? name;
  double? latitude;
  double? longitude;
  String? country;
  String? state;
}
