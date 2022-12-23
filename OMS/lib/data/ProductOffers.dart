class ProductOffers {
  String nOfferDescription;
  String nBarCode;
  DateTime nStartDate;
  DateTime nEndDate;
  bool nIsActive;
  String nAttribute1Image;

  ProductOffers({required this.nOfferDescription, required this.nBarCode, required this.nStartDate, required this.nEndDate, required this.nIsActive, required this.nAttribute1Image});
  factory ProductOffers.fromJson(Map<String, dynamic> json) {
    return new ProductOffers(
        nOfferDescription: json['OfferDescription'], nBarCode: json['BarCode'], nStartDate: json['StartDate'], nEndDate: json['EndDate'], nIsActive: json['IsActive'], nAttribute1Image: json['Attribute1Image']
    );
  }
}