import 'package:flutter/material.dart';

import '../data/SharedPreferencesConfig.dart';

class BSProWebDashboard extends StatefulWidget {
  final VoidCallback openDrawer;
  const BSProWebDashboard({Key? key, required this.openDrawer})
      : super(key: key);

  @override
  State<BSProWebDashboard> createState() =>
      _BSProWebDashboardState(openDrawer: this.openDrawer);
}

class _BSProWebDashboardState extends State<BSProWebDashboard> {
  final VoidCallback openDrawer;
  _BSProWebDashboardState({required this.openDrawer});

  Future<String> get _url async {
    String webUrl = "https://gentecbspro.com/";
    String mDashBoardKey = await SharedPreferencesConfig.getApiKey();
    String url = webUrl + mDashBoardKey; //+ "/home/dashboard";
    return url;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // backgroundColor: Colors.white,
        
        body: FutureBuilder(
          future: _url,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData)
              return SafeArea(
                child: Container()
                // child: WebviewScaffold(
                //   url: snapshot.data,
                //   geolocationEnabled: true,
                //   withJavascript: true,
                //   withLocalStorage: true,
                //   javascriptChannels: jsChannels,
                //   // hidden: true,
                // ),
              );
            else if (snapshot.hasError) {
              return Center(child: Text(snapshot.error.toString()));
            } else
              return Center(child: CircularProgressIndicator());
          },
        ));
  }
}
