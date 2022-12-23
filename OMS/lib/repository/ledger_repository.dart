
import 'dart:convert';

import 'package:dio/dio.dart';

import '../data/SharedPreferencesConfig.dart';

class LedgerRepository {


Future<Response?> getData(String nSPNAME, List<String> nReportQueryParameters, List<String> nReportQueryValue) async{
    try {
      var api = await SharedPreferencesConfig.getAPIUrl();
      Dio dio = new Dio();
      var data = jsonEncode({ 'SPNAME': nSPNAME, 'ReportQueryParameters': nReportQueryParameters, 'ReportQueryValue': nReportQueryValue });
      dio.options.headers['Authorization'] = 'Bearer ' + await SharedPreferencesConfig.getToken();
      dio.options.headers['Content-Type'] = 'application/json';
      Response response = await dio.post( api + "api/Users/GetData", data: data);
      return response;
    } catch (error) {
      return null;
    }
}
}


class NetworkException implements Exception {}