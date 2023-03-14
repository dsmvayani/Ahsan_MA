


import 'package:BSProOMS/data/User.dart';
import '../../../auth/form_submission_status.dart';

class SettingState{
  final String nOldPassword;
  final String nNewPassword;
  final String nReTypePassword;
  final String nShopName;
  final String nContactNo;
  final FormSubmissionStatus formStatus;
bool get isValidOldPassword => nOldPassword.length > 0;
bool get isValidNewPassword => nNewPassword.length > 0;
bool get isValidReTypePassword => nReTypePassword.length > 0;
bool get isValidReTypePasswordMatch => nReTypePassword == nNewPassword;
bool get isValidShopName => nShopName.length > 0;
bool get isValidMobile => RegExp(r'^((\+92)|(0092))-{0,1}\d{3}-{0,1}\d{7}$|^\d{11}$|^\d{4}-\d{7}$').hasMatch(nContactNo);
  
  SettingState({
    this.formStatus = const InitialFormStatus(),
    this.nOldPassword = '',
    this.nNewPassword = '',
    this.nReTypePassword = '',
    this.nShopName = '',
    this.nContactNo = '',
  });

  SettingState copyWith({
     FormSubmissionStatus? formStatus,
     User? objUser,
     String? nOldPassword,
     String? nNewPassword,
     String? nReTypePassword,
     String? nShopName,
     String? nContactNo,

    }) {
      return SettingState(
        nOldPassword: nOldPassword ?? this.nOldPassword,
        nNewPassword: nNewPassword ?? this.nNewPassword,
        nReTypePassword: nReTypePassword ?? this.nReTypePassword,
        nShopName: nShopName ?? this.nShopName,
        nContactNo: nContactNo ?? this.nContactNo,
        formStatus: formStatus ?? this.formStatus,
      );
    }
    // SettingState SettingsmJson(Map map){
    //   return SettingState.fromJson(map);
    // }
    // factory SettingState.fromJson(Map json){
    //      return SettingState(
    //        objUser: json["objUser"] ?? "",
    //        objBar: json["BarData"] ?? "",
    //        productOffers: json["productOffers"] ?? "",
    //        nCompletedOrder: json["CompletedOrder"] ?? "",
    //        nPendingOrder: json["PendingOrder"] ?? "",
    //        nAccountBalance: json["AccountBalance"] ?? "",
    //        nOrderDeliveryWeekDay: json["OrderDeliveryWeekDay"] ?? "",
    //        nAfterNextOrderDeliver: json["AfterNextOrderDeliver"] ?? "",
    //      );
    //    }
}
