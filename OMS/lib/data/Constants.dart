import 'package:flutter/material.dart';

class MyConstants extends InheritedWidget {
  static MyConstants? of(BuildContext context) => context.dependOnInheritedWidgetOfExactType<MyConstants>();

  MyConstants({required Widget child, Key? key}): super(key: key, child: child);

  final String successMessage = 'Some message';
  final String versionNumber = '1.0.0.14';
  final String companyName = '20220723TN1720M13';
  final primaryColor = Color.fromRGBO(101, 13, 13, 1);
  final secondaryColor = Color.fromRGBO(243, 143, 35, 1);

  @override
  bool updateShouldNotify(MyConstants oldWidget) => false;
}