import 'package:hive/hive.dart';
part 'City.g.dart';

@HiveType(typeId: 1)
class City {
  @HiveField(0)
  final String cityCode;
  @HiveField(1)
  final String city;

  const City({
    required this.cityCode,
    required this.city,
  });
factory City.cityStateFromJson(Map map) {
    return City.fromJson(map);
  }
  factory City.fromJson(Map json) {
    return City(cityCode: json["CityCode"] ?? "", city: json["City"] ?? "");
  }
}
