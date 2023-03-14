

import 'dart:convert';

import 'package:dio/dio.dart';
import '../data/SharedPreferencesConfig.dart';
import '../data/User.dart';
class AuthRepository{
  Future<String> attemptAutoLogin() async {
    var token = await SharedPreferencesConfig.getToken();
    if(token.toString().length > 0){
      return token;
    }
    else{
    throw Exception('not signed in');
    }
    // await Future.delayed(Duration(seconds: 1));
  }
  Future<bool> login(String userId,String password) async {
    print('attempting login');
    try{
      var api = await SharedPreferencesConfig.getAPIUrl();
      // var data = "username="+userId+"&password="+password+"&grant_type=password&ip=''&isQueryParameterExist=false";

      var data = {
        "username":userId,
        "password":password,
        "grant_type":"password",
        "isQueryParameterExist":"0"
      };
      Dio dio = new Dio();
      dio.options.headers['Content-Type'] = 'application/json';
      dio.options.headers['No-Auth'] = 'True';
      Response response = await dio.post(api+"Values/authenticate", data: data);
      var token = response.data["token"];
      var nUsername = response.data["username"] ?? userId;
      User user = User(nUserID: userId, nUserCode: '', nUserPassword: password, nUserName: nUsername, nCustomerCode: response.data["customerCode"], nUserType: response.data["userType"], nLoginStatus: !response.data["loginStatus"]);
      SharedPreferencesConfig.setUser(user.toJson());
      SharedPreferencesConfig.setScreenChangeable(false);
      // var refreshtoken = response.data["refresh_token"];
      SharedPreferencesConfig.setToken(token);
      // SharedPreferencesConfig.setRefresToken(refreshtoken);

      return true;

      
    }
    catch (error){
      return false;
    }
  }
  Future<bool> registerUser(String shopName,String contact, String password) async {
    try{
      var api = await SharedPreferencesConfig.getAPIUrl();
      print('-> api $api');
      // var data = "username="+userId+"&password="+password+"&grant_type=password&ip=''&isQueryParameterExist=false";

      var data = {
        "username":shopName,
        "password":password,
        "UserID":contact
      };
      Dio dio = new Dio();
      dio.options.headers['Content-Type'] = 'application/json';
      dio.options.headers['No-Auth'] = 'True';
      Response response = await dio.post("${api}BSProOMS/RegisterUser", data: data);
      if(response.statusCode == 200){
        print('register success');
        return true;
      }
      print('register failed');
      return false;
    }
    catch (error){
      print('--- error register --- $error');
      return false;
    }
  }
  Future<void> logOut() async {
    print('attempting logout');
    await SharedPreferencesConfig.removeToken();
    await SharedPreferencesConfig.removeRefreshToken();
    // await Future.delayed(Duration(seconds: 2));
  }
  Future<Response?> getData(String nSPNAME, List<String> nReportQueryParameters, List<String> nReportQueryValue) async{
    try {
      var api = await SharedPreferencesConfig.getAPIUrl();
      Dio dio = new Dio();
      var data = jsonEncode({ 'SPNAME': nSPNAME, 'ReportQueryParameters': nReportQueryParameters, 'ReportQueryValue': nReportQueryValue });
      dio.options.headers['Authorization'] = 'Bearer ' + await SharedPreferencesConfig.getToken();
      dio.options.headers['Content-Type'] = 'application/json';
      Response response = await dio.post( api + "/Users/GetData", data: data);
      return response;
    } catch (error) {
      return null;
    }
  }
}
