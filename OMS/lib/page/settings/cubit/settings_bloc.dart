import 'dart:convert';
import 'package:BSProOMS/data/SharedPreferencesConfig.dart';
import 'package:BSProOMS/data/User.dart';
import 'package:BSProOMS/page/settings/cubit/settings_event.dart';
import 'package:BSProOMS/page/settings/cubit/settings_state.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../auth/form_submission_status.dart';
import '../../../repository/setting_repository.dart';

class SettingBloc extends Bloc<SettingEvent, SettingState> {
  final SettingRepository nSettingRepository;

  SettingBloc({required this.nSettingRepository}) : super(SettingState()) {
    on<SettingEvent>(_onEvent);
  }

  Future<void> _onEvent(SettingEvent event, Emitter<SettingState> emit) async {
        User? user = await SharedPreferencesConfig.getUser();
    emit(state.copyWith(formStatus: InitialFormStatus()));
    if (event is ProfileInitial) {
      emit(state.copyWith(nShopName: user!.nUserName, nContactNo: user.nUserID));
    }else if (event is OldPasswordChange) {
      emit(state.copyWith(nOldPassword: event.nOldPassword));
    } else if (event is NewPasswordChange) {
      emit(state.copyWith(nNewPassword: event.nNewPassword));
    } else if (event is ReTypePasswordChange) {
      emit(state.copyWith(nReTypePassword: event.nReTypePassword));
    }else if (event is ShopNameChange) {
      emit(state.copyWith(nShopName: event.nShopName));
    }else if (event is ContactNoChange) {
      emit(state.copyWith(nContactNo: event.nContact));
    } else if (event is UpdatePassword) {
      emit(state.copyWith(formStatus: FormSubmitting()));
      try {
        final Response? response = await nSettingRepository.getData("GEN_UserSP",["@nType", "@nsType", "@UserId", "@OldPassword", "@NewPassword"],['0', '20', user!.nUserID, state.nOldPassword, state.nNewPassword]);

        if (response != null && response.statusCode == 200) {
          var json = jsonDecode(response.data);
          var jsonMsg = json[0]["Column1"];
          if(jsonMsg == "Password Changed Successfully"){
            Fluttertoast.showToast( msg: jsonMsg, toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM, timeInSecForIosWeb: 1, backgroundColor: Colors.greenAccent, textColor: Colors.white, fontSize: 16.0 );
            emit(state.copyWith(nOldPassword: "", nNewPassword: "", nReTypePassword: "", formStatus: SubmissionSuccess()));
          }
          else{
            Fluttertoast.showToast( msg: jsonMsg, toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM, timeInSecForIosWeb: 1, backgroundColor: Colors.red, textColor: Colors.white, fontSize: 16.0 );
            emit(state.copyWith(formStatus: SubmissionFailed(new Exception(jsonMsg))));
          }
        } else {
            Fluttertoast.showToast( msg: "Password failed to change", toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM, timeInSecForIosWeb: 1, backgroundColor: Colors.red, textColor: Colors.white, fontSize: 16.0 );
          emit(state.copyWith(formStatus: SubmissionFailed(new Exception("Password failed to change"))));
        }
      } catch (e) {
        emit(state.copyWith(formStatus: SubmissionFailed(new Exception(e))));
      }
      // emit(state.copyWith(billDate: '', formStatus: InitialFormStatus(), customerState: CustomerState(customerName: '', customerCode: ''), salesManTab: SalesManTab(nSalesManCode: '', nSalesMan: '', nShortName: ''), list: [], customerName: '', netAmount: 0, totalItems: 0, totalQuantity: 0, description: '', saleOrderList: [], isSync: false));
    }
    else if (event is ProfileUpdate) {
      emit(state.copyWith(formStatus: FormSubmitting()));
      try {
        final Response? response = await nSettingRepository.getData("GEN_BSProOMSSP",["@nType", "@nsType", "@UserId", "@UserName", "@UserCode"],['0', '9', state.nContactNo, state.nShopName, user!.nUserCode]);

        if (response != null && response.statusCode == 200) {
          var json = jsonDecode(response.data);
          var jsonMsg = json[0]["Column1"];
          if(jsonMsg == "Password Changed Successfully"){
            Fluttertoast.showToast( msg: jsonMsg, toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM, timeInSecForIosWeb: 1, backgroundColor: Colors.greenAccent, textColor: Colors.white, fontSize: 16.0 );
            emit(state.copyWith(nOldPassword: "", nNewPassword: "", nReTypePassword: "", formStatus: SubmissionSuccess()));
          }
          else{
            Fluttertoast.showToast( msg: jsonMsg, toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM, timeInSecForIosWeb: 1, backgroundColor: Colors.red, textColor: Colors.white, fontSize: 16.0 );
            emit(state.copyWith(formStatus: SubmissionFailed(new Exception(jsonMsg))));
          }
        } else {
            Fluttertoast.showToast( msg: "Password failed to change", toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM, timeInSecForIosWeb: 1, backgroundColor: Colors.red, textColor: Colors.white, fontSize: 16.0 );
          emit(state.copyWith(formStatus: SubmissionFailed(new Exception("Password failed to change"))));
        }
      } catch (e) {
        emit(state.copyWith(formStatus: SubmissionFailed(new Exception(e))));
      }
      // emit(state.copyWith(billDate: '', formStatus: InitialFormStatus(), customerState: CustomerState(customerName: '', customerCode: ''), salesManTab: SalesManTab(nSalesManCode: '', nSalesMan: '', nShortName: ''), list: [], customerName: '', netAmount: 0, totalItems: 0, totalQuantity: 0, description: '', saleOrderList: [], isSync: false));
    }
  }
}
