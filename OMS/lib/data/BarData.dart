class BarData {
  String nBarcode;
  String nItem;
  double nQuantity;

  BarData({required this.nBarcode, required this.nItem, required this.nQuantity});
  factory BarData.fromJson(Map<String, dynamic> json) {
    return new BarData(
      nBarcode: json['Barcode'], nItem: json['Item'], nQuantity: json['Quantity']
    );
  }
}