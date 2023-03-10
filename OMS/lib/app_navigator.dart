import 'package:BSProOMS/auth/auth_cubit.dart';
import 'package:BSProOMS/auth/auth_navigator.dart';
import 'package:BSProOMS/loading_view.dart';
import 'package:BSProOMS/session_cubit.dart';
import 'package:BSProOMS/session_state.dart';
import 'package:BSProOMS/session_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppNavigator extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SessionCubit, SessionState>(
      builder: (context, state) {
        return WillPopScope(
          onWillPop: () async{
            // return navKey.currentState.maybePop();
            if (navigatorKey.currentState!.canPop()) {
              navigatorKey.currentState!.maybePop();
              return Future(() => false);
            }
            return (await showDialog(
              context: context,
              builder: (context) => new AlertDialog(
                title: new Text('Are you sure?'),
                content: new Text('Do you want to exit an App'),
                actions: <Widget>[
                  new FlatButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: new Text('No'),
                  ),
                  new FlatButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: new Text('Yes'),
                  ),
                ],
              ),
            )) ??
                false;
            },
          child: Navigator(
            key: navigatorKey,
            onGenerateRoute: (RouteSettings settings){
              switch (settings.name) {
                // case '/':
                //   return MaterialPageRoute(builder: (BuildContext context) => MainRoute(), settings: settings);
                // case '/another':
                //   return MaterialPageRoute(builder: (BuildContext context) => AnotherRoute(), settings: settings);
              }
              return null;
            },
            pages: [
              // Show Loading Screen
              if(state is UnknownSessionState) MaterialPage(child: LoadingView()),

              // Show auth flow
              if(state is Unauthenticated)
              MaterialPage(child:
              BlocProvider(create: (context) =>  AuthCubit(sessionCubit: context.read<SessionCubit>()),
              child: AuthNavigator(),
              )
              ),

              // Show Session flow
              if(state is Authenticated) MaterialPage(child: SessionView())
            ],
            onPopPage: (route, result) {
              if ( !route.didPop(result) ) {
                return false;
              }
              return true;
            },
          ),
        );
      },
    );
  }
}
