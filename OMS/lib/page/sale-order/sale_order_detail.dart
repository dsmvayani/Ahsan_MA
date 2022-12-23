import 'dart:collection';

import 'package:BSProOMS/model/SaleOrderTab.dart';
import 'package:BSProOMS/page/customer-form/cubit/customer_state.dart';
import 'package:BSProOMS/page/sale-order/add_sale_order_page.dart';
import 'package:BSProOMS/page/sale-order/cubit/sale_order_bloc.dart';
import 'package:BSProOMS/page/sale-order/cubit/sale_order_event.dart';
import 'package:BSProOMS/page/sale-order/cubit/sale_order_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../../auth/form_submission_status.dart';
import '../../data/Constants.dart';
import '../../model/Customer.dart';
import '../../model/Product.dart';

class SaleOrderDetail extends StatefulWidget {
  final String id;
  const SaleOrderDetail({Key? key, required this.id}) : super(key: key);

  @override
  State<SaleOrderDetail> createState() => _SaleOrderDetailState();
}

class _SaleOrderDetailState extends State<SaleOrderDetail> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyConstants.of(context)!.primaryColor,
        title: Text(widget.id),
        actions: [
          IconButton(
              icon: const Icon(Icons.edit),
              tooltip: "Edit",
              onPressed: () {
                Navigator.of(context)
                    .pushReplacement(MaterialPageRoute(builder: (_) => AddSaleOrder(isEdit: true)));
              }),
        ],
      ),
      body: SingleChildScrollView(
        child: BlocBuilder<SaleOrderBloc, SaleOrderState>(
            builder: (context, state) {
          return state.formStatus is FormSubmitting
            ? Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Center(
                child: CircularProgressIndicator(
                    color: MyConstants.of(context)!.primaryColor,
                  ),
              ),
            ) : Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(flex: 50, child: Text("Bill Date: "+state.billDate)),
                    Expanded(flex: 50, child: Text("Net Amount: "+state.netAmount.toString())),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(flex: 50, child: Text("Total Items: "+state.totalItems.toString())),
                    Expanded(flex: 50, child: Text("Total Qty: "+state.totalQuantity.toString())),
                  ],
                ),
                SizedBox(height: 10),
                Text("Remarks:"+ state.description),
                Text(state.description),
                SizedBox(height: 20),
                SizedBox(
                    height: 500,
                  child: ListView.builder(
                      itemCount: state.listProducts!.length,
                      itemBuilder: (context, index) {
                        Product p = state.listProducts![index];
                    return ListTile(
                        title: Text(p.nItem != null ? p.nItem : ""),
                      subtitle:  Column(
                        children: [
                          Row(
                            children: [
                              Expanded(flex:33, child: Text("Barcode")),
                              Expanded(flex:33, child: Text("Qty")),
                              Expanded(flex:33, child: Text("Amount")),
                            ],
                          ),
                          Row(
                          children: [
                            Expanded(flex:33, child: Text(p.nBarCode, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold))),
                            Expanded(flex:33, child: Text(p.nQuantity.toString(), style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold))),
                            Expanded(flex:33, child: Text(p.nAmount.toString(), style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold))),
                          ],
                    ),
                        ],
                      ),);
                  }),
                ),
                // Padding(
                //   padding: const EdgeInsets.only(bottom: 6.0),
                //   child: RichText(
                //       text: TextSpan(children: [
                //     WidgetSpan(
                //       child: Transform.translate(
                //           offset: const Offset(0.0, -1.0),
                //           child: Text("Bill Date :  ",
                //               style: TextStyle(
                //                   color: Colors.grey[700], fontSize: 14))),
                //     ),
                //     TextSpan(
                //         text: obj.billDate,
                //         style: TextStyle(color: Colors.black, fontSize: 16))
                //   ])),
                // ),
                // Padding(
                //   padding: const EdgeInsets.only(bottom: 6.0),
                //   child: RichText(
                //       text: TextSpan(children: [
                //     WidgetSpan(
                //       child: Transform.translate(
                //           offset: const Offset(0.0, -1.0),
                //           child: Text("Customer :  ",
                //               style: TextStyle(
                //                   color: Colors.grey[700], fontSize: 14))),
                //     ),
                //     TextSpan(
                //         text: obj.customer!.customerName,
                //         style: TextStyle(color: Colors.black, fontSize: 16))
                //   ])),
                // ),
                // Padding(
                //   padding: const EdgeInsets.only(bottom: 6.0),
                //   child: RichText(
                //       text: TextSpan(children: [
                //     WidgetSpan(
                //       child: Transform.translate(
                //           offset: const Offset(0.0, -1.0),
                //           child: Text("Sales Man :  ",
                //               style: TextStyle(
                //                   color: Colors.grey[700], fontSize: 14))),
                //     ),
                //     TextSpan(
                //         text: obj.salesManTab!.nSalesMan,
                //         style: TextStyle(color: Colors.black, fontSize: 18))
                //   ])),
                // ),
                // Padding(
                //   padding: const EdgeInsets.only(bottom: 6.0),
                //   child: Row(
                //     children: [
                //       Expanded(child: RichText(
                //           text: TextSpan(children: [
                //             WidgetSpan(
                //               child: Transform.translate(
                //                   offset: const Offset(0.0, -1.0),
                //                   child: Text("Total Items :  ",
                //                       style: TextStyle(
                //                           color: Colors.grey[700], fontSize: 14))),
                //             ),
                //             TextSpan(
                //                 text: obj.totalItems.toString(),
                //                 style: TextStyle(color: Colors.black, fontSize: 18))
                //           ]))),
                //       Expanded(child: RichText(
                //           text: TextSpan(children: [
                //             WidgetSpan(
                //               child: Transform.translate(
                //                   offset: const Offset(0.0, -1.0),
                //                   child: Text("Total Quantity :  ",
                //                       style: TextStyle(
                //                           color: Colors.grey[700], fontSize: 14))),
                //             ),
                //             TextSpan(
                //                 text: obj.totalQuantity.toString(),
                //                 style: TextStyle(color: Colors.black, fontSize: 18))
                //           ]))),
                //     ],
                //   ),
                // ),
                // Padding(
                //   padding: const EdgeInsets.only(bottom: 6.0),
                //   child: Row(
                //     children: [
                //       Expanded(child: RichText(
                //           text: TextSpan(children: [
                //             WidgetSpan(
                //               child: Transform.translate(
                //                   offset: const Offset(0.0, -1.0),
                //                   child: Text("Net Amount :  ",
                //                       style: TextStyle(
                //                           color: Colors.grey[700], fontSize: 14))),
                //             ),
                //             TextSpan(
                //                 text: obj.netAmount.toString(),
                //                 style: TextStyle(color: Colors.black, fontSize: 18))
                //           ]))),
                //     ],
                //   ),
                // ),
                // SizedBox(
                //     height: obj.listProducts!.length * 65,
                //     child: ListView.builder(
                //         itemCount: obj.listProducts!.length,
                //         itemBuilder: (context, index) {
                //           Product p = obj.listProducts![index];
                //           return Card(
                //             child: ListTile(
                //               title: Row(
                //                 children: [
                //                   Expanded(child: Text(p.nItem),flex: 2),
                //                   Expanded(child: Center(child: Column(
                //                     children: [
                //                       Text('Qty'),
                //                       Text(p.nQuantity.toString()),
                //                     ],
                //                   ))),
                //                   Expanded(child: Center(child: Column(
                //                     children: [
                //                       Text('Rate'),
                //                       Text(p.nSalesRate.toString()),
                //                     ],
                //                   ))),
                //                   Expanded(child: Center(child: Column(
                //                     children: [
                //                       Text('Amount'),
                //                       Text(p.nAmount.toString()),
                //                     ],
                //                   ))),
                //                 ],
                //               ),
                //               // subtitle: Text(p.nAmount),
                //             ),
                //           );
                //         })),
                // const SizedBox(height: 10),
                // !obj.isSync
                //     ? ElevatedButton(
                //         style: ElevatedButton.styleFrom(
                //             primary: Theme.of(context).primaryColor,
                //             minimumSize: const Size.fromHeight(50),
                //             padding: EdgeInsetsDirectional.all(15),
                //             shape: new RoundedRectangleBorder(
                //                 borderRadius: new BorderRadius.circular(10))),
                //         onPressed: () {
                //           deleteCustomer(context, obj);
                //         },
                //         child: Text(
                //           'DELETE',
                //           style: TextStyle(
                //               color: Colors.white,
                //               fontSize: 20,
                //               fontWeight: FontWeight.bold),
                //         ),
                //       )
                //     : Container(),
                // const SizedBox(height: 10)
              ],
            ),
          );
        }),
      ),
    );
  }

  deleteCustomer(BuildContext context, SaleOrderState obj) {
    Alert(
        context: context,
        style: AlertStyle(isCloseButton: false),
        type: AlertType.warning,
        title: "Delete " + obj.customerName,
        content: Text(
          "Do you want to delete it?",
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
            color: Theme.of(context).primaryColor,
            onPressed: () async {
              Navigator.of(context, rootNavigator: true).pop();
              Box<SaleOrderTab> tblSaleOrder =
                  Hive.box<SaleOrderTab>("SaleOrderTab");
              List<SaleOrderTab> deleteList = tblSaleOrder.values
                  .where((element) =>
                      element.nBillDate == obj.billDate &&
                      element.nCustomer.customerName ==
                          obj.customer?.customerName &&
                      element.nProductList == obj.listProducts)
                  .toList();
              if (deleteList != null && deleteList.isNotEmpty) {
                deleteList.first.delete();
                List<SaleOrderState> list = [];
                for (int i = 0; i < tblSaleOrder.length; i++) {
                  var cus = tblSaleOrder.getAt(i)?.nCustomer;
                  CustomerState cs = CustomerState(
                      customerCode: cus!.customerCode ?? '',
                      customerName: cus!.customerName ?? '',
                      phoneNo: cus.phoneNo ?? '',
                      mobileNo: cus.mobileNo ?? '',
                      address: cus.address ?? '',
                      email: cus.emailId ?? '',
                      cnic: cus?.cnicNo ?? '',
                      city: cus?.city ?? '',
                      isSync: cus.isSync);
                  SaleOrderState sos = SaleOrderState(
                      billDate: tblSaleOrder.getAt(i)!.nBillDate,
                      description: tblSaleOrder.getAt(i)!.nDescription,
                      customer: cs,
                      salesManTab: tblSaleOrder.getAt(i)!.nSalesMan,
                      listProducts: tblSaleOrder.getAt(i)!.nProductList,
                      totalQuantity: tblSaleOrder.getAt(i)!.nTotalQuantity,
                      totalItems: tblSaleOrder.getAt(i)!.nTotalItems,
                      netAmount: tblSaleOrder.getAt(i)!.nNetAmount);
                  list.add(sos);
                }
                context
                    .read<SaleOrderBloc>()
                    .add(GetSaleOrderListOffline(list: list));
                Navigator.pop(context);
              } else {
                Navigator.pop(context);
              }
            },
          ),
        ]).show();
  }

  @override
  void initState() {
    super.initState();
    context.read<SaleOrderBloc>().add(GetSaleOrderDetail(orderId: widget.id));
  }
}
