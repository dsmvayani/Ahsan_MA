
// ignore_for_file: non_constant_identifier_names


import 'package:dio/dio.dart';
import 'package:BSProOMS/data/SharedPreferencesConfig.dart';

class ClientList{

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
          return nClientName.toString();
        }
      }
      return null;
    }
    catch (Exception){
      return null;
    }
  }
  static setAPIUrl(String ClientKey)async{
    try{
      Dio dio = new Dio();
      Response response = await dio.get("https://gentecbspro.com/"+ClientKey+"/assets/Settings.json");
      var api = await response.data["Production_API"];
      if(api.toString().length > 0){
        SharedPreferencesConfig.setAPIUrl(api);
      }
    }
    catch (error){
      
    }
  }
  static Future<List?> getClientList()async{
    try{
      Dio dio = new Dio();
      Response response = await dio.get("https://gentecbspro.com/assets/Settings.json");
      var list = await response.data["clients"];
      return list;
    }
    catch (Exception){
      return null;
    }
  }
}