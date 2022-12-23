import 'package:flutter/material.dart';

abstract class RegisterEvent {}

class RegisterShopNameChanged extends RegisterEvent{
  final String shopName;
  RegisterShopNameChanged({required this.shopName});
}

// class GetDefaultMobileCode extends RegisterEvent{
//   TextEditingController controller;
//   GetDefaultMobileCode({required this.controller});
// }
class RegisterContactNoChanged extends RegisterEvent{
  final String contactNo;
  RegisterContactNoChanged({required this.contactNo});
}
class RegisterVerificationCode extends RegisterEvent{
  final String verificationCode;
  RegisterVerificationCode({required this.verificationCode});
}
class RegisterContactNoVerified extends RegisterEvent{
  final String contactNo;
  RegisterContactNoVerified({required this.contactNo});
}

class RegisterPasswordChanged extends RegisterEvent{
  final String password;
  RegisterPasswordChanged({required this.password});
}
class VerificationCode1Change extends RegisterEvent{
  final String code;
  VerificationCode1Change({required this.code});
}
class VerificationCode2Change extends RegisterEvent{
  final String code;
  VerificationCode2Change({required this.code});
}
class VerificationCode3Change extends RegisterEvent{
  final String code;
  VerificationCode3Change({required this.code});
}
class VerificationCode4Change extends RegisterEvent{
  final String code;
  VerificationCode4Change({required this.code});
}
class VerificationCode5Change extends RegisterEvent{
  final String code;
  VerificationCode5Change({required this.code});
}
class VerificationCode6Change extends RegisterEvent{
  final String code;
  VerificationCode6Change({required this.code});
}

class RegisterSubmitted extends RegisterEvent{}
class VerificationProcess extends RegisterEvent{}
class Logout extends RegisterEvent{}