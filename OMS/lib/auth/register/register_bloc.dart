import 'package:BSProOMS/auth/auth_cubit.dart';
import 'package:BSProOMS/auth/auth_repository.dart';
import 'package:BSProOMS/auth/form_submission_status.dart';
import 'package:BSProOMS/auth/register/register_event.dart';
import 'package:BSProOMS/auth/register/register_state.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../data/SharedPreferencesConfig.dart';
import '../auth_credentials.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final AuthRepository authRepo;
  final AuthCubit authCubit;

  RegisterBloc({required this.authCubit, required this.authRepo})
      : super(RegisterState()) {
    on<RegisterEvent>(_onEvent);
  }

  Future<void> _onEvent(
      RegisterEvent event, Emitter<RegisterState> emit) async {
    if (event is RegisterShopNameChanged) {
      emit(state.copyWith(shopName: event.shopName));
    } else if (event is RegisterContactNoChanged) {
      emit(state.copyWith(contactNo: event.contactNo));
    } else if (event is VerificationCode1Change) {
      debugPrint( '----> code 1: ${event.code}');
      emit(state.copyWith(verifyCode1: event.code));
    } else if (event is VerificationCode2Change) {
      debugPrint( '----> code 2: ${event.code}');
      emit(state.copyWith(verifyCode2: event.code));
    } else if (event is VerificationCode3Change) {
      debugPrint( '----> code 3: ${event.code}');
      emit(state.copyWith(verifyCode3: event.code));
    } else if (event is VerificationCode4Change) {
      debugPrint( '----> code 4: ${event.code}');
      emit(state.copyWith(verifyCode4: event.code));
    } else if (event is VerificationCode5Change) {
      debugPrint( '----> code 5: ${event.code}');
      emit(state.copyWith(verifyCode5: event.code));
    } else if (event is VerificationCode6Change) {
      debugPrint( '----> code 6: ${event.code}');
      emit(state.copyWith(verifyCode6: event.code));
    } else if (event is VerificationCode1Change) {
      emit(state.copyWith(verifyCode1: event.code));
    } else if (event is VerificationCode1Change) {
      emit(state.copyWith(verifyCode1: event.code));
    }
    // else if (event is GetDefaultMobileCode) {
    //   emit(state.copyWith(formStatus: FormSubmitting()));
    //   try{
    //     final Response? response = await authRepo.getData("GEN_BSProOMSSP", ['@nType', '@nsType'], ['0', '11']);
    //     if(response != null && response.statusCode == 200){
    //       var data = response.data;
    //       String nDefaultCode = "+" + response.data.toString();
    //       // event.controller.text = nDefaultCode;
    //       emit(state.copyWith(contactNo: nDefaultCode, formStatus: SubmissionSuccess()));
    //     }
    //   }
    //   catch(e){
    //   }
    // }
    // password update
    else if (event is RegisterPasswordChanged) {
      emit(state.copyWith(password: event.password));
    } else if (event is VerificationProcess) {
      // emit(state.copyWith(formStatus: FormSubmitting()));
      var myVerificationId = "";
      print('-->2');
      try {
        print('-->1');
        //firebase code
        /*FirebaseAuth firebaseAuth = FirebaseAuth.instance;
        firebaseAuth.verifyPhoneNumber(
            phoneNumber: state.contactNo,
            verificationCompleted: (PhoneAuthCredential credential) async {
              print('-->2');
            },
            verificationFailed: (FirebaseAuthException exception) {
              Fluttertoast.showToast( msg: exception.message.toString(), toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM, timeInSecForIosWeb: 1, backgroundColor: Colors.red, textColor: Colors.white, fontSize: 16.0 );
              // print(exception.message);
            },
            codeSent: (String _verificationId, int? resentToken) {
              emit(state.copyWith(mVerificationId:_verificationId  ));
              emit(state.copyWith(
                  formStatus: SubmissionSuccess()));
              // verificationIdRecieved = verificationId;
            },
            codeAutoRetrievalTimeout: (String verificationId) {});*/

      } catch (e) {
        print('-->3');
        emit(state.copyWith(formStatus: SubmissionFailed(new Exception(e))));
        // emit(state.copyWith(formStatus: SubmissionFailed(e.toString())));
      }
    } else if (event is RegisterSubmitted) {
      try {
        // if(state.nVerificationId!.isEmpty){emit(state.copyWith(formStatus: SubmissionFailed(new Exception("Not Allowed to register"))));}
        emit(state.copyWith(formStatus: FormSubmitting()));
          final isRegister = await authRepo.registerUser(
              '${state.shopName}', '${state.contactNo}', '${state.password}');
          if (isRegister) {
            final isLogin =
            await authRepo.login(state.contactNo, state.password);
            print('-->5');
            if (isLogin) {
              final token = await SharedPreferencesConfig.getToken();
              emit(state.copyWith(formStatus: SubmissionSuccess()));
              authCubit.launchSession(
                  AuthCredentials(userId: state.contactNo, token: token));
              print('-->4');
            } else {
              print('-->6');
              emit(state.copyWith(
                  formStatus: SubmissionFailed(new Exception("Login Failed"))));
            }
            emit(state.copyWith(formStatus: SubmissionSuccess()));
            print('-->Login Failed ');
          }
        else{
            Fluttertoast.showToast( msg: 'registration failed', toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM, timeInSecForIosWeb: 1, backgroundColor: Colors.red, textColor: Colors.white, fontSize: 16.0 );
          emit(state.copyWith(
              formStatus: SubmissionFailed(new Exception("Registration Failed"))));
        }

      } catch (e) {}
    }
  }
  Future<String> getDefaultMobileCode() async {
    String nDefaultCode = "";
    try{
      final Response? response = await authRepo.getData("GEN_BSProOMSSP", ['@nType', '@nsType'], ['0', '11']);
      if(response != null && response.statusCode == 200){
        nDefaultCode = "+" + response.data.toString();
      }
      return nDefaultCode;
    }
    catch(e){
      return nDefaultCode;
    }

  }
//  syncOrders() async {
//   EasyLoading.dismiss();
//   Box<SaleOrderTab> tblSaleOrder = Hive.box<SaleOrderTab>("SaleOrderTab");
//   List<SaleOrderTab> list = tblSaleOrder.values.where((element) => !element.isSync).toList();
//   if (list.length > 0) {
//     EasyLoading.show(status: "Uploading");
//     String alreadyCreated = "";
//     for (int i = 0; i < list.length; i++) {
//       try {
//         SaleOrderTab sot = list[i];
//         final Response? response = await saleOrderRepository.saveOrder(sot);
//         if (response != null) {
//           if(response.statusCode == 201){
//             // alreadyCreated += cc.mobileNo! + " ";
//             sot.delete();
//           }
//           else if (response.statusCode == 200) {
//             sot.delete();
//           }
//           String warning = alreadyCreated.length > 0 ? " These duplicate number(s) didn't save "+ alreadyCreated : '';
//           String msg = "Order(s) uploaded successfully!"+warning;
//           EasyLoading.showSuccess(msg,duration: const Duration(milliseconds: 1000));
//         }
//         else{
//           EasyLoading.showError("Order(s) failed to upload.",duration: const Duration(milliseconds: 1000));
//         }
//
//       } catch (e) {
//         EasyLoading.dismiss();
//         EasyLoading.showError("Order(s) failed to upload.",duration: const Duration(milliseconds: 1000));
//       }
//     }
//
//   } else {
//     EasyLoading.showInfo("No order(s) found to upload",
//         duration: const Duration(milliseconds: 3000));
//   }
// }
}
