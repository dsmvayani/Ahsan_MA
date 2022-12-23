import 'dart:collection';

import 'package:BSProOMS/model/SaleOrderTab.dart';
import 'package:BSProOMS/page/customer-form/cubit/customer_state.dart';
import 'package:BSProOMS/page/sale-order/add_sale_order_page.dart';
import 'package:BSProOMS/page/sale-order/cubit/sale_order_bloc.dart';
import 'package:BSProOMS/page/sale-order/cubit/sale_order_event.dart';
import 'package:BSProOMS/page/sale-order/cubit/sale_order_state.dart';
import 'package:BSProOMS/page/sale-order/sale_order_detail.dart';
import 'package:BSProOMS/session_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../../auth/form_submission_status.dart';
import '../../data/Constants.dart';
import '../../widget/DrawermenuWidget.dart';
import '../../widget/MyShimmerEffectUI.dart';

class SaleOrder extends StatefulWidget {
  final VoidCallback openDrawer;
  SaleOrder({Key? key, required this.openDrawer}) : super(key: key);

  @override
  _SaleOrderState createState() => _SaleOrderState();
}

class _SaleOrderState extends State<SaleOrder> {
  TextEditingController editingController = TextEditingController();
  bool isShowClose = false;
  @override
  void initState() {
    super.initState();
    callSaleOrderOffline('');
  }

  Future<void> _pullRefresh() async {
    FocusManager.instance.primaryFocus?.unfocus();
    isShowClose = false;
    editingController.text = '';
    callSaleOrderOffline('');
    // context.read<SaleOrderBloc>().add(GetSaleOrderListOffline());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // resizeToAvoidBottomInset: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: MyConstants.of(context)!.primaryColor,
        leading: DrawerMenuWidget(
          onClicked: widget.openDrawer,
        ),
        title: Text('Sale Order'),
        actions: [
          IconButton(
              icon: const Icon(Icons.home),
              tooltip: "Dashboard",
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (_) => SessionView()));
              }),
          IconButton(
              icon: const Icon(Icons.sync),
              tooltip: "Refresh Dashboard",
              onPressed: () {
                _pullRefresh();
              }),
          IconButton(
              icon: const Icon(Icons.add),
              tooltip: "Add Sale Order",
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (_) => AddSaleOrder(isEdit: false)));
              })
        ],
      ),
      body: RefreshIndicator(
        color: MyConstants.of(context)!.primaryColor,
        onRefresh: _pullRefresh,
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: SafeArea(
                child: BlocBuilder<SaleOrderBloc, SaleOrderState>(
                  builder: (context, state) {
                    if(state.orderList!.isNotEmpty){
                      return Column(
                          children: state.orderList!
                              .map((i) => ListTile(
                            onTap: () =>
                                Navigator.push(context, MaterialPageRoute(builder: (context) {
                                  return SaleOrderDetail(id: i.entries.elementAt(3).value.toString());
                                })),
                            title: Row(
                              children: [
                                Expanded(
                                  child: RichText(
                                      overflow: TextOverflow.ellipsis,
                                      text: TextSpan(children: [
                                        TextSpan(
                                            text: i.entries.elementAt(3).value.toString(),
                                            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold))
                                      ])),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: RichText(
                                      overflow: TextOverflow.ellipsis,
                                      text: TextSpan(children: [
                                        TextSpan(
                                            text: i.entries.elementAt(2).key.toLowerCase().contains('date') ?
                                            DateFormat.yMMMMEEEEd().format(DateTime.parse(i.entries.elementAt(2).value.toString()).toLocal())
                                            : i.entries.elementAt(2).value.toString(),
                                            style: TextStyle(color: Colors.black))
                                      ])),
                                ),
                              ],
                            ),
                            subtitle: Row(
                              children: [
                                Expanded(
                                  child: RichText(
                                      overflow: TextOverflow.ellipsis,
                                      text: TextSpan(children: [
                                        TextSpan(
                                            text: i.entries.elementAt(0).key.toString() + " :",
                                            style: TextStyle(color: Colors.grey[700])),
                                        TextSpan(
                                            text: i.entries.elementAt(0).value.toString(),
                                            style: TextStyle(color: Colors.black))
                                      ])),
                                ),
                                Expanded(
                                  child: RichText(
                                      overflow: TextOverflow.ellipsis,
                                      text: TextSpan(children: [
                                        TextSpan(
                                            text: i.entries.elementAt(1).key.toString() + " :",
                                            style: TextStyle(color: Colors.grey[700])),
                                        TextSpan(
                                            text: i.entries.elementAt(1).value.toString(),
                                            style: TextStyle(color: Colors.black))
                                      ])),
                                ),
                              ],
                            ),
                          ))
                              .toList());
                    }
                    else{
                      return Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Center(child: Container(child: Text('No Data Found'))),
                      );
                    }
                  },
                ),
              ),
        ),
      ),
    );
  }

  Widget shimmerEffectUIWidget() => ListTile(
        leading: MyShimmerEffectUI.circular(height: 64, width: 64),
        title: Align(
          alignment: Alignment.centerLeft,
          child: MyShimmerEffectUI.rectangular(
              height: 16, width: MediaQuery.of(context).size.width * 0.35),
        ),
        subtitle: MyShimmerEffectUI.rectangular(height: 14),
      );
  Widget listViewUI(HashMap<String, dynamic> obj) {
    print(obj);
  return Card(
        elevation: 5,
        child: ListTile(
          // leading: Icon(
          //   FontAwesomeIcons.oilCan,
          //   color: obj.isSync ? Theme.of(context).primaryColor : Colors.orange,
          //   size: 35,
          // ),
          leading: CircleAvatar(
            radius: 25,
            child: Text(obj.entries.elementAt(0).value),
          ),
          title: Text(obj.entries.elementAt(1).value,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          subtitle: Row(
              // crossAxisAlignment: CrossAxisAlignment.start,
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: RichText(
                      overflow: TextOverflow.ellipsis,
                      text: TextSpan(children: [
                        TextSpan(
                            text: obj.entries.elementAt(2).key + " :",
                            style: TextStyle(color: Colors.grey[700])),
                        TextSpan(
                            text: obj.entries.elementAt(2).value.toString(),
                            style: TextStyle(color: Colors.black))
                      ])),
                ),
                Expanded(
                  child: Center(
                    child: RichText(
                        text: TextSpan(children: [
                      TextSpan(
                          text: obj.entries.elementAt(3).key + " :",
                          style: TextStyle(color: Colors.grey[700])),
                      TextSpan(
                          text: obj.entries.elementAt(3).value.toString(),
                          style: TextStyle(color: Colors.black))
                    ])),
                  ),
                ),
              ],
            ),
        ),
      );}
  void callSaleOrderOffline(String query){
    context.read<SaleOrderBloc>().add(GetSaleOrderList(orderType: "0"));
  }
// void callSaleOrderOffline(String query) {
  //   List<SaleOrderState> list = [];
  //   tblSaleOrder = Hive.box<SaleOrderTab>("SaleOrderTab");
  //   if (query.length > 0) {
  //     isShowClose = true;
  //     var filteredList = tblSaleOrder.values
  //         .where((c) => c.nCustomer.customerName!
  //             .toLowerCase()
  //             .contains(query.toLowerCase()))
  //         .toList();
  //     for (int i = 0; i < filteredList.length; i++) {
  //       var cus = filteredList[i].nCustomer;
  //       CustomerState cs = CustomerState(
  //           customerCode: cus.customerCode ?? '',
  //           customerName: cus.customerName ?? '',
  //           phoneNo: cus.phoneNo ?? '',
  //           mobileNo: cus.mobileNo ?? '',
  //           address: cus.address ?? '',
  //           email: cus.emailId ?? '',
  //           cnic: cus.cnicNo ?? '',
  //           city: cus.city ?? '',
  //           isSync: cus.isSync);
  //       SaleOrderState sos = SaleOrderState(
  //           billDate: filteredList[i].nBillDate,
  //           description: filteredList[i].nDescription,
  //           customer: cs,
  //           salesManTab: filteredList[i].nSalesMan,
  //           listProducts: filteredList[i].nProductList,
  //           totalQuantity: filteredList[i].nTotalQuantity,
  //           totalItems: filteredList[i].nTotalItems,
  //           netAmount: filteredList[i].nNetAmount);
  //       list.add(sos);
  //     }
  //   } else {
  //     isShowClose = false;
  //     for (int i = 0; i < tblSaleOrder.length; i++) {
  //       var cus = tblSaleOrder.getAt(i)?.nCustomer;
  //       CustomerState cs = CustomerState(
  //           customerCode: cus!.customerCode ?? '',
  //           customerName: cus!.customerName ?? '',
  //           phoneNo: cus.phoneNo ?? '',
  //           mobileNo: cus.mobileNo ?? '',
  //           address: cus.address ?? '',
  //           email: cus.emailId ?? '',
  //           cnic: cus?.cnicNo ?? '',
  //           city: cus?.city ?? '',
  //           isSync: cus.isSync);
  //       SaleOrderState sos = SaleOrderState(
  //           billDate: tblSaleOrder.getAt(i)!.nBillDate,
  //           description: tblSaleOrder.getAt(i)!.nDescription,
  //           customer: cs,
  //           salesManTab: tblSaleOrder.getAt(i)!.nSalesMan,
  //           listProducts: tblSaleOrder.getAt(i)!.nProductList,
  //           totalQuantity: tblSaleOrder.getAt(i)!.nTotalQuantity,
  //           totalItems: tblSaleOrder.getAt(i)!.nTotalItems,
  //           netAmount: tblSaleOrder.getAt(i)!.nNetAmount);
  //       list.add(sos);
  //     }
  //   }
  //   context.read<SaleOrderBloc>().add(GetSaleOrderListOffline(list: list));
  // }
  // showSync(BuildContext context) {
  //   FocusManager.instance.primaryFocus?.unfocus();
  //   Alert(
  //       context: context,
  //       style: AlertStyle(isCloseButton: false),
  //       type: AlertType.warning,
  //       title: "Sync",
  //       content: Text(
  //         "Offline Orders are about to sync. Are you sure you want to upload?",
  //         style: TextStyle(fontSize: 14),
  //       ),
  //       buttons: [
  //         DialogButton(
  //           child: Text("No", style: TextStyle(color: Colors.white)),
  //           color: Colors.grey[800],
  //           onPressed: () {
  //             Navigator.of(context, rootNavigator: true).pop();
  //           },
  //         ),
  //         DialogButton(
  //           child: Text("Yes", style: TextStyle(color: Colors.white)),
  //           color: Theme.of(context).primaryColor,
  //           onPressed: () async {
  //             Navigator.of(context, rootNavigator: true).pop();
  //             final bloc = BlocProvider.of<SaleOrderBloc>(context);
  //             await bloc.syncOrders();
  //             _pullRefresh();
  //             // final loginBloc = BlocProvider.of<SessionCubit>(context);
  //             // loginBloc.signOUt();
  //           },
  //         ),
  //       ]).show();
  // }
}
