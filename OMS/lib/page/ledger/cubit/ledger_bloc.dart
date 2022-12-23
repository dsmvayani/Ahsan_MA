import 'dart:convert';
import 'package:BSProOMS/data/SharedPreferencesConfig.dart';
import 'package:BSProOMS/data/User.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../auth/form_submission_status.dart';
import '../../../repository/ledger_repository.dart';
import 'ledger_event.dart';
import 'ledger_state.dart';

class LedgerBloc extends Bloc<LedgerEvent, LedgerState> {
  final LedgerRepository nLedgerRepository;

  LedgerBloc({required this.nLedgerRepository}) : super(LedgerState()) {
    on<LedgerEvent>(_onEvent);
  }

  Future<void> _onEvent(LedgerEvent event, Emitter<LedgerState> emit) async {
        User? user = await SharedPreferencesConfig.getUser();
    emit(state.copyWith(formStatus: InitialFormStatus()));
     if (event is GetLedgerReport) {
      emit(state.copyWith(formStatus: FormSubmitting()));
      try {
        final Response? response = await nLedgerRepository.getData("GEN_BSProOMSSP",["@nType", "@nsType", "@UserID"],['0', '10', user!.nUserID]);

        if (response != null && response.statusCode == 200) {
          var json = jsonDecode(response.data);
          // final validMap = jsonDecode(response.data) as Map<String, dynamic>;
          // var jsonMsg = json[0]["Column1"];
          //   Fluttertoast.showToast( msg: jsonMsg, toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM, timeInSecForIosWeb: 1, backgroundColor: Colors.greenAccent, textColor: Colors.white, fontSize: 16.0 );
            emit(state.copyWith(nData: json, formStatus: SubmissionSuccess()));
          
        } else {
          emit(state.copyWith(formStatus: SubmissionFailed(new Exception("Password failed to change"))));
        }
      } catch (e) {
        emit(state.copyWith(formStatus: SubmissionFailed(new Exception(e))));
      }
      // emit(state.copyWith(billDate: '', formStatus: InitialFormStatus(), customerState: CustomerState(customerName: '', customerCode: ''), salesManTab: SalesManTab(nSalesManCode: '', nSalesMan: '', nShortName: ''), list: [], customerName: '', netAmount: 0, totalItems: 0, totalQuantity: 0, description: '', saleOrderList: [], isSync: false));
    }
  }
}
