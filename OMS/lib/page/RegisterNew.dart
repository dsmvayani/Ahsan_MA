import 'dart:convert';
import 'dart:math';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../auth/auth_cubit.dart';
import '../auth/auth_repository.dart';
import '../auth/form_submission_status.dart';
import '../auth/register/register_bloc.dart';
import '../auth/register/register_event.dart';
import '../auth/register/register_state.dart';
import '../data/Constants.dart';

// var _primaryColor = Color.fromRGBO(101, 13, 13, 1);
class RegisterNew extends StatefulWidget {
  const RegisterNew({Key? key}) : super(key: key);

  @override
  _RegisterNewState createState() => _RegisterNewState();
}

class _RegisterNewState extends State<RegisterNew> {
  static String otpCode = "";
  final _formKey = GlobalKey<FormState>();
  final _formKeyOTP = GlobalKey<FormState>();
  final registerShopController = TextEditingController();
  final registerMobileController = TextEditingController();
  var controller1 = TextEditingController();
  var controller2 = TextEditingController();
  var controller3 = TextEditingController();
  var controller4 = TextEditingController();
  var controller5 = TextEditingController();
  var controller6 = TextEditingController();
  final registerPasswordController = TextEditingController();
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  String verificationIdRecieved = "";
  bool otpCodeVisible = false;
  Dio dio = Dio();
  var response;
  var smsResponse;
  var BASE_URL = 'https://gentecbspro.com/Dummy_TNM/CoreAPI/api/values/getdata';
  Random random = Random();
  var otpNum1 = 446564;
  var userEnterOtp = '';

  void generateOtpNum() {
    otpNum1 = random.nextInt(999999);
    if (otpNum1 < 100000) {
      otpNum1 = otpNum1 + 100000;
      print('>>>>>>otp num: $otpNum1');
    } else {
      print('>>>>>> $otpNum1 <<<<<');
    }
  }

  @override
  void initState() {
    getDefaultMobileCode();
    textEditingController1 = TextEditingController();
    initSmsListener();
    super.initState();
  }

  getDefaultMobileCode() async {
    try {
      final Response? response = await AuthRepository()
          .getData("GEN_BSProOMSSP", ['@nType', '@nsType'], ['0', '11']);
      if (response != null && response.statusCode == 200) {
        var json = jsonDecode(response.data);
        var jsonMsg = json[0]["MobileNo Type"];
        String nDefaultCode = "+" + jsonMsg.toString();
        registerMobileController.text = nDefaultCode;
      }
    } catch (e) {
      print(e);
    }
  }

  late TextEditingController textEditingController1;

  Future<void> initSmsListener() async {
    String comingSms;
    try {
      print("====>initSmsListener");
      // comingSms = (await AltSmsAutofill().listenForSms)!;
      print("====>initSmsListenerEnd");
    } on PlatformException {
      comingSms = 'Failed to get Sms.';
    }
    if (!mounted) return;
    setState(() {
      //  otpCode = comingSms;
      print("====>Message: ${otpCode}");
      print("${otpCode[2]}");
      textEditingController1.text = otpCode[0] +
          otpCode[1] +
          otpCode[2] +
          otpCode[3] +
          otpCode[4] +
          otpCode[
              5]; //used to set the code in the message to a string and setting it to a textcontroller. message length is 38. so my code is in string index 32-37.
      print("====>Code: ${textEditingController1.text}");
      otpCode = textEditingController1.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegisterBloc(
          authRepo: context.read<AuthRepository>(),
          authCubit: context.read<AuthCubit>()),
      child: Scaffold(
        // appBar: AppBar(
        //   elevation: 0,
        //   // backgroundColor: Colors.transparent,
        //   title: Text('Register'),
        // ),
        body: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: BlocBuilder<RegisterBloc, RegisterState>(
                    builder: (context, state) {
                  return Form(
                    key: _formKey,
                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(50),
                          child: Image.asset("assets/images/header_image.png"),
                        ),
                        !otpCodeVisible
                            ? Column(
                                children: <Widget>[
                                  InputWithIcon(
                                    icon: Icons.shopping_bag_rounded,
                                    hint: "Shop Name",
                                    isObsecureText: false,
                                    inputType: 1,
                                    controller: registerShopController,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  InputWithIcon(
                                    icon: Icons.phone_iphone_rounded,
                                    hint: "Contact No",
                                    isObsecureText: false,
                                    inputType: 2,
                                    controller: registerMobileController,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  // InputWithIcon(
                                  //   icon: Icons.verified_user_rounded,
                                  //   hint: "Verification Code",
                                  //   isObsecureText: false,
                                  //   inputType: 3,
                                  // ),
                                  // SizedBox(
                                  //   height: 10,
                                  // ),
                                  InputWithIcon(
                                    icon: Icons.vpn_key_rounded,
                                    hint: "Password",
                                    isObsecureText: true,
                                    inputType: 3,
                                    controller: registerPasswordController,
                                  ),
                                  SizedBox(
                                    height: 50,
                                  ),
                                  GestureDetector(
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        "Back to Login",
                                        style: TextStyle(
                                            color: MyConstants.of(context)!
                                                .primaryColor,
                                            fontStyle: FontStyle.italic,
                                            decoration:
                                                TextDecoration.underline),
                                      )),
                                  SizedBox(
                                    height: 50,
                                  ),
                                ],
                              )
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 20),
                                      child: Text('Verification code',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline5),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 20),
                                      child: Text(
                                          'We have sent the code verification to',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 20),
                                      child: Text(
                                          // "+923332685176".replaceRange(5, 10, "*****")
                                          state.contactNo.length > 1
                                              ? state.contactNo
                                                  .replaceRange(5, 10, "*****")
                                              : state.contactNo,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText2),
                                    ),
                                    SizedBox(height: 20),
                                    /*PinFieldAutoFill(
                                      controller: textEditingController1,
                                      //decoration: // UnderlineDecoration, BoxLooseDecoration or BoxTightDecoration see https://github.com/TinoGuo/pin_input_text_field for more info,
                                      //currentCode: // prefill with a code
                                      //onCodeSubmitted: //code submitted callback
                                      //onCodeChanged: //code changed callback
                                      //codeLength: //code length, default 6
                                    ),*/
                                    Form(
                                        key: _formKeyOTP,
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              SizedBox(
                                                  height: 54,
                                                  width: 50,
                                                  child: TextFormField(
                                                    controller: controller1,
                                                    onChanged: (value) {
                                                      context
                                                          .read<RegisterBloc>()
                                                          .add(
                                                              VerificationCode1Change(
                                                                  code: value));
                                                      if (value.length == 1) {
                                                        FocusScope.of(context)
                                                            .nextFocus();
                                                      }
                                                    },
                                                    cursorColor:
                                                        MyConstants.of(context)!
                                                            .primaryColor,
                                                    decoration: InputDecoration(
                                                      focusedBorder: OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          15.0)),
                                                          borderSide: BorderSide(
                                                              color: MyConstants
                                                                      .of(context)!
                                                                  .primaryColor)),
                                                      contentPadding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 20),
                                                      border: OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius.circular(
                                                                      15.0))),
                                                    ),
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headline6,
                                                    keyboardType:
                                                        TextInputType.number,
                                                    textAlign: TextAlign.center,
                                                    inputFormatters: [
                                                      LengthLimitingTextInputFormatter(
                                                          1),
                                                      FilteringTextInputFormatter
                                                          .digitsOnly
                                                    ],
                                                  )),
                                              SizedBox(
                                                  height: 54,
                                                  width: 50,
                                                  child: TextFormField(
                                                    controller: controller2,
                                                    onChanged: (value) {
                                                      context
                                                          .read<RegisterBloc>()
                                                          .add(
                                                              VerificationCode2Change(
                                                                  code: value));
                                                      if (value.length == 1) {
                                                        FocusScope.of(context)
                                                            .nextFocus();
                                                      }
                                                    },
                                                    cursorColor:
                                                        MyConstants.of(context)!
                                                            .primaryColor,
                                                    decoration: InputDecoration(
                                                      focusedBorder: OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          15.0)),
                                                          borderSide: BorderSide(
                                                              color: MyConstants
                                                                      .of(context)!
                                                                  .primaryColor)),
                                                      contentPadding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 20),
                                                      border: OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius.circular(
                                                                      15.0))),
                                                    ),
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headline6,
                                                    keyboardType:
                                                        TextInputType.number,
                                                    textAlign: TextAlign.center,
                                                    inputFormatters: [
                                                      LengthLimitingTextInputFormatter(
                                                          1),
                                                      FilteringTextInputFormatter
                                                          .digitsOnly
                                                    ],
                                                  )),
                                              SizedBox(
                                                  height: 54,
                                                  width: 50,
                                                  child: TextFormField(
                                                    controller: controller3,
                                                    onChanged: (value) {
                                                      context
                                                          .read<RegisterBloc>()
                                                          .add(
                                                              VerificationCode3Change(
                                                                  code: value));
                                                      if (value.length == 1) {
                                                        FocusScope.of(context)
                                                            .nextFocus();
                                                      }
                                                    },
                                                    cursorColor:
                                                        MyConstants.of(context)!
                                                            .primaryColor,
                                                    decoration: InputDecoration(
                                                      focusedBorder: OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          15.0)),
                                                          borderSide: BorderSide(
                                                              color: MyConstants
                                                                      .of(context)!
                                                                  .primaryColor)),
                                                      contentPadding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 20),
                                                      border: OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius.circular(
                                                                      15.0))),
                                                    ),
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headline6,
                                                    keyboardType:
                                                        TextInputType.number,
                                                    textAlign: TextAlign.center,
                                                    inputFormatters: [
                                                      LengthLimitingTextInputFormatter(
                                                          1),
                                                      FilteringTextInputFormatter
                                                          .digitsOnly
                                                    ],
                                                  )),
                                              SizedBox(
                                                  height: 54,
                                                  width: 50,
                                                  child: TextFormField(
                                                    controller: controller4,
                                                    onChanged: (value) {
                                                      context
                                                          .read<RegisterBloc>()
                                                          .add(
                                                              VerificationCode4Change(
                                                                  code: value));
                                                      if (value.length == 1) {
                                                        FocusScope.of(context)
                                                            .nextFocus();
                                                      }
                                                    },
                                                    cursorColor:
                                                        MyConstants.of(context)!
                                                            .primaryColor,
                                                    decoration: InputDecoration(
                                                      focusedBorder: OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          15.0)),
                                                          borderSide: BorderSide(
                                                              color: MyConstants
                                                                      .of(context)!
                                                                  .primaryColor)),
                                                      contentPadding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 20),
                                                      border: OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius.circular(
                                                                      15.0))),
                                                    ),
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headline6,
                                                    keyboardType:
                                                        TextInputType.number,
                                                    textAlign: TextAlign.center,
                                                    inputFormatters: [
                                                      LengthLimitingTextInputFormatter(
                                                          1),
                                                      FilteringTextInputFormatter
                                                          .digitsOnly
                                                    ],
                                                  )),
                                              SizedBox(
                                                  height: 54,
                                                  width: 50,
                                                  child: TextFormField(
                                                    controller: controller5,
                                                    onChanged: (value) {
                                                      context
                                                          .read<RegisterBloc>()
                                                          .add(
                                                              VerificationCode5Change(
                                                                  code: value));
                                                      if (value.length == 1) {
                                                        FocusScope.of(context)
                                                            .nextFocus();
                                                      }
                                                    },
                                                    cursorColor:
                                                        MyConstants.of(context)!
                                                            .primaryColor,
                                                    decoration: InputDecoration(
                                                      focusedBorder: OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          15.0)),
                                                          borderSide: BorderSide(
                                                              color: MyConstants
                                                                      .of(context)!
                                                                  .primaryColor)),
                                                      contentPadding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 20),
                                                      border: OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius.circular(
                                                                      15.0))),
                                                    ),
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headline6,
                                                    keyboardType:
                                                        TextInputType.number,
                                                    textAlign: TextAlign.center,
                                                    inputFormatters: [
                                                      LengthLimitingTextInputFormatter(
                                                          1),
                                                      FilteringTextInputFormatter
                                                          .digitsOnly
                                                    ],
                                                  )),
                                              SizedBox(
                                                  height: 54,
                                                  width: 50,
                                                  child: TextFormField(
                                                    controller: controller6,
                                                    onChanged: (value) {
                                                      context
                                                          .read<RegisterBloc>()
                                                          .add(
                                                              VerificationCode6Change(
                                                                  code: value));
                                                      if (value.length == 1) {
                                                        FocusScope.of(context)
                                                            .nextFocus();
                                                      }
                                                    },
                                                    cursorColor:
                                                        MyConstants.of(context)!
                                                            .primaryColor,
                                                    decoration: InputDecoration(
                                                      focusedBorder: OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          15.0)),
                                                          borderSide: BorderSide(
                                                              color: MyConstants
                                                                      .of(context)!
                                                                  .primaryColor)),
                                                      contentPadding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 20),
                                                      border: OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius.circular(
                                                                      15.0))),
                                                    ),
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headline6,
                                                    keyboardType:
                                                        TextInputType.number,
                                                    textAlign: TextAlign.center,
                                                    inputFormatters: [
                                                      LengthLimitingTextInputFormatter(
                                                          1),
                                                      FilteringTextInputFormatter
                                                          .digitsOnly
                                                    ],
                                                  )),
                                            ])),
                                    SizedBox(height: 20),
                                  ]),
                        _RegisterButton()
                      ],
                    ),
                  );
                }))),
      ),
    );
  }

  Widget _RegisterButton() {
    return BlocBuilder<RegisterBloc, RegisterState>(
      builder: (context, state) {
        return state.formStatus is FormSubmitting
            ? CircularProgressIndicator(
                color: MyConstants.of(context)!.primaryColor,
              )
            : ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: MyConstants.of(context)!.primaryColor,
                    minimumSize: const Size.fromHeight(50),
                    padding: EdgeInsetsDirectional.all(15),
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(10))),
                onPressed: () async {
                  if (otpCodeVisible && controller1.text.length > 0) {
                    userEnterOtp = controller1.text +
                        controller2.text +
                        controller3.text +
                        controller4.text +
                        controller5.text +
                        controller6.text;
                    if('${otpNum1}' == '${userEnterOtp}'){
                      /*setState(() {
                        this.otpCodeVisible = false;
                      });*/
                      context.read<RegisterBloc>().add(RegisterSubmitted());
                    }else{
                      //show snackbar
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Please enter valid OTP'),
                        duration: Duration(seconds: 2),
                      ));
                    }
                    // var smsCode = state.verifyCode1.toString() +
                    //     state.verifyCode2.toString() +
                    //     state.verifyCode3.toString() +
                    //     state.verifyCode4.toString() +
                    //     state.verifyCode5.toString() +
                    //     state.verifyCode6.toString();
                    /*try {
                      AuthCredential credential = PhoneAuthProvider.credential(
                          verificationId: verificationIdRecieved,
                          smsCode: otpCode);
                      FirebaseAuth.instance
                          .signInWithCredential(credential)
                          .then((value) {
                        setState(() {
                          this.otpCodeVisible = false;
                        });
                        context.read<RegisterBloc>().add(RegisterSubmitted());
                      }).catchError((onError) {
                        Fluttertoast.showToast(
                            msg: "Invalid OTP code",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0);
                      });
                    } catch (e) {
                      print(e);
                    }*/
                  } else if (!otpCodeVisible &&
                      _formKey.currentState!.validate()) {
                    //sending otp code
                    generateOtpNum();
                    try {
                      response = await dio.post(
                        BASE_URL,
                        data: {
                          "SPNAME": "GEN_BSProOMSSP",
                          "ReportQueryParameters": [
                            "@nType",
                            "@nsType",
                            "@ContactNo",
                            "@OtpCode"
                          ],
                          "ReportQueryValue": [
                            "0",
                            "15",
                            "${registerMobileController.text.trim()}",
                            "$otpNum1"
                          ]
                        },
                      );
                      if (response.statusCode == 200) {
                        var result = jsonDecode(response.data);
                        var smsApiData = result[0]['SMSApi'];
                        print('---->SMSApi ${smsApiData}');
                        Future.delayed(Duration(seconds: 1), () async {
                          debugPrint('-------run------');
                          try {
                            setState(() {
                              this.otpCodeVisible = true;
                            });
                            smsResponse = await dio.post(smsApiData);
                            //var smsResult = jsonDecode(smsResponse.data);
                            print('----> otp success: ${smsResponse}');
                          } on DioError catch (e) {
                            setState(() {
                              this.otpCodeVisible = false;
                            });
                            print('----> error getting the otp url $e');
                          }
                        });
                      }
                    } on DioError catch (e) {
                      setState(() {
                        this.otpCodeVisible = false;
                      });
                      print('----> Error $e');
                    }
                    //verifyPhone(state.contactNo);
                  }
                },
                child: Text(
                  otpCodeVisible ? 'Register' : 'Verify',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold),
                ),
              );
      },
    );
  }

  void verifyPhone(String phoneNo) {
    firebaseAuth.verifyPhoneNumber(
        phoneNumber: phoneNo,
        verificationCompleted: (PhoneAuthCredential credential) async {},
        verificationFailed: (FirebaseAuthException exception) {
          setState(() {
            this.otpCodeVisible = false;
          });
          print(exception.message);
        },
        codeSent: (String verificationId, int? resentToken) {
          setState(() {
            this.otpCodeVisible = true;
          });
          verificationIdRecieved = verificationId;
        },
        codeAutoRetrievalTimeout: (String verificationId) {});
  }

  @override
  void dispose() {
    textEditingController1.dispose();
    // AltSmsAutofill().unregisterListener();
    super.dispose();
  }
}

class InputWithIcon extends StatefulWidget {
  final IconData icon;
  final String hint;
  final bool isObsecureText;
  final int inputType;
  TextEditingController controller;

  InputWithIcon(
      {required this.icon,
      required this.hint,
      required this.isObsecureText,
      required this.inputType,
      required this.controller});

  @override
  _InputWithIconState createState() => _InputWithIconState();
}

class _InputWithIconState extends State<InputWithIcon> {
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
            child: BlocBuilder<RegisterBloc, RegisterState>(
              builder: (context, state) {
                return TextFormField(
                  obscureText: widget.isObsecureText,
                  keyboardType: widget.inputType == 2
                      ? TextInputType.phone
                      : TextInputType.text,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(vertical: 20),
                      border: InputBorder.none,
                      hintText: widget.hint),
                  // validator: (value) => null,
                  validator: (value) {
                    if (widget.inputType == 1 && !state.isValidShopName)
                      return 'Shop name is too short';
                    if (widget.inputType == 2 && !state.isValidContactNo)
                      return '+92XXXXXXXXXX Invalid Format';
                    if (widget.inputType == 3 && !state.isValidPassword)
                      return 'Password is too short';
                    return null;
                  },
                  onChanged: (value) => {
                    if (widget.inputType == 1)
                      context
                          .read<RegisterBloc>()
                          .add(RegisterShopNameChanged(shopName: value))
                    else if (widget.inputType == 2)
                      context
                          .read<RegisterBloc>()
                          .add(RegisterContactNoChanged(contactNo: value))
                    else if (widget.inputType == 3)
                      context
                          .read<RegisterBloc>()
                          .add(RegisterPasswordChanged(password: value))
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
}
