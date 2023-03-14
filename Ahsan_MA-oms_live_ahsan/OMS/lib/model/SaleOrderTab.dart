import 'dart:convert';

import 'package:BSProOMS/model/Customer.dart';
import 'package:BSProOMS/model/SalesManTab.dart';
import 'package:hive/hive.dart';
import 'Product.dart';
part 'SaleOrderTab.g.dart';
@HiveType(typeId: 4)
class SaleOrderTab extends HiveObject{
  @HiveField(0)
  final String nBillDate;
  @HiveField(1)
  final Customer nCustomer;
  @HiveField(2)
  final SalesManTab nSalesMan;
  @HiveField(3)
  final String nDescription;
  @HiveField(4)
  final List<Product> nProductList;
  @HiveField(5)
  final double nTotalQuantity;
  @HiveField(6)
  final double nTotalItems;
  @HiveField(7)
  final double nNetAmount;
  @HiveField(8)
  final bool isSync;

  SaleOrderTab({
    required this.nBillDate,
    required this.nCustomer,
    required this.nSalesMan,
    required this.nDescription,
    required this.nProductList,
    required this.nTotalQuantity,
    required this.nTotalItems,
    required this.nNetAmount,
    required this.isSync
  });
  // SaleOrderTab SaleOrderTabFromJson(Map map){
  //   return SaleOrderTab.fromJson(map);
  // }
  // factory SaleOrderTab.fromJson(Map json){
  //   return SaleOrderTab(
  //       customerName: json["customerName"] ?? "",
  //       cnicNo: json["cnicNo"] ?? "",
  //       phoneNo: json["phoneNo"] ?? "",
  //       mobileNo: json["mobileNo"] ?? "",
  //       emailId: json["emailId"] ?? "",
  //       city: json["city"] ?? "",
  //       address: json["address"] ?? "",
  //       isSync: false
  //   );
  // }
  Map<String, dynamic> SaleOrderToJson(){
    return {
      'nBillDate': this.nBillDate,
      'nCustomer': jsonEncode(this.nCustomer),
      'nSalesMan': jsonEncode(this.nSalesMan),
      'nDescription': this.nDescription,
      'nProductList': jsonEncode(this.nProductList.map((e) => e.toJson()).toList()),
      'nTotalQuantity': this.nTotalQuantity,
      'nTotalItems': this.nTotalItems,
      'nNetAmount': this.nNetAmount,
    };
  }
}