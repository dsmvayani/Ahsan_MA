import 'package:BSProOMS/auth/auth_credentials.dart';
import 'package:BSProOMS/auth/auth_repository.dart';
import 'package:BSProOMS/session_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SessionCubit extends Cubit<SessionState> {
  final AuthRepository authRepo;

  SessionCubit({required this.authRepo}) : super(UnknownSessionState()){
    attemptAutoLogin();
  }
  void attemptAutoLogin() async {
    try{
      final token = await authRepo.attemptAutoLogin();
      // final user = datarepo.getUser(userId);
      // final token = token;
      emit(Authenticated(token: token));
    }
    on Exception{
    emit(Unauthenticated());
    }
  }

  void showAuth() => emit(Unauthenticated());
  void showSession(AuthCredentials credentials) {
    //final user = dataRepo.getUser(credentials.userid);
    final token = credentials.token;
    emit(Authenticated(token: token));
  }

  void signOUt() {
    authRepo.logOut();
    emit(Unauthenticated());
  }
}
