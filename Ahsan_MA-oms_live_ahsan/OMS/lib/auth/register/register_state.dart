import 'package:BSProOMS/auth/form_submission_status.dart';

class RegisterState{
  final String shopName;
  bool get isValidShopName => shopName.length > 3;
  final String contactNo;
  // bool get isValidContactNo => RegExp(r'^((\+92))-{0,1}\d{3}-{0,1}\d{7}$|^\d{11}$|^\d{4}-\d{7}$').hasMatch(contactNo);
  bool get isValidContactNo => RegExp(r'^((\+92)?(0092)?)(3)([0-9]{9})$').hasMatch(contactNo);
  // bool get isValidContactNo => contactNo.length > 3;
  final String password;
  bool get isValidPassword => password.length > 3;
  final String verifyCode1;
  final String verifyCode2;
  final String verifyCode3;
  final String verifyCode4;
  final String verifyCode5;
  final String verifyCode6;
  final String? nVerificationId;
  // bool get isValidVerificationCode => verificationCode.length > 3;
  // final bool isVerifiedContact;
  
  final FormSubmissionStatus formStatus;

  RegisterState({
    this.shopName = '',
    this.contactNo = '',
    this.password = '',
    this.verifyCode1 = '',
    this.verifyCode2 = '',
    this.verifyCode3 = '',
    this.verifyCode4 = '',
    this.verifyCode5 = '',
    this.verifyCode6 = '',
    this.nVerificationId = '',
    // this.isVerifiedContact = false,
    this.formStatus = const InitialFormStatus(),
  });

  RegisterState copyWith({
     String? shopName,
     String? contactNo,
     String? password,
     String? verifyCode1,
     String? verifyCode2,
     String? verifyCode3,
     String? verifyCode4,
     String? verifyCode5,
     String? verifyCode6,
    String? mVerificationId,
     // bool? isVerifiedContact,
     FormSubmissionStatus? formStatus,
    }) {
      return RegisterState(
          shopName: shopName ?? this.shopName,
          contactNo: contactNo ?? this.contactNo,
          verifyCode1: verifyCode1 ?? this.verifyCode1,
          verifyCode2: verifyCode2 ?? this.verifyCode2,
          verifyCode3: verifyCode3 ?? this.verifyCode3,
          verifyCode4: verifyCode4 ?? this.verifyCode4,
          verifyCode5: verifyCode5 ?? this.verifyCode5,
          verifyCode6: verifyCode6 ?? this.verifyCode6,
          nVerificationId: mVerificationId ?? this.nVerificationId,
          // isVerifiedContact: isVerifiedContact ?? this.isVerifiedContact,
        password: password ?? this.password,
        formStatus: formStatus ?? this.formStatus
      );
    }
}