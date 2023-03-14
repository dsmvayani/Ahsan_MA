import 'package:BSProOMS/auth/auth_cubit.dart';
import 'package:BSProOMS/page/ledger/cubit/ledger_state.dart';
import 'package:BSProOMS/page/ledger/ledger_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../main.dart';
class AuthNavigator extends StatelessWidget {
  const AuthNavigator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(builder: (context, state){
      return Navigator(
        pages: [
          if(state == AuthState.login) MaterialPage(child: LoginPage()),
        ],
        // onPopPage: (route, result) {
        //   if ( !route.didPop(result) ) {
        //     return false;
        //   }
        //   return true;
        // },
        // onPopPage: (route, result) => route.didPop(result),
      );
    });
  }
}