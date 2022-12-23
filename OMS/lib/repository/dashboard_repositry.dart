
import 'package:dio/dio.dart';

import '../data/SharedPreferencesConfig.dart';

class DashboardRepository {

  Future<Response?> getDashboardData() async {
    try {
      var api = await SharedPreferencesConfig.getAPIUrl();
      Dio dio = new Dio();
      var token = await SharedPreferencesConfig.getToken();
      dio.options.headers['Authorization'] =
          'Bearer ' + await SharedPreferencesConfig.getToken();
      dio.options.headers['Content-Type'] = 'application/json';
      Response response = await dio.get(
          api + "api/BSProOMS/GetDashboardData");
      return response;
    }
    catch (error) {
      return null;
    }
  }

}

class NetworkException implements Exception {}