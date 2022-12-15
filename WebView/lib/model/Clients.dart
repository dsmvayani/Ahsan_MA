import 'dart:convert';

import 'package:BSPRO/model/Client.dart';
import 'package:BSPRO/model/SharedPreferencesConfig.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ClientList{


//  static InserUserLocation(String longitude, String latitude) async{
//
//    try {
//      var token = await SharedPreferencesConfig.getToken();
//      if(token != "null" && token != null && token.length > 0){
//        var apiKey = await SharedPreferencesConfig.getApiKey();
//        Dio dio = new Dio();
//        Response response1 = await dio.get("https://gentecbspro.com/${apiKey.toString()}/assets/Settings.json");
//        var api = await response1.data["Production_API"];
//        var body = { "SPNAME": "CRM_DataEntryGeolocationSP", "ReportQueryParameters": ["@nType", "@nsType", "@GPFormId", "@UserId", "@Latitude", "@Longitude", "@DocumentNo", "@Event"], "ReportQueryValue": ["1", "2", "36", "", latitude, longitude, "", "Live Tracking BY BS Pro APP"] };
//        String url = "${api.toString()}GSAPI/User/InsertDataFromApp";
//        RequestOptions options = new RequestOptions();
//        options.headers["Authorization"] = "Bearer " + token;
//        Response response = await dio.post(url,data: body,options: options);
//        print("Location Inserted Response : "+ response.toString());
//        var list = await response.data;
//      }
//    } catch (e) {
//      print(e);
//    }
//  }
  static Future<String> getClientAPI() async{
    String url = "";
    try{
      var apiUrl = await SharedPreferencesConfig.getAPIUrl();
      if(apiUrl != "null" && apiUrl != null && apiUrl.length > 0){
        return apiUrl;
      }
      else{
        var apiKey = await SharedPreferencesConfig.getApiKey();
        if(apiKey != "null" && apiKey != null && apiKey.length > 0){
          Dio dio = new Dio();
          Response response1 = await dio.get("https://gentecbspro.com/${apiKey.toString()}/assets/Settings.json");
          url = await response1.data["Production_API"];
          SharedPreferencesConfig.setAPIUrl(url);
          return url;
        }
        else{
          return url;
        }
      }
    }
    catch(e){
      return url;
    }
  }
  static getClient(String clientName)async{
    try{
      Dio dio = new Dio();
      Response response = await dio.get("https://gentecbspro.com/assets/Settings.json");
      var list = await response.data["clients"];
      for(int i = 0; i < list.length; i++)
      {
        Map client = list[i];
        var nClientName = client['id'];
        if(nClientName == clientName)
        {
          bool nClientLocationPermission = client['isLocationRestriction'] != null ? client['isLocationRestriction'] : false;
          await SharedPreferencesConfig.setLocationRestriction(nClientLocationPermission);
          return nClientName.toString();
        }
      }
      return null;
    }
    catch (Exception){
      return null;
    }
  }
  static Future<List> getClientList()async{
    try{
      Dio dio = new Dio();
      Response response = await dio.get("https://gentecbspro.com/assets/Settings.json");
      var list = await response.data["clients"];
      return list;
      List<Client> clientList = new List<Client>();
//      for(int i = 0; i < list.length; i++)
//      {
//        Map client = list[i];
//        String id = client.values.first.toString();
//        String name = client.values.last.toString();
//        Client c = new Client(id: id, name: name);
//        clientList.add(c);
//      }
//      return clientList;
    }
    catch (Exception){
      return null;
    }
  }
}