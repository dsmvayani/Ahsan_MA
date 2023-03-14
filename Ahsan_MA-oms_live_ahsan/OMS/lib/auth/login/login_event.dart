abstract class LoginEvent {}

class LoginUserIdChanged extends LoginEvent{
  final String userId;
  LoginUserIdChanged({required this.userId});
}

class LoginPasswordChanged extends LoginEvent{
  final String password;
  LoginPasswordChanged({required this.password});
}

class SetLoginUser extends LoginEvent{}
class LoginSubmitted extends LoginEvent{}
class Logout extends LoginEvent{}