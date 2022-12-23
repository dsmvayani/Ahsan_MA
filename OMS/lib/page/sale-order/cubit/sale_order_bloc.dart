import 'dart:collection';
import 'dart:convert';
import 'dart:ffi';

import 'package:BSProOMS/auth/form_submission_status.dart';
import 'package:BSProOMS/model/Product.dart';
import 'package:BSProOMS/model/SaleOrderTab.dart';
import 'package:BSProOMS/model/SalesManTab.dart';
import 'package:BSProOMS/page/customer-form/cubit/customer_state.dart';
import 'package:BSProOMS/page/sale-order/cubit/sale_order_event.dart';
import 'package:BSProOMS/page/sale-order/cubit/sale_order_state.dart';
import 'package:BSProOMS/repository/customer_repositry.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

import '../../../model/City.dart';
import '../../../model/Customer.dart';
import '../../../repository/sale_order_repositry.dart';

class SaleOrderBloc extends Bloc<SaleOrderEvent, SaleOrderState> {
  final SaleOrderRepository saleOrderRepository;

  SaleOrderBloc({required this.saleOrderRepository}) : super(SaleOrderState()) {
    on<SaleOrderEvent>(_onEvent);
  }

  Future<void> _onEvent(
      SaleOrderEvent event, Emitter<SaleOrderState> emit) async {
    if(event is RefreshSaleOrder){
      emit(state.copyWith(billDate: '', isEdit: 0, formStatus: InitialFormStatus(), customerState: CustomerState(customerName: '', customerCode: ''), salesManTab: SalesManTab(nSalesManCode: '', nSalesMan: '', nShortName: ''), list: [], customerName: '', netAmount: 0, totalItems: 0, totalQuantity: 0, description: '', saleOrderList: [], isSync: false));
    }
    else if (event is BillDateChanged) {
      emit(state.copyWith(billDate: event.billDate));
     }
    else if (event is CustomerChanged) {
      emit(state.copyWith(customerState: event.customer));
    }
    else if (event is SalesmanChanged) {
      emit(state.copyWith(salesManTab: event.obj));
    }
    else if (event is DescriptionChanged) {
      emit(state.copyWith(description: event.desc));
    }
    else if (event is GetProductLookup) {
      state.listProducts?.addAll(event.list);
      List<Product>? nList = state.listProducts;
      emit(state.copyWith(list: []));
      emit(state.copyWith(list: nList));
    }
    else if(event is EditOrder){
      emit(state.copyWith(isEdit:1, list: state.listProducts, totalItems: state.totalItems, totalQuantity: state.totalQuantity, netAmount: state.netAmount, billDate: state.billDate, formStatus: SubmissionSuccess()));
    }
    else if (event is ProductsChanged) {
      if(event.list.length > 0){
        double nTotalQuantity = 0;
        double nTotalItems = 0;
        double nNetAmount = 0;
        nTotalQuantity = event.list.map((e) => e.nQuantity).reduce((value, element) => value+element);
        nTotalItems = event.list.length.ceilToDouble();
        nNetAmount = event.list.map((e) => e.nAmount).reduce((value, element) => value+element);
        emit(state.copyWith(list: event.list, totalItems: nTotalItems, totalQuantity: nTotalQuantity, netAmount: nNetAmount));
      }
      else{
        emit(state.copyWith(list: [], totalItems: 0, totalQuantity: 0, netAmount: 0));
      }

    }
    else if (event is GetSaleOrderListOffline) {
      event.list.sort((a, b) => a.customer!.customerName
          .toString()
          .toLowerCase()
          .compareTo(b.customer!.customerName.toString().toLowerCase()));
      emit(state.copyWith(saleOrderList: event.list));
    }
    else if(event is GetSaleOrderList){
      emit(state.copyWith(formStatus: FormSubmitting()));
      try{
        final Response? response = await saleOrderRepository.getSaleOrderList(event.orderType.toString());
        if (response != null) {
          if (response.statusCode == 200) {
            var json = jsonDecode(response.data);
            List<HashMap<String, dynamic>> nlist = [];
            for(LinkedHashMap o in json){
              var o1 = o.entries.elementAt(0);
              var o2 = o.entries.elementAt(1);
              var o3 = o.entries.elementAt(2);
              var o4 = o.entries.elementAt(3);
              HashMap<String, dynamic> doc = new HashMap();
                doc[o1.key] = o1.value;
                doc[o2.key] = o2.value;
                doc[o3.key] = o3.value;
                doc[o4.key] = o4.value;
              nlist.add(doc);
            }
            emit(state.copyWith(nOrderList: nlist, formStatus: SubmissionSuccess()));
          }
        }
      }
      catch(e){
        emit(state.copyWith( formStatus: SubmissionFailed(new Exception("Fetching Failed"))));
      }

    }
    else if (event is SaveSaleOrder) {
      final Response? response = await saleOrderRepository.saveOrder(state);
      if (response != null) {
        if (response.statusCode == 200) {

          EasyLoading.showSuccess("Saved Successfully",duration: const Duration(milliseconds: 1000));
        }
      }
    }
    else if(event is StartLoading){
      emit(state.copyWith(formStatus: FormSubmitting()));
    }
    else if(event is StopLoading){
      emit(state.copyWith(formStatus: SubmissionSuccess()));
    }
    else if(event is GetSaleOrderDetail){
      emit(state.copyWith(formStatus: FormSubmitting(),list: [], totalItems: 0, totalQuantity: 0, netAmount: 0, billDate: ""));
      try{
        emit(state.copyWith());
        String orderId = event.orderId;
        final Response? response = await saleOrderRepository.getData("OMS_SalesOrderSP", ["@nType", "@nsType", "@BillNo"], ["0", "2", orderId]);
        emit(state.copyWith(formStatus: FormSubmitting(),list: [], totalItems: 0, totalQuantity: 0, netAmount: 0, billDate: ""));
        if (response != null) {
          if (response.statusCode == 200) {
            var json = jsonDecode(response.data);
            List<Product> list = [];
            String nBillDate = json[0]["BillDate"];
            String nBillNo = json[0]["BillNo"];
            for(var obj in json){
              Product p = new Product(nBarCode: obj["BarCode"], nItem: obj["Item"], nUnitCode: obj["AttributeCode"] ?? "", nAttribute: obj["Attribute"] ?? "", nAttribute1Image: "", nSalesRate:  obj["Rate"].toDouble(), nQuantity: obj["Quantity"].toDouble(), nAmount: obj["Amount"].toDouble());
              list.add(p);
            }
            String description = json[0]["Remarks"];
            double nTotalQuantity = 0;
            double nTotalItems = 0;
            double nNetAmount = 0;
            nTotalQuantity = list.map((e) => e.nQuantity).reduce((value, element) => value+element);
            nTotalItems = list.length.ceilToDouble();
            nNetAmount = list.map((e) => e.nAmount).reduce((value, element) => value+element);
            state.listProducts?.addAll(list);
            emit(state.copyWith(list: state.listProducts, totalItems: nTotalItems, totalQuantity: nTotalQuantity, netAmount: nNetAmount, billDate: nBillDate, formStatus: SubmissionSuccess()));
          }
        }
      }
      catch(e){
        emit(state.copyWith( formStatus: SubmissionFailed(new Exception("Fetching Failed"))));
      }
    }
  }
  Future<bool> isSaveOrder() async{
    try{
      final Response? response = await saleOrderRepository.saveOrder(state);
      if (response != null) {
        if (response.statusCode == 200) {
          EasyLoading.showSuccess(state.isEdit ==  0 ? "Saved Successfully" : "Update Successfully",duration: const Duration(milliseconds: 1000));
          return true;
        }
      }
      return false;
    }
    catch(e){
      return false;
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
