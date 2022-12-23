
import 'dart:convert';

import 'package:dio/dio.dart';

import '../data/SharedPreferencesConfig.dart';

class ProductRepository {

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
Future<Response?> getData(String nSPNAME, List<String> nReportQueryParameters, List<String> nReportQueryValue) async{
    try {
      var api = await SharedPreferencesConfig.getAPIUrl();
      Dio dio = new Dio();
      var data = jsonEncode({ 'SPNAME': nSPNAME, 'ReportQueryParameters': nReportQueryParameters, 'ReportQueryValue': nReportQueryValue });
      dio.options.headers['Authorization'] = 'Bearer ' + await SharedPreferencesConfig.getToken();
      dio.options.headers['Content-Type'] = 'application/json';
      // const response = await this.http.post(this.baseUrl + 'api/Users/GetData', data, { headers: reqHeader }).toPromise();
      Response response = await dio.post( api + "api/Users/GetData", data: data);
      return response;
    } catch (error) {
      return null;
    }
}
}


class NetworkException implements Exception {}