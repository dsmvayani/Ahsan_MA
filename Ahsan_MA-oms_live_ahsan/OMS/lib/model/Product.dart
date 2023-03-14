
import 'dart:convert';
import 'dart:typed_data';

class Product{
  final String nBarCode;
  final String nItem;
  final String nUnitCode;
  final String nAttribute;
  final String nAttribute1Image;
  final double nSalesRate;
  double nQuantity;
  double nAmount;
  Product({
    required this.nBarCode,
    required this.nItem,
    required this.nUnitCode,
    required this.nAttribute,
    required this.nAttribute1Image,
    required this.nSalesRate,
    required this.nQuantity,
    required this.nAmount,
  });
  factory Product.ProductStateFromJson(Map map) {
    return Product.fromJson(map);
  }
  factory Product.fromJson(Map json) {
    return Product(nBarCode: json["BarCode"] ?? "", nItem: json["Item"] ?? "", nUnitCode: json["Attribute1Code"] ?? "", nSalesRate: json["SalesRate"] ?? "", nQuantity: 1, nAmount: json["SalesRate"], nAttribute: json["Attribute"], nAttribute1Image: json["Base64Image"] != null ? json["Base64Image"] : '');
  }

  toJson() {
    return {
      'nBarCode': this.nBarCode,
      'nSalesRate': this.nSalesRate,
      'nQuantity': this.nQuantity,
      'nAmount': this.nAmount,
      'nAttribute': this.nAttribute,
      'Base64Image': this.nAttribute1Image
    };
  }
}