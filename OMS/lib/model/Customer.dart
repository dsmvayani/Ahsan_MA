import 'package:hive/hive.dart';
part 'Customer.g.dart';
@HiveType(typeId: 0)
class Customer extends HiveObject {
  @HiveField(0)
  String? customerName;
  @HiveField(1)
  String? address;
  @HiveField(2)
  String? city;
  @HiveField(3)
  String? phoneNo;
  @HiveField(4)
  String? mobileNo;
  @HiveField(5)
  String? emailId;
  @HiveField(6)
  String? cnicNo;
  @HiveField(7)
  bool isSync = false;
  @HiveField(8)
  String? customerCode;

   Customer({
    this.customerName,
    this.address,
    this.city,
    this.phoneNo,
    this.mobileNo,
    this.emailId,
    this.cnicNo,
    this.customerCode,
    required this.isSync
  });
  Customer customerStateFromJson(Map map){
    return Customer.fromJson(map);
  }
  factory Customer.fromJson(Map json){
    return Customer(
        customerCode: json["customerCode"] ?? "",
        customerName: json["customerName"] ?? "",
        cnicNo: json["cnicNo"] ?? "",
        phoneNo: json["phoneNo"] ?? "",
        mobileNo: json["mobileNo"] ?? "",
        emailId: json["emailId"] ?? "",
        city: json["city"] ?? "",
        address: json["address"] ?? "",
        isSync: false
    );
  }
  toJson() {
    return {
      'customerCode': this.customerCode,
      'customerName': this.customerName,
      'cnicNo': this.cnicNo,
      'phoneNo': this.phoneNo,
      'mobileNo': this.mobileNo,
      'emailId': this.emailId,
      'city': this.city,
      'address': this.address,
    };
  }
}