import 'package:BSProOMS/model/SalesManTab.dart';
import 'package:BSProOMS/page/customer-form/cubit/customer_state.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../data/Constants.dart';
import '../model/Customer.dart';

class SalesmanLookup extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SalesmanLookupState();
}

class SalesmanLookupState extends State<SalesmanLookup>
    with SingleTickerProviderStateMixin {
  int _SelectedIndex = 0;
  late AnimationController controller;
  late Animation<double> scaleAnimation;
  List<SalesManTab> list = [];
  TextEditingController editingController = TextEditingController();
  @override
  void initState() {
    super.initState();
    callSalesManOffline('');
    controller = AnimationController(vsync: this, duration: Duration(milliseconds: 450));
    scaleAnimation = CurvedAnimation(parent: controller, curve: Curves.elasticInOut);
    // controller.addListener(() {
    //   setState(() {});
    // });
    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: ScaleTransition(
          scale: scaleAnimation,
          child: Container(
              margin: EdgeInsets.all(20.0),
              // padding: EdgeInsets.all(15.0),
              width: MediaQuery.of(context).size.width - 10,
              height: MediaQuery.of(context).size.height -  80,

              decoration: ShapeDecoration(
                  // color: Color.fromRGBO(41, 167, 77, 10),
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0))),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      onChanged: (value) {
                        value.length > 0
                            ? callSalesManOffline(value)
                            : callSalesManOffline('');
                      },
                      controller: editingController,
                      decoration: InputDecoration(
                          labelText: "Search",
                          hintText: "Search",
                          prefixIcon: Icon(Icons.search),
                          suffixIcon: editingController.text.length > 1
                              ? IconButton(
                              icon: Icon(Icons.close),
                              onPressed: () {
                                editingController.clear();
                                FocusManager.instance.primaryFocus
                                    ?.unfocus();
                                callSalesManOffline(editingController.text);
                              })
                              : null,
                          border: OutlineInputBorder(
                              borderRadius:
                              BorderRadius.all(Radius.circular(25.0)))),
                    ),
                  ),
                  Expanded(
                      flex: 20,
                      child: ListView.builder(
                          itemCount: list.length,
                          itemBuilder: (context, index) {
                            return listViewUI(list[index], index);
                          })
                  ),
                  Expanded(
                      flex: 2,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: ButtonTheme(
                                height: 35.0,
                                minWidth: 110.0,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: MyConstants.of(context)!
                                        .primaryColor,
                                    backgroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                        side: BorderSide(
                                            color: MyConstants.of(context)!
                                                .primaryColor),
                                        borderRadius:
                                        BorderRadius.circular(5.0)),
                                  ),
                                 /* color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      side: BorderSide(color: MyConstants.of(context)!.primaryColor),
                                      borderRadius: BorderRadius.circular(5.0)),
                                  splashColor: Colors.white.withAlpha(40),*/
                                  child: Text(
                                    'OK',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: MyConstants.of(context)!.primaryColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13.0),
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context, list[_SelectedIndex]);
                                  },
                                )),
                          ),
                          Padding(
                              padding: const EdgeInsets.only(
                                  left: 20.0, right: 10.0, top: 10.0, bottom: 10.0),
                              child:  ButtonTheme(
                                  height: 35.0,
                                  minWidth: 110.0,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      foregroundColor: MyConstants.of(context)!
                                          .primaryColor,
                                      backgroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                          side: BorderSide(
                                              color: MyConstants.of(context)!
                                                  .primaryColor),
                                          borderRadius:
                                          BorderRadius.circular(5.0)),
                                    ),
                                    /*color: Colors.white,
                                    shape: RoundedRectangleBorder(
                                        side: BorderSide(color: MyConstants.of(context)!.primaryColor),
                                        borderRadius: BorderRadius.circular(5.0)),
                                    splashColor: Colors.white.withAlpha(40),*/
                                    child: Text(
                                      'Cancel',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: MyConstants.of(context)!.primaryColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13.0),
                                    ),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ))
                          ),
                        ],
                      ))
                ],
              )),
        ),
      ),
    );
  }
  Widget listViewUI(SalesManTab obj, int index) => Card(
    child: Ink(
      color: _SelectedIndex == index ? Theme.of(context).primaryColor.withOpacity(0.3) : Colors.transparent,
      child: ListTile(
        onTap: (){
          setState(() {
            _SelectedIndex = index;
          });
        },
        leading: Container(
          // color: Theme.of(context).primaryColor,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.7),
                border: Border.all(
                  color: Theme.of(context).primaryColor,
                ),
                borderRadius: BorderRadius.all(Radius.circular(50))
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(obj.nShortName, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),),
            ),
        ),
        // leading: Text(obj.nShortName),
        title: Text(obj.nSalesMan, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
      ),
    ),
  );
  void callSalesManOffline(String query) {
    // List<CustomerState> list = [];
    // Box<SalesManTab> tblSalesMan = Hive.box<SalesManTab>("SalesManTab");
    // list = [];
    // if (query.length > 0) {
    //   var filteredList = tblSalesMan.values
    //       .where((c) =>
    //       c.nSalesMan!.toLowerCase().contains(query.toLowerCase()))
    //       .toList();
    //   for (int i = 0; i < filteredList.length; i++) {
    //     list.add(SalesManTab(
    //         nSalesManCode: filteredList[i].nSalesManCode ?? '',
    //         nSalesMan: filteredList[i].nSalesMan ?? '',
    //         nShortName: filteredList[i].nShortName ?? ''));
    //   }
    // } else {
    //   for (int i = 0; i < tblSalesMan.length; i++) {
    //     list.add(SalesManTab(
    //         nSalesManCode: tblSalesMan.getAt(i)?.nSalesManCode ?? '',
    //         nSalesMan: tblSalesMan.getAt(i)?.nSalesMan ?? '',
    //         nShortName: tblSalesMan.getAt(i)?.nShortName ?? ''));
    //   }
    // }
  }
}