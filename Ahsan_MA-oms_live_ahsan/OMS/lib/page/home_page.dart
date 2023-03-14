import 'package:flutter/material.dart';

import '../widget/DrawermenuWidget.dart';

class HomePage extends StatelessWidget{
  final VoidCallback openDrawer;
  const HomePage({Key? key, required this.openDrawer}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: DrawerMenuWidget(onClicked: openDrawer,),
        title: Text('Home Page'),
      ),
    );
  }

}