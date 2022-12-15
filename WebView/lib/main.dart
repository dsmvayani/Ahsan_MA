// @dart=2.9
import 'dart:async';
import 'package:BSPRO/model/Client.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'model/Clients.dart';
import 'model/SharedPreferencesConfig.dart';
import 'screens/DashboardScreen.dart';

//void backgroundFetchHeadlessTask(HeadlessTask task) async {
//  print("Hey Yasir Background [Headless] is Successfull");
//  CallPosition();
//  String taskId = task.taskId;
//  bool isTimeout = task.timeout;
//  if (isTimeout) {
//    BackgroundFetch.finish(taskId);
//    return;
//  }
//  BackgroundFetch.finish(taskId);
//}
void main() {
  runApp(new MyApp());
//  BackgroundFetch.registerHeadlessTask(backgroundFetchHeadlessTask);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dashboard',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  bool IsAdmin = false;
  final _alertAdminController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: IsClient ?  Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              constraints: BoxConstraints.expand(),
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/bg.jpeg'),
                      fit: BoxFit.fill)
              ),
            ) : Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
              GestureDetector(
              child:CircularProgressIndicator(),
          onDoubleTap: () {
                setState(() {
                  IsAdmin = true;
                });
            Alert(
                context: this.context,
                title: "Input Password",
                content: Column(
                  children: <Widget>[
                    TextField(
                      obscureText: true,
                      enableSuggestions: false,
                      autocorrect: false,
                      decoration: InputDecoration(
                        icon: Icon(Icons.lock),
                        labelText: 'Password',
                      ),
                      controller: _alertAdminController,
                    ),
                  ],
                ),
                buttons: [
                  DialogButton(
                    onPressed: () {
                      if(_alertAdminController.text.toString().trim() == "54321"){
                        Navigator.pop(context);
                        _ShowAdminDialog();
                      }

                    }
                    ,
                    child: Text(
                      "OK",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  )
                ]).show();
          },
        ),
      Padding(padding: const EdgeInsets.only(top: 8),
      child: Text('Loading...'))
                ],
              ),
            )
        )
    );
  }

  final _alertCompanyController = TextEditingController();
  bool IsClient = false;
  String _chosenValue;
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 5), () {
      if(!IsAdmin)
        checkInitialScreen();
    });
    //checkInitialScreen();
//    initPlatformState();
  }

  checkInitialScreen() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool firstTime = prefs.getBool('first_time');
    if (firstTime == null) {// Not first time
      Alert(
          context: context,
          title: "Company Code",
          content: Column(
            children: <Widget>[
              TextField(
                decoration: InputDecoration(
                  icon: Icon(Icons.account_box),
                  labelText: 'KEY',
                ),
                controller: _alertCompanyController,
              ),
            ],
          ),
          buttons: [
            DialogButton(
              onPressed: () {
                Navigator.pop(context);
                checkCompany(_alertCompanyController.text);
              }
              ,
              child: Text(
                "OK",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            )
          ]).show();
    }
    else if(firstTime && SharedPreferencesConfig.getApiKey().toString().length > 1){
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) {
            return DashboardScreen(false);
          }));
    }
  }
  void _ShowAdminDialog() async{
    List<Client> _client = [];
    var json = await ClientList.getClientList();
    _client = (json).map<Client>((item) => Client.fromJson(item)).toList();
    _client.sort((a, b) => a.name.compareTo(b.name));
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: new Text("Client Selection"),
              content:
              Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: new DropdownButton<String>(
                      hint: Text('Select one option'),
                      value: _chosenValue,
                      underline: Container(),
                      items: _client.map((Client map) {
                        return new DropdownMenuItem<String>(
                          value: map.id,
                          child: new Text(map.name,
                              style: new TextStyle(color: Colors.black,fontWeight: FontWeight.w500)),
                        );
                      }).toList(),
                      onChanged: (String value) {
                        setState(() {
                          _chosenValue = value;
                        });
                      },
                    )),
              ]),
              actions: <Widget>[
                new ElevatedButton(
                  child: new Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop();
                    if(_chosenValue != null)
                    {
                      SharedPreferencesConfig.setApiKey(_chosenValue);
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) {
                            return DashboardScreen(true);
                          }));
                    }
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
  checkCompany(String companyName) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(companyName != null && companyName.length > 0){
      String clientKey = await ClientList.getClient(companyName);
      if(clientKey != null)
      {
        prefs.setBool('first_time', true);
        SharedPreferencesConfig.setApiKey(clientKey);
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
              return DashboardScreen(true);
            }));
      }
      else{
        IsClient = false;
        Alert(
            context: context,
            type: AlertType.warning,
            title: "Un Authorized",
            content: Text("Your Company is not in the list. please contact to the administrator.", style: TextStyle(fontSize: 14),),
            buttons: [
              DialogButton(
                child: Text("OK"),
                onPressed: () async { Navigator.pop(context); },
              ),
            ]).show();
      }
    }
  }
//  Future<void> initPlatformState() async {
//    await BackgroundFetch.configure(BackgroundFetchConfig( minimumFetchInterval: 15, stopOnTerminate: false, enableHeadless: true, requiresBatteryNotLow: false, requiresCharging: false, requiresStorageNotLow: false, requiresDeviceIdle: false,  requiredNetworkType: NetworkType.NONE ),
//            (String taskId) async {
//          print("Hey Yasir Background is Successfull");
//          CallPosition();
//          BackgroundFetch.finish(taskId);
//        }, (String taskId) async {
//          BackgroundFetch.finish(taskId);
//        });
//    if (!mounted) return;
//  }
  // static CallPosition() async{
  //   print("Yasir Location going to be fetch" );
  //   Position userLocation = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  //   ClientList.InserUserLocation(userLocation.longitude.toString(), userLocation.latitude.toString());
  //   print("Yasir Location: Longitude"+userLocation.longitude.toString() + " Latitude: " + userLocation.latitude.toString() );
  // }

}
//CallPosition() async{
//  print("Yasir Location going to be fetch" );
//  var status = await Permission.location.status;
//  if(status.isGranted){
//    final serviceEnable = await Geolocator().isLocationServiceEnabled();
//    if(serviceEnable){
//      Position userLocation = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
//      ClientList.InserUserLocation(userLocation.longitude.toString(), userLocation.latitude.toString());
//      print("Yasir Location: Longitude"+userLocation.longitude.toString() + " Latitude: " + userLocation.latitude.toString() );
//    }
//  }
//  else{
//    await Permission.location.request();
//  }
//}
