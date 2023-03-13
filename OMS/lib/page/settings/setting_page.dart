import 'package:BSProOMS/auth/form_submission_status.dart';
import 'package:BSProOMS/data/Constants.dart';
import 'package:BSProOMS/data/SharedPreferencesConfig.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../data/User.dart';
import '../../session_view.dart';
import '../../widget/DrawermenuWidget.dart';
import 'cubit/settings_bloc.dart';
import 'cubit/settings_event.dart';
import 'cubit/settings_state.dart';

class SettingPage extends StatelessWidget {
  final VoidCallback openDrawer;
  const SettingPage({Key? key, required this.openDrawer}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: MyConstants.of(context)!.primaryColor,
          leading: DrawerMenuWidget(
            onClicked: openDrawer,
          ),
          title: Text('Setting Page'),
        ),
        body: DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: AppBar(
              bottom: const TabBar(
                indicatorColor: Colors.white,
                indicator: UnderlineTabIndicator(
                    borderSide: BorderSide(width: 5.0, color: Colors.white),
                    insets: EdgeInsets.symmetric(horizontal: 5.0)),
                tabs: [
                  Tab(icon: Icon(Icons.key), text: 'Change Password'),
                  Tab(icon: Icon(Icons.person), text: 'Profile Update'),
                ],
              ),
              toolbarHeight: 0,
              backgroundColor: MyConstants.of(context)!.primaryColor,
            ),
            body: TabBarView(
              children: [
                ChangePassword(),
                ProfileTab(),
              ],
            ),
          ),
        ));
  }
}

class ChangePassword extends StatefulWidget {
  ChangePassword({
    Key? key,
  }) : super(key: key);

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final _formKey = GlobalKey<FormState>();
  bool oldpasswordVisible = false;
  bool newpasswordVisible = false;
  bool reTypePasswordVisible = false;

  @override
  void initState() {
    super.initState();
    this.oldpasswordVisible = false;
    this.newpasswordVisible = false;
    this.reTypePasswordVisible = false;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingBloc, SettingState>(
      builder: (context, state) {
        return BlocListener<SettingBloc, SettingState>(
          listener: (context, state) {
            final formStatus = state.formStatus;
            if (formStatus is SubmissionSuccess) {
              _formKey.currentState!.reset();
            }
          },
          child: Center(
              child: SingleChildScrollView(
                  child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: TextFormField(
                    validator: (value) {
                      return state.isValidOldPassword
                          ? null
                          : 'Old Password Required';
                    },
                    keyboardType: TextInputType.text,
                    obscureText: !oldpasswordVisible,
                    onChanged: (value) {
                      context
                          .read<SettingBloc>()
                          .add(OldPasswordChange(nOldPassword: value));
                    },
                    decoration: InputDecoration(
                        labelStyle: TextStyle(
                            color: MyConstants.of(context)!.primaryColor),
                        focusColor: MyConstants.of(context)!.primaryColor,
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: MyConstants.of(context)!.primaryColor)),
                        isDense: true,
                        labelText: "Old Password",
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 0.0)),
                        border: OutlineInputBorder(),
                        suffixIcon: IconTheme(
                            data: IconThemeData(
                                color: MyConstants.of(context)!.primaryColor),
                            child: IconButton(
                                icon: Icon(!oldpasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off),
                                onPressed: () => {
                                      setState(() {
                                        oldpasswordVisible =
                                            !oldpasswordVisible;
                                      })
                                    })),
                        prefixIcon: IconTheme(
                            data: IconThemeData(
                                color: MyConstants.of(context)!.primaryColor),
                            child: Icon(FontAwesomeIcons.key))),
                  ),
                ),
                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: TextFormField(
                    validator: (value) {
                      return state.isValidNewPassword
                          ? null
                          : 'New Password Required';
                    },
                    keyboardType: TextInputType.text,
                    obscureText: !newpasswordVisible,
                    onChanged: (value) {
                      context
                          .read<SettingBloc>()
                          .add(NewPasswordChange(nNewPassword: value));
                    },
                    decoration: InputDecoration(
                        labelStyle: TextStyle(
                            color: MyConstants.of(context)!.primaryColor),
                        focusColor: MyConstants.of(context)!.primaryColor,
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: MyConstants.of(context)!.primaryColor)),
                        isDense: true,
                        labelText: "New Password",
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 0.0)),
                        border: OutlineInputBorder(),
                        suffixIcon: IconTheme(
                            data: IconThemeData(
                                color: MyConstants.of(context)!.primaryColor),
                            child: IconButton(
                                icon: Icon(!newpasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off),
                                onPressed: () => {
                                      setState(() {
                                        newpasswordVisible =
                                            !newpasswordVisible;
                                      })
                                    })),
                        prefixIcon: IconTheme(
                            data: IconThemeData(
                                color: MyConstants.of(context)!.primaryColor),
                            child: Icon(FontAwesomeIcons.key))),
                  ),
                ),
                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: TextFormField(
                    validator: (value) {
                      if (state.isValidReTypePassword) {
                        if (state.isValidReTypePasswordMatch) {
                          return null;
                        } else {
                          return 'New Password and Re Type Password should be matched';
                        }
                      } else {
                        return 'Re Type Password Required';
                      }
                      //  return state.isValidOldPassword ? null : 'Old Password Required';
                    },
                    keyboardType: TextInputType.text,
                    obscureText: !reTypePasswordVisible,
                    onChanged: (value) {
                      context
                          .read<SettingBloc>()
                          .add(ReTypePasswordChange(nReTypePassword: value));
                    },
                    decoration: InputDecoration(
                        labelStyle: TextStyle(
                            color: MyConstants.of(context)!.primaryColor),
                        focusColor: MyConstants.of(context)!.primaryColor,
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: MyConstants.of(context)!.primaryColor)),
                        isDense: true,
                        labelText: "Re Type Password",
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 0.0)),
                        border: OutlineInputBorder(),
                        suffixIcon: IconTheme(
                            data: IconThemeData(
                                color: MyConstants.of(context)!.primaryColor),
                            child: IconButton(
                                icon: Icon(!reTypePasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off),
                                onPressed: () => {
                                      setState(() {
                                        reTypePasswordVisible =
                                            !reTypePasswordVisible;
                                      })
                                    })),
                        prefixIcon: IconTheme(
                            data: IconThemeData(
                                color: MyConstants.of(context)!.primaryColor),
                            child: Icon(FontAwesomeIcons.key))),
                  ),
                ),
                const SizedBox(height: 20),
                _saveButton()
              ],
            ),
          ))),
        );
      },
    );
  }

  Widget _saveButton() {
    return BlocBuilder<SettingBloc, SettingState>(
      builder: (context, state) {
        return state.formStatus is FormSubmitting
            ? CircularProgressIndicator(
                color: MyConstants.of(context)!.primaryColor,
              )
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      onPrimary: MyConstants.of(context)!.secondaryColor,
                      primary: MyConstants.of(context)!.primaryColor,
                      minimumSize: const Size.fromHeight(30),
                      padding: EdgeInsetsDirectional.all(10),
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(10))),
                  onPressed: () async {
                    FocusScope.of(context).unfocus();
                    if (_formKey.currentState!.validate()) {
                      // context.read<SettingBloc>().add(UpdatePassword());
                      final bloc = BlocProvider.of<SettingBloc>(context);
                      bool result = await bloc.profileUpdate();
                      if (result) {
                        Navigator.of(context).push(MaterialPageRoute(builder: (_) => SessionView()));
                      }
                    }
                  },
                  child: Text(
                    'PROCEED',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              );
      },
    );
  }
}

class ProfileTab extends StatefulWidget {
  const ProfileTab({
    Key? key,
  }) : super(key: key);

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  TextEditingController nShopController = TextEditingController();
  TextEditingController nContactController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState(){
    super.initState();
    context.read<SettingBloc>().add(ProfileInitial());
    SharedPreferencesConfig.getUser().then((user) => {
        nShopController.text = user!.nUserName,
        nContactController.text = user.nUserID,
        context.read<SettingBloc>().add(ShopNameChange(nShopName: nShopController.text)),
    context.read<SettingBloc>().add(ContactNoChange(nContact: nContactController.text)),
    });


  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingBloc, SettingState>(
      builder: (context, state) {
        return BlocListener<SettingBloc, SettingState>(
          listener: (context, state) {
            final formStatus = state.formStatus;
            if (formStatus is SubmissionSuccess) {
              _formKey.currentState!.reset();
            }
          },
          child: Center(
              child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        const SizedBox(height: 15),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: TextFormField(
                            controller: nShopController,
                            validator: (value) {
                              return state.isValidShopName
                                  ? null
                                  : 'Shop Name Required';
                            },
                            keyboardType: TextInputType.text,
                            onChanged: (value) {
                              context
                                  .read<SettingBloc>()
                                  .add(ShopNameChange(nShopName: value));
                            },
                            decoration: InputDecoration(
                                labelStyle: TextStyle(
                                    color: MyConstants.of(context)!.primaryColor),
                                focusColor: MyConstants.of(context)!.primaryColor,
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: MyConstants.of(context)!.primaryColor)),
                                isDense: true,
                                labelText: "Shop Name",
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(width: 0.0)),
                                border: OutlineInputBorder(),
                                prefixIcon: IconTheme(
                                    data: IconThemeData(
                                        color: MyConstants.of(context)!.primaryColor),
                                    child: Icon(FontAwesomeIcons.solidUser))),
                          ),
                        ),
                        const SizedBox(height: 15),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: TextFormField(
                            controller: nContactController,
                            validator: (value) { return state.isValidMobile ? null : 'Invalid Mobile format'; },
                            keyboardType: TextInputType.phone,
                            onChanged: (value) {
                              context
                                  .read<SettingBloc>()
                                  .add(NewPasswordChange(nNewPassword: value));
                            },
                            decoration: InputDecoration(
                                hintText: '+92XXXXXXXXXX',
                                labelStyle: TextStyle(
                                    color: MyConstants.of(context)!.primaryColor),
                                focusColor: MyConstants.of(context)!.primaryColor,
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: MyConstants.of(context)!.primaryColor)),
                                isDense: true,
                                labelText: "Contact No",
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(width: 0.0)),
                                border: OutlineInputBorder(),
                                prefixIcon: IconTheme(
                                    data: IconThemeData(
                                        color: MyConstants.of(context)!.primaryColor),
                                    child: Icon(FontAwesomeIcons.idCard))),
                          ),
                        ),
                        const SizedBox(height: 15),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: TextFormField(
                            // validator: (value) { return state.isValidMobile ? null : 'Invalid Mobile format'; },
                            // onChanged: (value) {
                            //   context
                            //       .read<SettingBloc>()
                            //       .add(ReTypePasswordChange(nReTypePassword: value));
                            // },
                            decoration: InputDecoration(
                                labelStyle: TextStyle(
                                    color: MyConstants.of(context)!.primaryColor),
                                focusColor: MyConstants.of(context)!.primaryColor,
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: MyConstants.of(context)!.primaryColor)),
                                isDense: true,
                                labelText: "Address",
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(width: 0.0)),
                                border: OutlineInputBorder(),
                                prefixIcon: IconTheme(
                                    data: IconThemeData(
                                        color: MyConstants.of(context)!.primaryColor),
                                    child: Icon(FontAwesomeIcons.houseUser))),
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            minLines: 3,
                          ),
                        ),
                        const SizedBox(height: 20),
                        _saveButton()
                      ],
                    ),
                  ))),
        );
      },
    );
  }

  Widget _saveButton() {
    return BlocBuilder<SettingBloc, SettingState>(
      builder: (context, state) {
        return state.formStatus is FormSubmitting
            ? CircularProgressIndicator(
          color: MyConstants.of(context)!.primaryColor,
        ) : Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                onPrimary: MyConstants.of(context)!.secondaryColor,
                primary: MyConstants.of(context)!.primaryColor,
                minimumSize: const Size.fromHeight(30),
                padding: EdgeInsetsDirectional.all(10),
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(10))),
            onPressed: () async {
              FocusScope.of(context).unfocus();
              if (_formKey.currentState!.validate()) {
                context.read<SettingBloc>().add(ProfileUpdate());
              }
            },
            child: Text(
              'PROCEED',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
          ),
        );
      },
    );
  }
}
