import 'package:flutter/cupertino.dart';

abstract class SessionState {}

class UnknownSessionState extends SessionState{}

class Unauthenticated extends SessionState{}

class Authenticated extends SessionState{
  final dynamic token;
  
  Authenticated({@required this.token});

}