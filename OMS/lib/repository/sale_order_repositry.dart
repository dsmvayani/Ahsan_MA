import 'dart:convert';

import 'package:BSProOMS/model/Customer.dart';
import 'package:BSProOMS/model/SaleOrderTab.dart';
import 'package:dio/dio.dart';

import '../data/SharedPreferencesConfig.dart';
import '../data/User.dart';
import '../page/sale-order/cubit/sale_order_state.dart';

class SaleOrderRepository{
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
  Future<Response?> saveOrder(SaleOrderState obj) async {
    try{
      User? user = await SharedPreferencesConfig.getUser();
      var api = await SharedPreferencesConfig.getAPIUrl();
      Dio dio = new Dio();
      dio.options.headers['Authorization'] = 'Bearer ' + await SharedPreferencesConfig.getToken();
      dio.options.headers['Content-Type'] = 'application/json';
      var json = {"nBillNo": obj.billNo, "nIsEdit": obj.isEdit, "nBillDate" : obj.billDate, "nCustomerCode": user!.nCustomerCode, "nDescription": obj.description, "nProductList": obj.listProducts!.map((e) => e.toJson()).toList(), "nTotalQuantity": obj.totalQuantity, "nTotalItems": obj.totalItems, "nNetAmount" : obj.netAmount};
      Response response = await dio.post(api+"BSProOMS/SaveSaleOrder", data: json);
      return response;
    }
    catch (error){
      return null;
    }
  }
  Future<Response?> getProductLookup() async {
    try{
      var api = await SharedPreferencesConfig.getAPIUrl();
      Dio dio = new Dio();
      dio.options.headers['Authorization'] = 'Bearer ' + await SharedPreferencesConfig.getToken();
      dio.options.headers['Content-Type'] = 'application/json';
      Response response = await dio.get(api+"BSProOMS/GetProductLookup");
      return response;
    }
    catch (error){
      return null;
    }
  }
  Future<Response?> getSaleOrderList(String isCompleted) async {
    try{
      User? user = await SharedPreferencesConfig.getUser();
      var api = await SharedPreferencesConfig.getAPIUrl();
      Dio dio = new Dio();
      dio.options.headers['Authorization'] = 'Bearer ' + await SharedPreferencesConfig.getToken();
      dio.options.headers['Content-Type'] = 'application/json';
      Response response = await dio.get(api+"BSProOMS/GetSaleOrderList?nCustomerCode="+user!.nCustomerCode+"&isCompleted="+isCompleted);
      return response;
    }
    catch (error){
      return null;
    }
  }
  // Future<Response?> getAllCities() async {
  //   try{
  //     var api = await SharedPreferencesConfig.getAPIUrl();
  //     Dio dio = new Dio();
  //     dio.options.headers['Authorization'] = 'Bearer ' + await SharedPreferencesConfig.getToken();
  //     dio.options.headers['Content-Type'] = 'application/json';
  //     Response response = await dio.get(api+"GSAPI/BSProLite/GetAllCities");
  //     return response;
  //   }
  //   catch (error){
  //     return null;
  //   }
  // }

}
class NetworkException implements Exception {}