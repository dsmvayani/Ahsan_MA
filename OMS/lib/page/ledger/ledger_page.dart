import 'dart:collection';

import 'package:BSProOMS/page/ledger/cubit/ledger_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../auth/form_submission_status.dart';
import '../../data/Constants.dart';
import '../../widget/DrawermenuWidget.dart';
import '../../widget/MyShimmerEffectUI.dart';
import 'cubit/ledger_bloc.dart';
import 'cubit/ledger_state.dart';

class LedgerPage extends StatefulWidget {
  final VoidCallback openDrawer;
  const LedgerPage({Key? key, required this.openDrawer}) : super(key: key);

  @override
  State<LedgerPage> createState() => _LedgerPageState();
}

class _LedgerPageState extends State<LedgerPage> {
  @override
  void initState() {
    super.initState();
    context.read<LedgerBloc>().add(GetLedgerReport());
  }
   Future<void> _pullRefresh() async {
    FocusManager.instance.primaryFocus?.unfocus();
    context.read<LedgerBloc>().add(GetLedgerReport());
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: MyConstants.of(context)!.primaryColor,
          leading: DrawerMenuWidget(
            onClicked: widget.openDrawer,
          ),
          title: Text('Ledger Detail'),
        ),
        body: RefreshIndicator(
        color: MyConstants.of(context)!.primaryColor,
        onRefresh: _pullRefresh,
        child: SafeArea(
        child: BlocBuilder<LedgerBloc, LedgerState>(
          builder: (context, state) {
            return Column(
              children: [
                Text('Display last 30 days ledger', style: TextStyle(color: Colors.redAccent, fontStyle: FontStyle.italic),),
                Expanded(
                  flex: 15,
                  child: ListView.builder(
                      itemCount: state.formStatus is FormSubmitting
                          ? 12
                          : state.nData.length,
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return state.formStatus is FormSubmitting
                            ? shimmerEffectUIWidget()
                            : listViewUI(state.nData[index]);
                      }),
                ),
              ],
            );
          },
        ),
        ),
      ));
  }
  Widget shimmerEffectUIWidget() => ListTile(
        // leading: MyShimmerEffectUI.circular(height: 64, width: 64),
        title: Align(
          alignment: Alignment.centerLeft,
          child: MyShimmerEffectUI.rectangular(
              height: 30),
        ),
        // subtitle: MyShimmerEffectUI.rectangular(height: 14),
      );
       Widget listViewUI(LinkedHashMap<String, dynamic> obj) => Card(
        child: ListTile(
          // title: Text(obj.nAttribute1Code + " - " + obj.nAttribute,
          //     style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          subtitle: DefaultTextStyle.merge(
            style: TextStyle(color: Colors.black54, fontSize: 12),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(flex: 30, child: Text("Account Code")),
                    Expanded(flex: 40, child: Text("Account")),
                    Expanded(flex: 30, child: Text("Amount")),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(flex: 30, child: Text(obj['AccountCode'].toString(),style: TextStyle(fontWeight: FontWeight.bold, color: obj['Amount'] < 0 ? Colors.redAccent : Colors.black54),)),
                    Expanded(flex: 40, child: Text(obj['Account'].toString(),style: TextStyle(fontWeight: FontWeight.bold, color: obj['Amount'] < 0 ? Colors.redAccent : Colors.black54))),
                    Expanded(flex: 30, child: Text(obj['Amount'].toString(),style: TextStyle(fontWeight: FontWeight.bold, color: obj['Amount'] < 0 ? Colors.redAccent : Colors.black54))),
                  ],
                ),
                SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(flex: 30, child: Text("Trans Date")),
                    Expanded(flex: 40, child: Text("V Type Code")),
                    Expanded(flex: 30, child: Text("Voucher")),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Expanded(flex: 33, child: Text(obj['TransDate'].toString(),style: TextStyle(fontWeight: FontWeight.bold))),
                    Expanded(flex: 30, child: Text(DateFormat.yMMMd().format( getDateFormat(obj['TransDate'])),style: TextStyle(fontWeight: FontWeight.bold, color: obj['Amount'] < 0 ? Colors.redAccent : Colors.black54))),
                    Expanded(flex: 40, child: Text(obj['VoucherTypeCode'].toString(),style: TextStyle(fontWeight: FontWeight.bold, color: obj['Amount'] < 0 ? Colors.redAccent : Colors.black54))),
                    Expanded(flex: 30, child: Text(obj['VoucherNo'].toString(),style: TextStyle(fontWeight: FontWeight.bold, color: obj['Amount'] < 0 ? Colors.redAccent : Colors.black54))),
                  ],
                ),
              ],
            ),
          ),
        ),);
              // [

           //  Row(
           //    mainAxisAlignment: MainAxisAlignment.spaceBetween,
           //    children: <Widget>[...getListHeader(obj)],
           //  ),
           //  // Row(
           //  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
           //  //   children: <Widget>[...getListValue(obj)],
           //  // ),
           //  Row(
           //    mainAxisAlignment: MainAxisAlignment.spaceBetween,
           //    children: [
           //      Text((obj[0] as HashMap).keys.first),
           //      Text(obj[1].value.toString()),
           //      Text(obj[2].value.toString()),
           //    ],
           //  ),
           //  Row(
           //    mainAxisAlignment: MainAxisAlignment.spaceBetween,
           //    children: [
           //      Text(obj[3].value.toString()),
           //      Text(obj[4].value.toString()),
           //      Text(obj[5].value.toString()),
           //    ],
           //  ),
           // ]
      //     ),
      //   ),
      // );
  DateTime getDateFormat(dynamic date){
    var raw = date.toString();

    var numeric = raw.split('(')[1].split(')')[0];
    var negative = numeric.contains('-');
    // var parts = numeric.split(negative ? '-' : '+');
    var parts = numeric.split(negative ? '+' : '+');
    var millis = int.parse(parts[0]);
    var local = DateTime.fromMillisecondsSinceEpoch(millis, isUtc: true);
    return local.add(Duration(days: -1));
  }
  List<Widget> getListValue(LinkedHashMap<dynamic, dynamic> obj) {
    List<Widget> childs = [];
    Map v = obj[0];

    obj.forEach((key, value) {
      childs.add(new Text(value.toString()));
    });
    return childs;
  }
  List<Widget> getList(LinkedHashMap<dynamic, dynamic> obj) {
    List<Widget> childs = [];
    for(var i = 0; i < obj.length; i+3){
      var m = obj[i];
      childs.add(
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Expanded(child: Text(map.values.elementAt(0).toString())]),
              // Column(children: [ Text(map.values.elementAt(1).toString())]),
              // Column(children: [ Text(map.values.elementAt(2).toString())]),
        ],
      )
      );
    }
    return childs;
  }
  List<Widget> getListHeader(LinkedHashMap<dynamic, dynamic> obj) {
    List<Widget> childs = [];
    obj.keys.forEach((v) {
      childs.add(new Text(v.toString()));
    });
    return childs;
  }
}
