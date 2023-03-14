import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart';

import '../model/Customer.dart';

class CustomerLookup extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => CustomerLookupState();
}

class CustomerLookupState extends State<CustomerLookup>
    with SingleTickerProviderStateMixin {
  int _SelectedIndex = 0;
  late AnimationController controller;
  late Animation<double> scaleAnimation;
  TextEditingController editingController = TextEditingController();
  @override
  void initState() {
    super.initState();
    // callCustomerOffline('');
    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 450));
    scaleAnimation =
        CurvedAnimation(parent: controller, curve: Curves.elasticInOut);

    controller.addListener(() {
      setState(() {});
    });

    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        // child: ScaleTransition(
        //   scale: scaleAnimation,
        //   child: Container(
        //       margin: EdgeInsets.all(20.0),
        //       // padding: EdgeInsets.all(15.0),
        //       width: MediaQuery.of(context).size.width - 10,
        //       height: MediaQuery.of(context).size.height -  80,

        //       decoration: ShapeDecoration(
        //           // color: Color.fromRGBO(41, 167, 77, 10),
        //           color: Colors.white,
        //           shape: RoundedRectangleBorder(
        //               borderRadius: BorderRadius.circular(15.0))),
        //       child: Column(
        //         children: <Widget>[
        //           Padding(
        //             padding: const EdgeInsets.all(8.0),
        //             child: TextField(
        //               onChanged: (value) {
        //                 value.length > 0
        //                     ? callCustomerOffline(value)
        //                     : callCustomerOffline('');
        //               },
        //               controller: editingController,
        //               decoration: InputDecoration(
        //                   labelText: "Search",
        //                   hintText: "Search",
        //                   prefixIcon: Icon(Icons.search),
        //                   suffixIcon: editingController.text.length > 1
        //                       ? IconButton(
        //                       icon: Icon(Icons.close),
        //                       onPressed: () {
        //                         editingController.clear();
        //                         FocusManager.instance.primaryFocus
        //                             ?.unfocus();
        //                         callCustomerOffline(editingController.text);
        //                       })
        //                       : null,
        //                   border: OutlineInputBorder(
        //                       borderRadius:
        //                       BorderRadius.all(Radius.circular(25.0)))),
        //             ),
        //           ),
        //           Expanded(
        //               flex: 20,
        //               child: ListView.builder(
        //                   itemCount: list.length,
        //                   itemBuilder: (context, index) {
        //                     return listViewUI(list[index], index);
        //                   })
        //           ),
        //           Expanded(
        //               flex: 2,
        //               child: Row(
        //                 mainAxisAlignment: MainAxisAlignment.center,
        //                 crossAxisAlignment: CrossAxisAlignment.end,
        //                 children: <Widget>[
        //                   Padding(
        //                     padding: const EdgeInsets.all(10.0),
        //                     child: ButtonTheme(
        //                         height: 35.0,
        //                         minWidth: 110.0,
        //                         child: RaisedButton(
        //                           color: Colors.white,
        //                           shape: RoundedRectangleBorder(
        //                               side: BorderSide(color: Theme.of(context).primaryColor),
        //                               borderRadius: BorderRadius.circular(5.0)),
        //                           splashColor: Colors.white.withAlpha(40),
        //                           child: Text(
        //                             'OK',
        //                             textAlign: TextAlign.center,
        //                             style: TextStyle(
        //                                 color: Theme.of(context).primaryColor,
        //                                 fontWeight: FontWeight.bold,
        //                                 fontSize: 13.0),
        //                           ),
        //                           onPressed: () {
        //                             Navigator.pop(context, list[_SelectedIndex]);
        //                           },
        //                         )),
        //                   ),
        //                   Padding(
        //                       padding: const EdgeInsets.only(
        //                           left: 20.0, right: 10.0, top: 10.0, bottom: 10.0),
        //                       child:  ButtonTheme(
        //                           height: 35.0,
        //                           minWidth: 110.0,
        //                           child: RaisedButton(
        //                             color: Colors.white,
        //                             shape: RoundedRectangleBorder(
        //                                 side: BorderSide(color: Theme.of(context).primaryColor),
        //                                 borderRadius: BorderRadius.circular(5.0)),
        //                             splashColor: Colors.white.withAlpha(40),
        //                             child: Text(
        //                               'Cancel',
        //                               textAlign: TextAlign.center,
        //                               style: TextStyle(
        //                                   color: Theme.of(context).primaryColor,
        //                                   fontWeight: FontWeight.bold,
        //                                   fontSize: 13.0),
        //                             ),
        //                             onPressed: () {
        //                               Navigator.pop(context);
        //                             },
        //                           ))
        //                   ),
        //                 ],
        //               ))
        //         ],
        //       )),
        // ),
      ),
    );
  }
//   Widget listViewUI(CustomerState obj, int index) => Card(
//     child: Ink(
//       color: _SelectedIndex == index ? Theme.of(context).primaryColor.withOpacity(0.3) : Colors.transparent,
//       child: ListTile(
//         onTap: (){
//           setState(() {
//             _SelectedIndex = index;
//           });
//         },
//         leading: Icon(
//           FontAwesomeIcons.userAlt,
//           color: obj.isSync ? Theme.of(context).primaryColor : Colors.orange,
//           size: 35,
//         ),
//         title: Text(obj.customerName,
//             style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
//         subtitle: Column(children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               obj.mobileNo.isNotEmpty
//                   ? RichText(
//                   text: TextSpan(children: [
//                     TextSpan(
//                         text: "Mobile:  ",
//                         style: TextStyle(fontSize: 12, color: Colors.grey[700])),
//                     TextSpan(
//                         text: obj.mobileNo,
//                         style: TextStyle(fontSize: 12, color: Colors.black))
//                   ]))
//                   : Container(),
//               obj.cnic.isNotEmpty
//                   ? Expanded(
//                 child: RichText(
//                     overflow: TextOverflow.ellipsis,
//                     text: TextSpan(children: [
//                       TextSpan(
//                           text: "CNIC:  ",
//                           style: TextStyle(fontSize: 12, color: Colors.grey[700])),
//                       TextSpan(
//                           text: obj.cnic,
//                           style: TextStyle(fontSize: 12, color: Colors.black))
//                     ])),
//               )
//                   : Container(),
//             ],
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               obj.email.isNotEmpty
//                   ? RichText(
//                   overflow: TextOverflow.ellipsis,
//                   text: TextSpan(children: [
//                     TextSpan(
//                         text: "Email:  ",
//                         style: TextStyle(fontSize: 12, color: Colors.grey[700])),
//                     TextSpan(
//                         text: obj.email,
//                         style: TextStyle(fontSize: 12, color: Colors.black))
//                   ]))
//                   : Container(),
//               obj.city.isNotEmpty
//                   ? RichText(
//                   text: TextSpan(children: [
//                     TextSpan(
//                         text: "City:  ",
//                         style: TextStyle(fontSize: 12, color: Colors.grey[700])),
//                     TextSpan(
//                         text: obj.city,
//                         style: TextStyle(fontSize: 12, color: Colors.black))
//                   ]))
//                   : Container(),
//             ],
//           ),
//         ]),
//       ),
//     ),
//   );
//   void callCustomerOffline(String query) {
//     // List<CustomerState> list = [];
//     Box<Customer> tblCustomer = Hive.box<Customer>("Customer");
//     list = [];
//     if (query.length > 0) {
//       var filteredList = tblCustomer.values
//           .where((c) =>
//           c.customerName!.toLowerCase().contains(query.toLowerCase()))
//           .toList();
//       for (int i = 0; i < filteredList.length; i++) {
//         list.add(CustomerState(
//             customerCode: filteredList[i].customerCode ?? '',
//             customerName: filteredList[i].customerName ?? '',
//             cnic: filteredList[i].cnicNo ?? '',
//             phoneNo: filteredList[i].phoneNo ?? '',
//             mobileNo: filteredList[i].mobileNo ?? '',
//             email: filteredList[i].emailId ?? '',
//             address: filteredList[i].address ?? '',
//             isSync: filteredList[i].isSync,
//             city: filteredList[i].city ?? ''));
//       }
//     } else {
//       for (int i = 0; i < tblCustomer.length; i++) {
//         list.add(CustomerState(
//             customerCode: tblCustomer.getAt(i)?.customerCode ?? '',
//             customerName: tblCustomer.getAt(i)?.customerName ?? '',
//             cnic: tblCustomer.getAt(i)?.cnicNo ?? '',
//             phoneNo: tblCustomer.getAt(i)?.phoneNo ?? '',
//             mobileNo: tblCustomer.getAt(i)?.mobileNo ?? '',
//             email: tblCustomer.getAt(i)?.emailId ?? '',
//             address: tblCustomer.getAt(i)?.address ?? '',
//             isSync: tblCustomer.getAt(i)?.isSync ?? false,
//             city: tblCustomer.getAt(i)?.city ?? ''));
//       }
//     }
//   }
}