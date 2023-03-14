


import 'package:BSProOMS/model/City.dart';

import '../../../auth/form_submission_status.dart';

class CustomerState{
  final String customerCode;
  final String customerName;
  final String cnic;
  final String phoneNo;
  final String mobileNo;
  final String email;
  final String city;
  final String address;
  final bool isSync;
  final FormSubmissionStatus formStatus;
  final List<CustomerState>? list;
  final List<City>? cityList;

  bool get isValidCNIC => RegExp(r'^[0-9+]{5}-[0-9+]{7}-[0-9]{1}$').hasMatch(cnic);
  bool get isValidMobile => RegExp(r'^((\+92)|(0092))-{0,1}\d{3}-{0,1}\d{7}$|^\d{11}$|^\d{4}-\d{7}$').hasMatch(mobileNo);
  bool get isValidEmail => RegExp(r'^\S+@\S+\.\S+$').hasMatch(email);
  CustomerState({
    this.customerCode = '',
    this.customerName = '',
    this.cnic = '',
    this.phoneNo = '',
    this.mobileNo = '',
    this.email = '',
    this.city = '',
    this.address = '',
    this.isSync = false,
    this.list = const [],
    this.cityList = const [],
    this.formStatus = const InitialFormStatus(),
  });

  CustomerState copyWith({
     String? customerCode,
     String? customerName,
     String? cnic,
     String? phoneNo,
     String? mobileNo,
     String? email,
     String? city,
     String? address,
     FormSubmissionStatus? formStatus,
     List<CustomerState>? list,
     List<City>? cityList,
    bool? isSync,
    }) {
      return CustomerState(
          customerCode: customerCode ?? this.customerCode,
        customerName: customerName ?? this.customerName,
        cnic: cnic ?? this.cnic,
        phoneNo: phoneNo ?? this.phoneNo,
        mobileNo: mobileNo ?? this.mobileNo,
        email: email ?? this.email,
        city: city ?? this.city,
        address: address ?? this.address,
        formStatus: formStatus ?? this.formStatus,
        list: list ?? this.list,
        cityList: cityList ?? this.cityList,
        isSync: isSync ?? this.isSync
      );
    }
    CustomerState customerStateFromJson(Map map){
      return CustomerState.fromJson(map);
    }
    factory CustomerState.fromJson(Map json){
         return CustomerState(
             customerCode: json["CustomerCode"] ?? "",
           customerName: json["Customer"] ?? "",
           cnic: json["CNICNo"] ?? "",
           phoneNo: json["PhoneNo"] ?? "",
           mobileNo: json["MobileNo"] ?? "",
           email: json["EmailId"] ?? "",
           city: json["CityCode"] ?? "",
           address: json["Address"] ?? "",
           isSync: false
         );
       }
}
