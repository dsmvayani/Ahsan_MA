import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:BSPRO/model/Clients.dart';
import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import '../model/SharedPreferencesConfig.dart';
import 'package:webview_flutter/webview_flutter.dart';

class DashboardScreen extends StatefulWidget {
  bool isUrl;
  DashboardScreen(this.isUrl);
  @override
  _DashboardScreenState createState() => _DashboardScreenState(this.isUrl);
}


class _DashboardScreenState extends State<DashboardScreen> {

  bool checkUrl;
  static bool isCheckUrl;
  _DashboardScreenState(this.checkUrl);
  bool _isLoadingPage = false;
  static String deviceId = "";
  bool connectionStatus = false;
  bool isConnected = false;
  Completer<WebViewController> _completer = Completer<WebViewController>();
  StreamSubscription<ConnectivityResult> networkSubscription;
  @override
  void initState() {
    super.initState();
    networkSubscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      check();
    });
    _isLoadingPage = true;
    isCheckUrl = checkUrl;
  }
   void startServiceInPlatform() async{
    if(Platform.isAndroid){
      String url = await ClientList.getClientAPI();
      if(url.isNotEmpty){
        var methodChannel = MethodChannel("com.gentecdashboard");
        String stopServiceMessage = await methodChannel.invokeMethod("stopFlutterBackgroundService");
        var token = await SharedPreferencesConfig.getToken();
        Dio dio = new Dio();
        String apiUrl = "${url}GSAPI/User/GetUserGPSCordinates";
        RequestOptions options = new RequestOptions();
        options.headers["Authorization"] = "Bearer " + token;
        Response response = await dio.get(apiUrl, options: options);
        var json = await response.data;
        Map<String, dynamic> jsonObj = jsonDecode(json);
        var interval = jsonObj['GetGPSCoordinatesInMinutes'];

        if(interval > 0){
          SharedPreferencesConfig.setLocationRestriction(true);
          var millis = jsonObj['GPSCoordinatesStartTime'];
          CheckLocation();
          String data = await methodChannel.invokeMethod("startFlutterBackgroundService",{"BASE_URL":url, "token" : token, "interval_time" : interval, "GPSCoordinatesStartTime": millis});
          debugPrint(data);
        }
        else{
          SharedPreferencesConfig.setLocationRestriction(false);
        }
      }
    }
  }
   Future<String> get _url async {
    String webUrl = "https://gentecbspro.com/";
    String mDashBoardKey = await SharedPreferencesConfig.getApiKey();
    print(deviceId);
    if(isCheckUrl)
      {
        String mDashBoardKey = await SharedPreferencesConfig.getApiKey();
        Timer(Duration(seconds: 40), () { CallService(webUrl); });
        return webUrl + mDashBoardKey;
      }
    else{
      String url = webUrl + mDashBoardKey + "/home/dashboard";
      Timer(Duration(seconds: 10), () { CallService(url); });

      return url;
    }
  }
  Future check() async {
    try {
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.mobile) {
        // I am connected to a mobile network.
        connectionStatus = true;
      } else if (connectivityResult == ConnectivityResult.wifi) {
        // I am connected to a wifi network.
        connectionStatus = true;
      }
    } on SocketException catch (_) {
      connectionStatus = false;
    }
  }
  @override
  Widget build(BuildContext context) {
   return FutureBuilder(
        future: check(), // a previously-obtained Future or null
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (connectionStatus == true) {
            return WillPopScope(
              child:FutureBuilder(
                  future: _url,
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData)
                      return SafeArea(
                        child: WebviewScaffold(
                          url: snapshot.data,
                          geolocationEnabled: true,
                          withJavascript: true,
                          withLocalStorage: true,
                          hidden: true,
                          ),
                      );
                    else if (snapshot.hasError) {
                      return Center(child: Text(snapshot.error.toString()));
                    } else
                      return Center(child: CircularProgressIndicator());
                  },
                )
            );
          } else {
            return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      child: Text('No internet connection !!!',
                          style: TextStyle(
                            // your text
                            fontFamily: 'Aleo',
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.bold,
                            fontSize: 25.0,
                          )),
                    ),
                  ],
                ));
          }
        });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _DashboardScreenState(false);
    super.dispose();
  }
  void CallService(String url) async{
    final flutterWebviewPlugin = new FlutterWebviewPlugin();

    flutterWebviewPlugin.launch(url, withLocalStorage: true,  withJavascript: true ).whenComplete(() async {
      final tokenResponse = await flutterWebviewPlugin.evalJavascript("(function() { try { return window.localStorage.getItem('userToken'); } catch (err) { return err; } })();");
      if(tokenResponse != "{}" && tokenResponse != "null"){
        String tokenResult = json.decode(tokenResponse);
        await SharedPreferencesConfig.setToken(tokenResult);
        startServiceInPlatform();
        print("Eval result: $tokenResponse");
      }
    });
}
  void RequestPermission() async{

    bool isLocationRestriction = await SharedPreferencesConfig.getLocationRestriction();
    if(isLocationRestriction){
      var status = await Permission.location.status;
      if(status.isGranted){
        Location location = new Location();
        bool _serviceEnabled = await location.serviceEnabled();
        if (!_serviceEnabled) {
          _serviceEnabled = await location.requestService();
          RequestPermission();
        }
      }
      else{
        final status1 = await Permission.locationWhenInUse.request();
        if (status1.isPermanentlyDenied) {
          print('Take the user to the settings page.');
          showLocationPermanentlyDisabled();
        }
        else{
          await Permission.location.request();
          RequestPermission();
        }
      }
    }
  }
  void showLocationPermanentlyDisabled() async{
    Alert(
      context: context,
      type: AlertType.info,
      title: "Location Permission",
      desc: "This App needs location permission access",
      buttons: [
        DialogButton(
          child: Text( "Open App Settings", style: TextStyle(color: Colors.white, fontSize: 20), ),
          onPressed: () => {  openAppSettings() },
          color: Colors.blue,
        )
      ],
    ).show();
  }
  void CheckLocation() async{

    final flutterWebviewPlugin = new FlutterWebviewPlugin();
    bool isLocationRestriction = await SharedPreferencesConfig.getLocationRestriction();
    if(isLocationRestriction){
      Location location = new Location();
      bool _serviceEnabled = await location.serviceEnabled();
      if (!_serviceEnabled) {
        flutterWebviewPlugin.clearCache();
        flutterWebviewPlugin.cleanCookies();
        flutterWebviewPlugin.goBack();
        RequestPermission();
      }
    }
  }
  // void CallWebview() async{
  //
  //   final flutterWebviewPlugin = new FlutterWebviewPlugin();
  //   flutterWebviewPlugin.onUrlChanged.listen((String url) async{
  //     if(url.contains("home")){
  //       bool isLocationRestriction = await SharedPreferencesConfig.getLocationRestriction();
  //       if(isLocationRestriction){
  //         Location location = new Location();
  //         bool _serviceEnabled = await location.serviceEnabled();
  //         if (!_serviceEnabled) {
  //           flutterWebviewPlugin.goBack();
  //           RequestPermission();
  //         }
  //       }
  //     }
  //   });
  // }
}
