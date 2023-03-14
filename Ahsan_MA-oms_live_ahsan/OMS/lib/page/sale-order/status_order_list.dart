import 'dart:collection';

import 'package:BSProOMS/page/sale-order/cubit/sale_order_bloc.dart';
import 'package:BSProOMS/page/sale-order/cubit/sale_order_event.dart';
import 'package:BSProOMS/page/sale-order/cubit/sale_order_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../data/Constants.dart';
import '../../widget/MyShimmerEffectUI.dart';

class OrderStatus extends StatefulWidget {
  final String formName;
  final String orderType;
  OrderStatus({Key? key, required this.formName, required this.orderType}) : super(key: key);

  @override
  _OrderStatusState createState() => _OrderStatusState();
}

class _OrderStatusState extends State<OrderStatus> {
  TextEditingController editingController = TextEditingController();
  bool isShowClose = false;
  @override
  void initState() {
    super.initState();
    callOrderStatusOffline('');
  }

  Future<void> _pullRefresh() async {
    FocusManager.instance.primaryFocus?.unfocus();
    isShowClose = false;
    editingController.text = '';
    callOrderStatusOffline('');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: MyConstants.of(context)!.primaryColor,
        title: Text(widget.formName.toString())
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
          leading: CircleAvatar(
            radius: 25,
            child: Text(obj.entries.elementAt(0).value),
          ),
          title: Text(obj.entries.elementAt(1).value,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          subtitle: Row(
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
  void callOrderStatusOffline(String query){
    context.read<SaleOrderBloc>().add(GetSaleOrderList(orderType: widget.orderType));
  }
}
