
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesConfig{

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
    SharedPreferences p = await SharedPreferences.getInstance();
    var apiKey = p.getString("token");
    return apiKey ?? '';
  }
  static setToken(String key) async {
    SharedPreferences p = await SharedPreferences.getInstance();
    p.setString("token", key);
  }
  static getAPIUrl() async {
    SharedPreferences p = await SharedPreferences.getInstance();
    var apiUrl = p.getString("apiUrl");
    return apiUrl ?? '';
  }
  static setAPIUrl(String key) async {
    SharedPreferences p = await SharedPreferences.getInstance();
    p.setString("apiUrl", key);
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