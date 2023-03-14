class User {
  String nUserID;
  String nUserCode;
  String nUserPassword;
  String nUserName;
  String nUserType;
  String nCustomerCode;
  bool nLoginStatus;

  User({required this.nUserID, required this.nUserCode, required this.nUserPassword, required this.nUserName, required this.nUserType, required this.nCustomerCode, required this.nLoginStatus});
  factory User.fromJson(Map<String, dynamic> json) {
    return new User(
        nUserID: json['UserID'],
        nUserCode: json['UserCode'],
      nUserPassword: json['password'],
        nUserName: json['UserName'],
        nUserType: json['UserType'],
        nCustomerCode: json['CustomerCode'],
      nLoginStatus: json['LoginStatus'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      "UserID": this.nUserID,
      "UserCode": this.nUserCode,
      "password": this.nUserPassword,
      "UserName": this.nUserName,
      "UserType": this.nUserType,
      "CustomerCode": this.nCustomerCode,
      "LoginStatus": this.nLoginStatus,
    };
  }
}