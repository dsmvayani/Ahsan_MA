import 'package:BSProOMS/auth/auth_credentials.dart';
import 'package:BSProOMS/auth/auth_cubit.dart';
import 'package:BSProOMS/auth/auth_repository.dart';
import 'package:BSProOMS/auth/form_submission_status.dart';
import 'package:BSProOMS/auth/login/login_event.dart';
import 'package:BSProOMS/auth/login/login_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:BSProOMS/data/SharedPreferencesConfig.dart';

import '../../data/User.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository authRepo;
  final AuthCubit authCubit;

  LoginBloc({required this.authCubit, required this.authRepo})
      : super(LoginState()) {
    getSetUser();
    on<LoginEvent>(_onEvent);
  }
  void getSetUser() async {
    try{
      User? user = await SharedPreferencesConfig.getUser();
      bool remember = await SharedPreferencesConfig.getRememberMe();
      if(user != null && remember){
        emit(state.copyWith(userId: user.nUserID, password: user.nUserPassword));
      }
    }
    on Exception{
      // emit(Unauthenticated());
    }
  }
  Future<void> _onEvent(LoginEvent event, Emitter<LoginState> emit) async {
    emit(state.copyWith(formStatus: InitialFormStatus()));
    if (event is LoginUserIdChanged) {
      emit(state.copyWith(userId: event.userId));
    }
    // password update
    else if (event is LoginPasswordChanged) {
      emit(state.copyWith(password: event.password));
    }
    //form submitted
    else if (event is LoginSubmitted) {
      emit(state.copyWith(formStatus: FormSubmitting()));

      try {
        final isLogin = await authRepo.login(state.userId, state.password);
        if (isLogin) {
          final token = await SharedPreferencesConfig.getToken();
          final user = await SharedPreferencesConfig.getUser();
          // User user = User(nUserID: state.userId, nUserCode: '', nUserPassword: state.password, nUserName: '', nCustomerCode: '', nUserType: '', nLoginStatus: false);
          // SharedPreferencesConfig.setUser(user.toJson());
          emit(state.copyWith(formStatus: SubmissionSuccess()));
          authCubit.launchSession(
              AuthCredentials(userId: state.userId, token: token));
        } else {
          emit(state.copyWith(
              formStatus: SubmissionFailed(new Exception("Login Failed"))));
        }
        // emit(state.copyWith(formStatus: SubmissionSuccess()));
        // // authCubit.launchSession(AuthCredentials(userId: state.userId));
        // authCubit.launchSession(AuthCredentials(userId: userId));
      } catch (e) {
        emit(state.copyWith(formStatus: SubmissionFailed(new Exception(e))));
        // emit(state.copyWith(formStatus: SubmissionFailed(e.toString())));
      }
    } else if (event is Logout) {
      authCubit.logout();
    }
  }
}
