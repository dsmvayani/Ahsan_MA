import 'dart:convert';

import 'package:BSProOMS/data/User.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesConfig {
  static Future<SharedPreferences> get prefs => SharedPreferences.getInstance();

  static getApiKey() async {
    SharedPreferences p = await SharedPreferences.getInstance();
    var apiKey = p.getString("APIKey");
    return apiKey ?? '';
  }

  static setApiKey(String key) async {
    SharedPreferences p = await SharedPreferences.getInstance();
    p.setString("APIKey", key);
  }

  static getToken() async {
    // SharedPreferences p = await SharedPreferences.getInstance();
    return prefs.then((value) => value.getString("token") ?? '');
    // var token = p.getString("token");
    // return token ?? '';
  }

  static setToken(String key) async {
    SharedPreferences p = await SharedPreferences.getInstance();
    p.setString("token", key);
  }
  static getScreenChangeable() async {
    return prefs.then((value) => value.getBool("ScreenChange") ?? false);
  }

  static setScreenChangeable(bool isChange) async {
    SharedPreferences p = await SharedPreferences.getInstance();
    p.setBool("ScreenChange", isChange);
  }
  static getRememberMe() async {
    return prefs.then((value) => value.getBool("RememberMe") ?? false);
  }

  static setRememberMe(bool remember) async {
    SharedPreferences p = await SharedPreferences.getInstance();
    p.setBool("RememberMe", remember);
  }

  static removeToken() async {
    SharedPreferences p = await SharedPreferences.getInstance();
    p.remove("token");
  }
  static Future<User?> getUser() async {
    SharedPreferences p = await SharedPreferences.getInstance();
    String? userPref = p.getString('user');
    if(userPref!.isNotEmpty){
    Map<String,dynamic> userMap = jsonDecode(userPref) as Map<String, dynamic>;
    User user = User.fromJson(userMap);
    return user;
    }
    else{
      return null;
    }
  }

  static setUser(Map<String, dynamic> user) async {
    SharedPreferences p = await SharedPreferences.getInstance();
    await p.setString('user', jsonEncode(user));
  }

  static removeUser() async {
    SharedPreferences p = await SharedPreferences.getInstance();
    p.remove("user");
  }

  static removeRefreshToken() async {
    SharedPreferences p = await SharedPreferences.getInstance();
    p.remove("refresh_token");
  }

  static getRefresToken() async {
    SharedPreferences p = await SharedPreferences.getInstance();
    var apiKey = p.getString("refresh_token");
    return apiKey ?? '';
  }

  static setRefresToken(String key) async {
    SharedPreferences p = await SharedPreferences.getInstance();
    p.setString("refresh_token", key);
  }

  static getAPIUrl() async {
    // return "https://192.168.100.4:44382/";
    SharedPreferences p = await SharedPreferences.getInstance();
    var apiUrl = p.getString("apiUrl");
    return apiUrl ?? '';
  }

  static setAPIUrl(String url) async {
    SharedPreferences p = await SharedPreferences.getInstance();
    p.setString("apiUrl", url);
  }

  static getLocationRestriction() async {
    SharedPreferences p = await SharedPreferences.getInstance();
    var apiKey = p.getBool("isLocationRestriction");
    return apiKey ?? '';
  }

  static setLocationRestriction(bool key) async {
    SharedPreferences p = await SharedPreferences.getInstance();
    p.setBool("isLocationRestriction", key);
  }
}
