


import 'package:BSProOMS/data/ProductOffers.dart';
import 'package:BSProOMS/data/User.dart';

import '../../../auth/form_submission_status.dart';
import '../../../data/BarData.dart';

class DashboardState{
  final FormSubmissionStatus formStatus;
  User? objUser;
  final List<BarData> objBar;
  final List<ProductOffers> productOffers;
  final String nCompletedOrder;
  final String nPendingOrder;
  final String nAccountBalance;
  final String nOrderDeliveryWeekDay;
  final String nContactNo;
  final String nWhatsappNo;
  final int nAfterNextOrderDeliver;

  DashboardState({
    this.formStatus = const InitialFormStatus(),
    this.objUser,
    this.objBar = const [],
    this.productOffers = const [],
    this.nCompletedOrder = '',
    this.nPendingOrder = '',
    this.nAccountBalance = '',
    this.nOrderDeliveryWeekDay = '',
    this.nContactNo = '',
    this.nWhatsappNo = '',
    this.nAfterNextOrderDeliver = 0,
  });

  DashboardState copyWith({
     FormSubmissionStatus? formStatus,
     User? objUser,
    List<BarData>? objBar,
    List<ProductOffers>? productOffers,
    String? nCompletedOrder,
    String? nPendingOrder,
    String? nAccountBalance,
     String? nOrderDeliveryWeekDay,
     String? nContactNo,
     String? nWhatsappNo,
    int? nAfterNextOrderDeliver,

    }) {
      return DashboardState(
        objUser: objUser ?? this.objUser,
        nCompletedOrder: nCompletedOrder ?? this.nCompletedOrder,
        nPendingOrder: nPendingOrder ?? this.nPendingOrder,
        objBar: objBar ?? this.objBar,
        productOffers: productOffers ?? this.productOffers,
        nAccountBalance: nAccountBalance ?? this.nAccountBalance,
        nOrderDeliveryWeekDay: nOrderDeliveryWeekDay ?? this.nOrderDeliveryWeekDay,
        nContactNo: nContactNo ?? this.nContactNo,
        nWhatsappNo: nWhatsappNo ?? this.nWhatsappNo,
        nAfterNextOrderDeliver: nAfterNextOrderDeliver ?? this.nAfterNextOrderDeliver,
        formStatus: formStatus ?? this.formStatus,
      );
    }
    DashboardState DashboardStateFromJson(Map map){
      return DashboardState.fromJson(map);
    }
    factory DashboardState.fromJson(Map json){
         return DashboardState(
           objUser: json["objUser"] ?? "",
           objBar: json["BarData"] ?? "",
           productOffers: json["productOffers"] ?? "",
           nCompletedOrder: json["CompletedOrder"] ?? "",
           nPendingOrder: json["PendingOrder"] ?? "",
           nAccountBalance: json["AccountBalance"] ?? "",
           nOrderDeliveryWeekDay: json["OrderDeliveryWeekDay"] ?? "",
           nContactNo: json["ContactNo"] ?? "",
           nWhatsappNo: json["OrderDeliveryWeekDay"] ?? "",
           nAfterNextOrderDeliver: json["WhatsappNo"] ?? "",
         );
       }
}
