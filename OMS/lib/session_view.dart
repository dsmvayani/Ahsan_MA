
import 'dart:async';

import 'package:BSProOMS/data/SharedPreferencesConfig.dart';
import 'package:BSProOMS/data/User.dart';
import 'package:BSProOMS/page/UnAuthorized.dart';
import 'package:BSProOMS/page/dashboard/cubit/dashboard_bloc.dart';
import 'package:BSProOMS/page/dashboard/dashboard.dart';
import 'package:BSProOMS/page/product/product_list.dart';
import 'package:BSProOMS/page/sale-order/sale_order_list.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:BSProOMS/auth/login/login_event.dart';
import 'package:BSProOMS/model/DrawerItem.dart';
import 'package:BSProOMS/page/bsproweb_page.dart';
import 'package:BSProOMS/page/settings/setting_page.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import 'auth/auth_repository.dart';
import 'auth/login/login_bloc.dart';
import 'auth/login/login_state.dart';
import 'data/Constants.dart';
import 'data/DrawerItems.dart';
import 'page/ledger/ledger_page.dart';
import 'session_cubit.dart';
import 'widget/drawer_widget.dart';

class SessionView extends StatefulWidget {
  @override
  _SessionViewState createState() => _SessionViewState();
}

class _SessionViewState extends State<SessionView> {
  late double xOffset;
  late double yOffset;
  late double scaleFactor;
  late bool isDrawerOpen;
  bool isDragging = false;
  DrawerItem item = DrawerItems.home;
  User nUser = User(nUserID: '', nUserCode: '', nUserPassword: '', nUserName: '', nUserType: '', nCustomerCode: '', nLoginStatus: false);
  Timer? timer;
  bool isFirstTime = true;
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey();
  @override
  void initState() {
    super.initState();

    timer = Timer.periodic(Duration(seconds: 2), (Timer t) => getUser());
    // openDrawer();
    closeDrawer();
  }
  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }
  void getUser() async{
    nUser = (await SharedPreferencesConfig.getUser())!;
    bool isChangeable = await SharedPreferencesConfig.getScreenChangeable();
    if(nUser.nLoginStatus && !isChangeable){
      setState(() {
        item = DrawerItems.settings;
        // isFirstTime = false;
      });
      SharedPreferencesConfig.setScreenChangeable(true);
      // getDrawerPage();
    }
  }
  void openDrawer() => setState(() {
        xOffset = 220;
        // yOffset = 150;
        // scaleFactor = 0.6;
        scaleFactor = 1;
        isDrawerOpen = true;
      });
  void closeDrawer() => setState(() {
        xOffset = 0;
        yOffset = 0;
        scaleFactor = 1;
        isDrawerOpen = false;
      });
  Future<bool> _onWillPop() async {

    // This dialog will exit your app on saying yes
    return (await showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('Are you sure?'),
        content: new Text('Do you want to exit an App'),
        actions: [
           TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: new Text('No'),
          ),
           TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: new Text('Yes'),
          ),
        ],
      ),
    )) ??
        false;
  }
  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        // backgroundColor: MyConstants.of(context)!.secondaryColor,
        body: BlocProvider(
          create: (context) =>
              SessionCubit(authRepo: context.read<AuthRepository>()),
          child: Stack(
            children: [
              buildDrawer(),
              buildPage(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildDrawer() => SafeArea(
          child: Container(
        width: xOffset,
        child: DrawerWidget(onSelectedItem: (item) {
          switch (item) {
            case DrawerItems.logout:
              showLogout(context);
              return;
            default:
              setState(() => {this.item = item, this.isFirstTime = false});
              closeDrawer();
          }
        }),
      ));
  Widget buildPage() {
    return WillPopScope(
      onWillPop: () async {
        if (isDrawerOpen) {
          closeDrawer();
          return false;
        } else {
          return false;
        }
      },
      child: GestureDetector(
        onTap: closeDrawer,
        onHorizontalDragStart: (details) => isDragging = true,
        onHorizontalDragUpdate: (details) {
          if (!isDragging) return;
          const delta = 1;
          if (details.delta.dx > delta) {
            openDrawer();
          } else if (details.delta.dx < -delta) {
            closeDrawer();
          }
          isDragging = false;
        },
        child: AnimatedContainer(
            duration: Duration(microseconds: 250),
            transform: Matrix4.translationValues(xOffset, yOffset, 0)
              ..scale(scaleFactor),
            child: AbsorbPointer(
                absorbing: isDrawerOpen,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(isDrawerOpen ? 20 : 0),
                  child: Container(
                      color: isDrawerOpen
                          ? Colors.white12
                          : MyConstants.of(context)!.primaryColor,
                      child: getDrawerPage()),
                ))),
      ),
    );
  }

  Widget getDrawerPage() {
    // if(nUser.nLoginStatus == false && isFirstTime == true){
    //   return SettingPage(openDrawer: openDrawer);
    // }
    // else {
      switch (item) {
        case DrawerItems.home:
          return DashboardList(openDrawer: openDrawer);
        case DrawerItems.ledger:
          return nUser.nCustomerCode.length < 1 ? UnAuthorizedScreen(
              openDrawer: openDrawer) : LedgerPage(openDrawer: openDrawer);
        case DrawerItems.product:
          return ProductList(openDrawer: openDrawer);
        case DrawerItems.settings:
          return nUser.nCustomerCode.length < 1 ? UnAuthorizedScreen(
              openDrawer: openDrawer) : SettingPage(openDrawer: openDrawer);
        case DrawerItems.order:
          return nUser.nCustomerCode.length < 1 ? UnAuthorizedScreen(
              openDrawer: openDrawer) : SaleOrder(openDrawer: openDrawer);
        default:
          return SettingPage(openDrawer: openDrawer);
      }
    // }
  }

  showLogout(BuildContext context) {
    Alert(
        context: context,
        type: AlertType.warning,
        style: AlertStyle(isCloseButton: false, titleStyle: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        title: "Logout",
        content: Text(
          "Thank you for using BS PRO OMS. Are you sure you want to Logout?",
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        buttons: [
          DialogButton(
            child: Text("No", style: TextStyle(color: Colors.white,fontSize: 20, fontWeight: FontWeight.bold)),
            color: Colors.grey[800],
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop();
            },
          ),
          DialogButton(
            child: Text("Yes", style: TextStyle(color: Colors.white,fontSize: 20, fontWeight: FontWeight.bold)),
            color: MyConstants.of(context)!.primaryColor,
            onPressed: () async {
              Navigator.of(context, rootNavigator: true).pop();
              final loginBloc = BlocProvider.of<SessionCubit>(context);
              loginBloc.signOUt();
            },
          ),
        ]).show();
  }
}
class SnackbarManager extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        Alert(
        context: context,
        style: AlertStyle(isCloseButton: false),
        type: AlertType.warning,
        title: "Logout",
        content: Text(
          "Thank you for using BS PRO Lite Mobile. Are you sure you want to Logout?",
          style: TextStyle(fontSize: 14),
        ),
        buttons: [
          DialogButton(
            child: Text("No", style: TextStyle(color: Colors.white)),
            color: Colors.grey[800],
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop();
            },
          ),
          DialogButton(
            child: Text("Yes", style: TextStyle(color: Colors.white)),
            color: MyConstants.of(context)!.primaryColor,
            onPressed: () async {
              Navigator.of(context, rootNavigator: true).pop();
               context.read<LoginBloc>().add(Logout());
              //final loginBloc = BlocProvider.of<LoginBloc>(context);
              //loginBloc.authRepo.logOut();
            },
          ),
        ]).show();
      },
      child: Container(),
    );
  }
}
