import 'package:hive/hive.dart';
part 'SalesManTab.g.dart';
@HiveType(typeId: 2)
class SalesManTab{
  @HiveField(0)
  final String nSalesManCode;
  @HiveField(1)
  final String nSalesMan;
  @HiveField(2)
  final String nShortName;

  const SalesManTab({
    required this.nSalesManCode,
    required this.nSalesMan,
    required this.nShortName,
  });
  factory SalesManTab.SalesManTabStateFromJson(Map map) {
    return SalesManTab.fromJson(map);
  }
  factory SalesManTab.fromJson(Map json) {
    return SalesManTab(nSalesManCode: json["SalesManCode"] ?? "", nSalesMan: json["SalesMan"] ?? "", nShortName: json["ShortName"] ?? "");
  }
  toJson() {
    return {
      'nSalesManCode': this.nSalesManCode,
      'nSalesMan': this.nSalesMan,
      'nShortName': this.nShortName
    };
  }
}