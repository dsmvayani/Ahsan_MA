



import 'dart:collection';

import 'package:BSProOMS/model/Product.dart';
import 'package:BSProOMS/model/SalesManTab.dart';
import 'package:BSProOMS/page/customer-form/cubit/customer_state.dart';
import '../../../auth/form_submission_status.dart';

class SaleOrderState{
  final String customerName;
  final String billNo;
  final String billDate;
  final CustomerState? customer;
  final SalesManTab? salesManTab;
  final String description;
  final List<Product>? listProducts;
  final List<HashMap<String, dynamic>>? orderList;
  final FormSubmissionStatus formStatus;
  final double totalItems;
  final double totalQuantity;
  final double netAmount;
  final List<SaleOrderState>? saleOrderList;
  final bool isSync;
  final int isEdit;

  SaleOrderState({
    this.isSync = false,
    this.billNo = '',
    this.customerName = '',
    this.billDate = '',
    this.description = '',
    this.customer,
    this.salesManTab,
    this.listProducts = const [],
    this.saleOrderList = const [],
    this.orderList = const [],
    this.formStatus = const InitialFormStatus(),
    this.totalItems = 0,
    this.totalQuantity = 0,
    this.netAmount = 0,
    this.isEdit = 0,
  });

  SaleOrderState copyWith({
    bool? isSync,
     String? customerName,
     String? billNo,
     String? billDate,
     String? description,
    CustomerState? customerState,
    SalesManTab? salesManTab,
    List<Product>? list,
    List<HashMap<String, dynamic>>? nOrderList,
     FormSubmissionStatus? formStatus,
    double? totalItems,
    double? totalQuantity,
    double? netAmount,
    int? isEdit,
    List<SaleOrderState>? saleOrderList,
    }) {
      return SaleOrderState(
        isSync: isSync ?? this.isSync,
        billNo: billNo ?? this.billNo,
        customerName: customerName ?? this.customerName,
        billDate: billDate ?? this.billDate,
        description: description ?? this.description,
        customer: customerState ?? this.customer,
        salesManTab: salesManTab ?? this.salesManTab,
        listProducts: list ?? this.listProducts,
        orderList: nOrderList ?? this.orderList,
        saleOrderList: saleOrderList ?? this.saleOrderList,
        formStatus: formStatus ?? this.formStatus,
        totalItems: totalItems ?? this.totalItems,
        totalQuantity: totalQuantity ?? this.totalQuantity,
        netAmount: netAmount ?? this.netAmount,
        isEdit: isEdit ?? this.isEdit,
      );
    }
}
