import 'dart:async';

import 'package:BSProOMS/data/Constants.dart';
import 'package:flutter/material.dart';
import 'package:BSProOMS/data/DrawerItems.dart';
import 'package:sizer/sizer.dart';

import '../data/SharedPreferencesConfig.dart';
import '../data/User.dart';
import '../model/DrawerItem.dart';

class DrawerWidget extends StatefulWidget {

  final ValueChanged<DrawerItem> onSelectedItem;
  const DrawerWidget({Key? key, required this.onSelectedItem}) : super(key: key);

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  bool showLoader = true;
  User nUser = User(nUserID: '', nUserCode: '', nUserPassword: '', nUserName: '', nUserType: '', nCustomerCode: '', nLoginStatus: false);
  Timer? timer;
  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(Duration(seconds: 15), (Timer t) => getUser());
  }
  void getUser() async{
      nUser = (await SharedPreferencesConfig.getUser())!;
      setState(() {
        showLoader = false;
      });
  }
  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) =>

      Container(
    child: SingleChildScrollView(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              color: MyConstants.of(context)!.primaryColor,
            ),
            accountName: Padding(
              child: Row(
                children: <Widget>[
                  Text(nUser.nUserID),
                ],
              ),
              padding: EdgeInsets.only(top: 10),
            ),
            accountEmail: showLoader ? CircularProgressIndicator( color: Colors.white) : Text(nUser.nCustomerCode),
            currentAccountPicture: CircleAvatar(
              backgroundColor:
              Theme.of(context).platform == TargetPlatform.iOS
                  ? MyConstants.of(context)!.primaryColor
                  : Colors.white,
              child: Icon(
                Icons.person,
                color: MyConstants.of(context)!.primaryColor,
                size: 50,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(16, 32, 16, 0),
            child: Container(
              height: 62.0.h,
                child: SingleChildScrollView(child: buildDrawerItems(context))),
          ),

          Container(
            height: 35,
              child: Align(
                  alignment: FractionalOffset.bottomCenter,
                  child: Column(
                    children: <Widget>[
                      Divider(),
                       Center(child: Text(MyConstants.of(context)!.versionNumber.toString(),style: TextStyle(color: Colors.black38))),
                    ],
                  ))),
        ],
      ),
    ),
  );

  Widget buildDrawerItems(BuildContext context) => Column(
    children: DrawerItems.all
        .map(
            (item) => ListTile(
              // contentPadding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              leading: Icon(item.icon, color: Colors.black54,),
              title: Text(
                item.title,
                style: TextStyle(color: Colors.black54),
              ),
              onTap: () => widget.onSelectedItem(item),
            ),
      )
        .toList(),
  );


}