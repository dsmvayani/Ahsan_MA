
import 'package:BSProOMS/auth/auth_credentials.dart';
import 'package:BSProOMS/session_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum AuthState {login}
class AuthCubit extends Cubit<AuthState>{
  final SessionCubit sessionCubit;
  AuthCubit({required this.sessionCubit}) : super(AuthState.login);

  void showLogin() => emit(AuthState.login);

  void launchSession(AuthCredentials credentials) => sessionCubit.showSession(credentials);

  void logout() => sessionCubit.signOUt();

}