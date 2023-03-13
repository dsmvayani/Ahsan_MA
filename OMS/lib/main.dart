import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:BSProOMS/data/Constants.dart';
import 'package:BSProOMS/page/RegisterNew.dart';
import 'package:BSProOMS/page/dashboard/cubit/dashboard_bloc.dart';
import 'package:BSProOMS/page/ledger/cubit/ledger_bloc.dart';
import 'package:BSProOMS/page/product/cubit/product_bloc.dart';
import 'package:BSProOMS/page/sale-order/cubit/sale_order_bloc.dart';
import 'package:BSProOMS/page/sale-order/sale_order_list.dart';
import 'package:BSProOMS/page/settings/cubit/settings_bloc.dart';
import 'package:BSProOMS/repository/MyHttpOverrides.dart';
import 'package:BSProOMS/repository/dashboard_repositry.dart';
import 'package:BSProOMS/repository/ledger_repository.dart';
import 'package:BSProOMS/repository/product_repository.dart';
import 'package:BSProOMS/repository/setting_repository.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:BSProOMS/app_navigator.dart';
import 'package:BSProOMS/auth/auth_cubit.dart';
import 'package:BSProOMS/auth/form_submission_status.dart';
import 'package:BSProOMS/auth/login/login_bloc.dart';
import 'package:BSProOMS/auth/login/login_event.dart';
import 'package:BSProOMS/auth/login/login_state.dart';
import 'package:BSProOMS/model/City.dart';
import 'package:BSProOMS/model/Customer.dart';
import 'package:BSProOMS/model/Product.dart';
import 'package:BSProOMS/model/SaleOrderTab.dart';
import 'package:BSProOMS/repository/sale_order_repositry.dart';
import 'package:BSProOMS/session_cubit.dart';
import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'auth/auth_repository.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'data/Clients.dart';
import 'data/SharedPreferencesConfig.dart';
import 'package:path_provider/path_provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'data/User.dart';
import 'model/SalesManTab.dart';

// var _primaryColor = Color.fromRGBO(101, 13, 13, 1);
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
  await Firebase.initializeApp();
  // Directory document =  await getApplicationDocumentsDirectory();
  // Hive.init(document.path);
  // Hive.registerAdapter(CustomerAdapter());
  // Hive.registerAdapter(CityAdapter());
  // Hive.registerAdapter(SalesManTabAdapter());
  // Hive.registerAdapter(ProductAdapter());
  // Hive.registerAdapter(SaleOrderTabAdapter());
  // await Hive.openBox<Customer>("Customer");
  // await Hive.openBox<City>("City");
  // await Hive.openBox<SalesManTab>("SalesManTab");
  // await Hive.openBox<Product>("Product");
  // await Hive.openBox<SaleOrderTab>("SaleOrderTab");
  // configLoading();

  runApp(MyConstants(child: MyApp()));
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 3000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 75.0
    ..radius = 10.0
    ..progressColor = Color.fromRGBO(255, 160, 53, 1)
    ..backgroundColor = Color.fromRGBO(72, 187, 244, 1)
    ..indicatorColor = Color.fromRGBO(255, 160, 53, 1)
    ..textColor = Colors.white
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = true
    ..dismissOnTap = false;
  //..customAnimation = CustomAnimation();
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: "Montserrat",
        primaryColor: Color.fromRGBO(101, 13, 13, 1),
        secondaryHeaderColor: Color.fromRGBO(243, 143, 35, 1),
        colorScheme: ThemeData().colorScheme.copyWith(primary: Color.fromRGBO(101, 13, 13, 1)),
      ),
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
      builder: EasyLoading.init(),
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Container(
        decoration: BoxDecoration(border: Border.all(color: Colors.red)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset('assets/images/splash_bsprooms.json'),
            RichText(
              textAlign: TextAlign.center,
                text: TextSpan(children: [
              TextSpan(
                  text: "Welcome to ",
                  style: TextStyle(color: Colors.black)),
              TextSpan(
                  text: "Business Solutions PRO ",
                  style:
                      TextStyle(color: Theme.of(context).secondaryHeaderColor)),
              TextSpan(
                  text: "OMS",
                  style: TextStyle(color: Theme.of(context).primaryColor)),
            ], style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold))),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 40.0),
              child: RichText(
                  text: TextSpan(
                      text:
                          "BS PRO OMS is an advanced Order Booking system which can be accessed through hand-hel-control devices, such as mobile phones and tablets.",
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[900],
                          fontWeight: FontWeight.w600)),
                  textAlign: TextAlign.justify),
            )
          ],
        ),
      ),
      nextScreen: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: RepositoryProvider(
          create: (context) => AuthRepository(),
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            body: Container(
              child: MultiBlocProvider(
                providers: [
                  BlocProvider(
                    create: (context) =>
                        SessionCubit(authRepo: context.read<AuthRepository>()),
                  ),
                  BlocProvider(
                    create: (context) => DashboardBloc(
                        nDashboardRepository: DashboardRepository()),
                  ),
                  BlocProvider(
                    create: (context) => LedgerBloc(
                        nLedgerRepository: LedgerRepository()),
                  ),
                  BlocProvider(
                    create: (context) => SaleOrderBloc(
                        saleOrderRepository: SaleOrderRepository()),
                  ),
                  BlocProvider(
                    create: (context) => ProductBloc(
                        productRepository: ProductRepository()),
                  ),
                  BlocProvider(
                    create: (context) => SettingBloc(
                        nSettingRepository: SettingRepository()),
                  ),

                ],
                child: AppNavigator(),
              ),
            ),
          ),
        ),
      ),
      splashIconSize: double.maxFinite,
      backgroundColor: Color.fromRGBO(243, 243, 243, 1),
      duration: 3000,
      splashTransition: SplashTransition.fadeTransition,
      pageTransitionType: PageTransitionType.leftToRightWithFade,
      animationDuration: const Duration(seconds: 1),
    );
  }
}

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKeyCompany = GlobalKey<FormState>();
  final _formKey = GlobalKey<FormState>();
  final _alertCompanyController = TextEditingController();
  final userIdController = TextEditingController();
  final userPassController = TextEditingController();
  bool isChecked = false;
  @override
  void initState() {
    super.initState();
    // checkInitialScreen();
    setCompany();
  }
  Future<bool> _onWillPop() async {

    // This dialog will exit your app on saying yes
    return (await showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('Are you sure? dashboard'),
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

    return BlocProvider(
      create: (context) => LoginBloc(
          authRepo: context.read<AuthRepository>(),
          authCubit: context.read<AuthCubit>()),
      child: Scaffold(
        // appBar: AppBar(
        //   elevation: 0,
        //   // backgroundColor: Colors.transparent,
        //   title: Text('Login'),
        // ),
        body: SingleChildScrollView(
            child: BlocListener<LoginBloc, LoginState>(
          listener: (context, state) {
           final formStatus = state.formStatus;
           if (formStatus is SubmissionFailed) {
             Fluttertoast.showToast(
                 msg: formStatus.exception.toString(),
                 toastLength: Toast.LENGTH_SHORT,
                 gravity: ToastGravity.BOTTOM,
                 timeInSecForIosWeb: 1,
                 backgroundColor: Colors.red,
                 textColor: Colors.white,
                 fontSize: 16.0
             );
            // _showSnackBar(context, formStatus.exception.toString());
           }
          },
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Form(
                key: _formKey,
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(50),
                          child: Image.asset("assets/images/header_image.png"),
                        ),
                        InputWithIcon(
                          icon: Icons.phone_iphone_rounded,
                          hint: "Contact No",
                          isObsecureText: false,
                          controller: userIdController,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        InputWithIcon(
                            icon: Icons.vpn_key,
                            hint: "Password",
                            isObsecureText: true,
                          controller: userPassController,
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                            width: 200,
                            child: CheckboxListTile(
                              title: Text("Remember me"),
                              selectedTileColor: MyConstants.of(context)!.primaryColor,
                              activeColor: MyConstants.of(context)!.primaryColor,
                              value: isChecked,
                              onChanged: (newValue) {
                                setState(() {
                                  isChecked = newValue!;
                                });
                              },
                              controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 50,
                        ),
                        GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (_) => RegisterNew()));
                            },
                            child: Text(
                              "Register New",
                              style: TextStyle(
                                  color: MyConstants.of(context)!.primaryColor,
                                  fontStyle: FontStyle.italic,
                                  decoration: TextDecoration.underline),
                            )),
                        SizedBox(
                          height: 50,
                        ),
                      ],
                    ),
                    _loginButton(),
                    Divider(),
                    Center(child: Text(MyConstants.of(context)!.versionNumber.toString(),style: TextStyle(color: Colors.black38))),
                    SizedBox(
                          height: 30,
                        ),
                        Image.network(
                          'https://gentecbspro.com/assets/ClientLogos/'+MyConstants.of(context)!.companyName+'.png',
                            fit: BoxFit.fill, height: 120.0, width: double.infinity),
                    SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              )),
        )),
      ),
    );
  }

  Widget _loginButton() {
    // FocusManager.instance.primaryFocus?.unfocus();
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        return state.formStatus is FormSubmitting
            ? CircularProgressIndicator(color: MyConstants.of(context)!.primaryColor,)
            : ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: MyConstants.of(context)!.primaryColor,
                    minimumSize: const Size.fromHeight(50),
                    padding: EdgeInsetsDirectional.all(15),
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(10))),
                onPressed: () {
                  FocusScope.of(context).unfocus();
                  print(_formKey.currentState!.validate());
                  if (_formKey.currentState!.validate()) {
                    SharedPreferencesConfig.setRememberMe(isChecked);
                    context.read<LoginBloc>().add(LoginSubmitted());
                  }
                },
                child: Text(
                  'LOGIN',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold),
                ),
              );
      },
    );
  }

  checkCompany(String companyName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (companyName.length > 0) {
      String? clientKey = await ClientList.getClient(companyName);
      if (clientKey != null) {
        prefs.setBool('first_time', true);
        SharedPreferencesConfig.setApiKey(clientKey);
        ClientList.setAPIUrl(clientKey);
        Alert(
            context: context,
            type: AlertType.success,
            style: AlertStyle(isCloseButton: false, titleStyle: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            title: "Client Found",
            content: Text(
              "Client exist with key " + clientKey,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            buttons: [
              DialogButton(
                color: MyConstants.of(context)!.primaryColor,
                child: Text("OK", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),),
                onPressed: () async {
                  Navigator.of(context, rootNavigator: true).pop();
                },
              ),
            ]).show();
      } else {
        Alert(
            context: context,
            type: AlertType.warning,
            style: AlertStyle(isCloseButton: false, titleStyle: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            title: "Un Authorized",
            content: Text(
              "Your Company is not in the list. please contact to the administrator.",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            buttons: [
              DialogButton(
                color: MyConstants.of(context)!.primaryColor,
                child: Text("OK", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                onPressed: () async {
                  Navigator.of(context, rootNavigator: true).pop();
                  var api = await SharedPreferencesConfig.getAPIUrl();
                  if (api.isEmpty) {
                    checkInitialScreen();
                  }
                },
              ),
            ]).show();
      }
    }
  }

  checkInitialScreen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? firstTime = prefs.getBool('first_time');
    if (firstTime == null) {
      // Not first time
      Alert(
          context: context,
          style: AlertStyle(
            isCloseButton: false, titleStyle: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)
          ),
          title: "Company Code",
          content: Form(
            key: _formKeyCompany,
            child: Column(
              children: <Widget>[
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Company Code Required';
                    }
                    return null;
                  },
                  cursorColor: MyConstants.of(context)!.primaryColor,
                  decoration: InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: MyConstants.of(context)!.primaryColor),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: MyConstants.of(context)!.secondaryColor),
                      ),
                      icon: Icon(Icons.account_box,
                          color: MyConstants.of(context)!.primaryColor),
                      iconColor: MyConstants.of(context)!.primaryColor,
                      labelText: 'KEY',
                      labelStyle: TextStyle(
                          color: MyConstants.of(context)!.primaryColor, fontSize: 22, fontWeight: FontWeight.bold)),
                  controller: _alertCompanyController,
                ),
              ],
            ),
          ),
          buttons: [
            DialogButton(
              color: MyConstants.of(context)!.primaryColor,
              onPressed: () {
                final FormState? form = _formKeyCompany.currentState;
                if (form != null && form.validate()) {
                  Navigator.of(context, rootNavigator: true).pop();
                  checkCompany(_alertCompanyController.text);
                }
              },
              child: Text(
                "OK",
                style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
              ),
            )
          ]).show();
    }
  }

  void setCompany() async{
    bool nisChecked = await SharedPreferencesConfig.getRememberMe();
    setState(() {
      isChecked = nisChecked;
    });
    String companyName = MyConstants.of(context)!.companyName;
    String clientKey = await ClientList.getClient(companyName);
    SharedPreferencesConfig.setApiKey(clientKey);
    ClientList.setAPIUrl(clientKey);

  }
}


class InputWithIcon extends StatefulWidget {
  final IconData icon;
  final String hint;
  final bool isObsecureText;
  TextEditingController controller;
  InputWithIcon(
      {required this.icon, required this.hint, required this.isObsecureText, required this.controller});

  @override
  _InputWithIconState createState() => _InputWithIconState();
}

class _InputWithIconState extends State<InputWithIcon> {
  bool passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(
              color: MyConstants.of(context)!.primaryColor, width: 2),
          borderRadius: BorderRadius.circular(10)),
      child: Row(
        children: <Widget>[
          Container(
              width: 60,
              child: Icon(
                widget.icon,
                size: 30,
                color: MyConstants.of(context)!.primaryColor,
              )),
          Expanded(
            child: BlocBuilder<LoginBloc, LoginState>(
              builder: (context, state) {
                return TextFormField(
                  obscureText: widget.isObsecureText ? passwordVisible : widget.isObsecureText,
                  keyboardType: widget.isObsecureText
                      ? TextInputType.text
                      : TextInputType.phone,
                  decoration: InputDecoration(
                      suffixIcon:
                      widget.isObsecureText ?
                      IconTheme(
                          data: IconThemeData(
                              color: MyConstants.of(context)!.primaryColor),
                          child: IconButton(
                              icon: Icon(!passwordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off),
                              onPressed: () => {
                                setState(() {
                                  passwordVisible =
                                  !passwordVisible;
                                })
                              })) : Container(width: 0),
                      contentPadding: EdgeInsets.symmetric(vertical: 20),
                      border: InputBorder.none,
                      hintText: widget.hint),
                  // validator: (value) => null,
                  validator: (value) {
                    return widget.isObsecureText
                        ? state.isValidPassword
                            ? null
                            : 'Password is too short'
                        : state.isValidUserId
                            ? null
                            : 'Contact No is too short';
                  },
                  onChanged: (value) => {
                    if (!widget.isObsecureText)
                      {
                        context
                            .read<LoginBloc>()
                            .add(LoginUserIdChanged(userId: value))
                      }
                    else if (widget.isObsecureText)
                      {
                        context
                            .read<LoginBloc>()
                            .add(LoginPasswordChanged(password: value))
                      }
                  },
                  controller: widget.controller,
                );
              },
            ),
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    setUser();
    super.initState();
  }
  getDefaultMobileCode() async{
    try{
      final Response? response = await AuthRepository().getData("GEN_BSProOMSSP", ['@nType', '@nsType'], ['0', '11']);
      if(response != null && response.statusCode == 200){
        var json = jsonDecode(response.data);
        var jsonMsg = json[0]["MobileNo Type"];
        String nDefaultCode = "+" + jsonMsg.toString();
        widget.controller.text = nDefaultCode;
      }
    }
    catch(e){
      print(e);
    }
  }
  void setUser() async{
    User? user = await SharedPreferencesConfig.getUser();
    bool remember = await SharedPreferencesConfig.getRememberMe();
    if(user != null && remember){
      if(widget.isObsecureText){
        widget.controller.text = user.nUserPassword;
      }
      else{
        widget.controller.text = user.nUserID;
      }
    }
    else if(!remember && !widget.isObsecureText){
      getDefaultMobileCode();
    }
  }
}
