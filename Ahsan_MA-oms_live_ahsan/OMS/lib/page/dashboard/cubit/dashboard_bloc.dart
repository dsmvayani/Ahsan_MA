

import 'dart:convert';
import 'dart:typed_data';

import 'package:BSProOMS/data/BarData.dart';
import 'package:BSProOMS/data/ProductOffers.dart';
import 'package:BSProOMS/data/SharedPreferencesConfig.dart';
import 'package:BSProOMS/data/User.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../auth/form_submission_status.dart';
import '../../../repository/dashboard_repositry.dart';
import 'dashboard_event.dart';
import 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final DashboardRepository nDashboardRepository;

  DashboardBloc({required this.nDashboardRepository}) : super(DashboardState()) {
    on<DashboardEvent>(_onEvent);
  }

  Future<void> _onEvent(
      DashboardEvent event, Emitter<DashboardState> emit) async {
    if(event is GetDashboardData){
      emit(state.copyWith(formStatus: FormSubmitting()));
      try {
        emit(state.copyWith(nCompletedOrder: "", nPendingOrder: "", nAccountBalance: "", nOrderDeliveryWeekDay: "", nAfterNextOrderDeliver: 0, nContactNo: "",nWhatsappNo: "", objBar: null, objUser: null, productOffers: []));
        final Response? response = await nDashboardRepository.getDashboardData();

        if (response != null && response.statusCode == 200) {
          var json = jsonDecode(response.data);
          emit(state.copyWith(nCompletedOrder: json["CompletedOrder"], nPendingOrder: json["PendingOrder"], nAccountBalance: json["AccountBalance"], nOrderDeliveryWeekDay: json["OrderDeliveryWeekDay"], nAfterNextOrderDeliver: json["AfterNextOrderDeliver"], nContactNo: json["ContactNo"],nWhatsappNo: json["WhatsappNo"],));
          String password = '';
          User? userSaved = await SharedPreferencesConfig.getUser();
          if(userSaved != null){
            password = userSaved.nUserPassword;
          }
          var jsonUser = json["objUser"];
          User? user = await SharedPreferencesConfig.getUser();
          emit(state.copyWith(objUser: user));
          var barData = json["BarData"];// BarData(nBarcode: nBarcode, nItem: nItem, nQuantity: nQuantity)
          List<BarData> list = [];
          for(var b in barData){
            list.add(BarData(nBarcode: b["Barcode"], nItem: b["Item"], nQuantity: b["Quantity"]));
          }
          emit(state.copyWith(objBar: list));
          var offersData = json["productOffers"];
          List<ProductOffers> offers = [];
          if(offersData != null){
            for(var o in offersData){
              var jsonImage = o["Attribute1Image"];
              offers.add(ProductOffers(nOfferDescription: o["OfferDescription"],nBarCode: o["BarCode"], nStartDate: DateTime.parse(o["StartDate"]), nEndDate: DateTime.parse(o["EndDate"]), nIsActive: o["IsActive"], nAttribute1Image: jsonImage != null ? jsonImage : ""));
            }
          }
          emit(state.copyWith(productOffers: offers));
          // emit(state.copyWith(productOffers: []));
          emit(state.copyWith(formStatus: SubmissionSuccess()));
        } else {
          emit(state.copyWith(
              formStatus: SubmissionFailed(new Exception("Login Failed"))));
        }
      } catch (e) {
        emit(state.copyWith(formStatus: SubmissionFailed(new Exception(e))));
      }
      // emit(state.copyWith(billDate: '', formStatus: InitialFormStatus(), customerState: CustomerState(customerName: '', customerCode: ''), salesManTab: SalesManTab(nSalesManCode: '', nSalesMan: '', nShortName: ''), list: [], customerName: '', netAmount: 0, totalItems: 0, totalQuantity: 0, description: '', saleOrderList: [], isSync: false));
    }
  }

}
