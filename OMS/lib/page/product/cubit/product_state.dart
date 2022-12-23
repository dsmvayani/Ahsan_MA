



import '../../../auth/form_submission_status.dart';

class ProductState{
  final FormSubmissionStatus formStatus;
  List<ProductState>? list;
  List<ProductState>? list1;
  final String nBarcode;
  final double nSalesRate;
  final String nAttribute1Code;
  final String nAttribute;
  final String nAttribute1Image;

  ProductState({
    this.list = const [],
    this.list1 = const [],
    this.formStatus = const InitialFormStatus(),
    this.nBarcode = '',
    this.nSalesRate = 0,
    this.nAttribute1Code = '',
    this.nAttribute = '',
    this.nAttribute1Image = '',
  });

  ProductState copyWith({
     FormSubmissionStatus? formStatus,
     List<ProductState>? list,
     List<ProductState>? list1,
     String? nBarcode,
     double? nSalesRate,
     String? nAttribute1Code,
     String? nAttribute,
    String? nAttribute1Image,
    }) {
      return ProductState(
        formStatus: formStatus ?? this.formStatus,
        list: list ?? this.list,
        list1: list1 ?? this.list1,
        nBarcode: nBarcode ?? this.nBarcode,
        nSalesRate: nSalesRate ?? this.nSalesRate,
        nAttribute1Code: nAttribute1Code ?? this.nAttribute1Code,
        nAttribute: nAttribute ?? this.nAttribute,
        nAttribute1Image: nAttribute1Image ?? this.nAttribute1Image,
      );
    }
    ProductState toProductJson(Map map){
      return ProductState.fromJson(map);
    }
    factory ProductState.fromJson(Map json){
         return ProductState(
             nBarcode: json["BarCode"] ?? "",
           nSalesRate: json["SalesRate"] ?? 0,
           nAttribute1Code: json["Attribute1Code"] ?? "",
           nAttribute: json["Attribute"] ?? "",
           nAttribute1Image: json["Attribute1Image"],
         );
       }
}
