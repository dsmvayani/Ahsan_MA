import 'package:BSProOMS/auth/form_submission_status.dart';

class LoginState{
  final String userId;
  bool get isValidUserId => userId.length > 3;
  final String password;
  bool get isValidPassword => password.length > 3;
  
  final FormSubmissionStatus formStatus;

  LoginState({
    this.userId = '', 
    this.password = '',
    this.formStatus = const InitialFormStatus(),
  });

  LoginState copyWith({
     String? userId, 
     String? password,
     FormSubmissionStatus? formStatus,
    }) {
      return LoginState(
        userId: userId ?? this.userId, 
        password: password ?? this.password,
        formStatus: formStatus ?? this.formStatus
      );
    }
}