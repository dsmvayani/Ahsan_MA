import 'package:flutter/material.dart';

import '../data/Constants.dart';
import '../widget/DrawermenuWidget.dart';

class UnAuthorizedScreen extends StatefulWidget {
  final VoidCallback openDrawer;
  UnAuthorizedScreen({Key? key, required this.openDrawer}) : super(key: key);

  @override
  _UnAuthorizedScreenState createState() => _UnAuthorizedScreenState();
}

class _UnAuthorizedScreenState extends State<UnAuthorizedScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // resizeToAvoidBottomInset: true,
      appBar: AppBar(
          elevation: 0,
          backgroundColor: MyConstants.of(context)!.primaryColor,
          leading: DrawerMenuWidget(
            onClicked: widget.openDrawer,
          ),
          title: Text('Un Authorized')),
      body: Center(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
            Padding(
              padding:
              const EdgeInsets.only(left: 20, top: 100),
              child: Text('We\'re reviewing your account',
                  style: Theme.of(context)
                      .textTheme.apply(bodyColor:  MyConstants.of(context)!.primaryColor)
                      .headline5),
            ),
            Padding(
              padding:
              const EdgeInsets.only(left: 20, right: 20),
              child: Text(
                  'Your account has been paused while a member of our team will create your financial account. This is usually take less than 48 hours. We\'ll be in touch soon!',
                  textAlign: TextAlign.justify,
                  style: TextStyle(color: Colors.black45, wordSpacing: 3.0, height: 1.3),),
            ),
          ],))

    );
  }
}
