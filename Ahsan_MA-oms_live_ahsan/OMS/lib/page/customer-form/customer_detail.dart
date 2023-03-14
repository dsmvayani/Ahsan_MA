import 'package:BSProOMS/page/customer-form/cubit/customer_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../../model/Customer.dart';
import 'cubit/customer_bloc.dart';
import 'cubit/customer_event.dart';

class CustomerDetail extends StatelessWidget {
  final CustomerState obj;
  const CustomerDetail({Key? key, required this.obj}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(obj.customerName),
      ),
      body: SingleChildScrollView(
        child: BlocBuilder<CustomerBloc, CustomerState>( builder: (context, state){
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 6.0),
                  child: RichText(
                      text: TextSpan(children: [
                    WidgetSpan(
                      child: Transform.translate(
                          offset: const Offset(0.0, -1.0),
                          child: Text("Customer Name :  ",
                              style:
                                  TextStyle(color: Colors.grey[700], fontSize: 14))),
                    ),
                    TextSpan(
                        text: obj.customerName,
                        style: TextStyle(color: Colors.black, fontSize: 18))
                  ])),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 6.0),
                  child: RichText(
                      text: TextSpan(children: [
                    WidgetSpan(
                      child: Transform.translate(
                          offset: const Offset(0.0, -1.0),
                          child: Text("CNIC :  ",
                              style:
                                  TextStyle(color: Colors.grey[700], fontSize: 14))),
                    ),
                    TextSpan(
                        text: obj.cnic.isNotEmpty ? obj.cnic : '-',
                        style: TextStyle(color: Colors.black, fontSize: 18))
                  ])),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 6.0),
                  child: RichText(
                      text: TextSpan(children: [
                    WidgetSpan(
                      child: Transform.translate(
                          offset: const Offset(0.0, -1.0),
                          child: Text("Mobile No :  ",
                              style:
                                  TextStyle(color: Colors.grey[700], fontSize: 14))),
                    ),
                    TextSpan(
                        text: obj.mobileNo.isNotEmpty ? obj.mobileNo : '-',
                        style: TextStyle(color: Colors.black, fontSize: 18))
                  ])),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 6.0),
                  child: RichText(
                      text: TextSpan(children: [
                    WidgetSpan(
                      child: Transform.translate(
                          offset: const Offset(0.0, -1.0),
                          child: Text("Phone No :  ",
                              style:
                                  TextStyle(color: Colors.grey[700], fontSize: 14))),
                    ),
                    TextSpan(
                        text: obj.phoneNo.isNotEmpty ? obj.phoneNo : '-',
                        style: TextStyle(color: Colors.black, fontSize: 18))
                  ])),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 6.0),
                  child: RichText(
                      text: TextSpan(children: [
                    WidgetSpan(
                      child: Transform.translate(
                          offset: const Offset(0.0, -1.0),
                          child: Text("Email :  ",
                              style:
                                  TextStyle(color: Colors.grey[700], fontSize: 14))),
                    ),
                    TextSpan(
                        text: obj.email.isNotEmpty ? obj.email : '-',
                        style: TextStyle(color: Colors.black, fontSize: 18))
                  ])),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 6.0),
                  child: RichText(
                      text: TextSpan(children: [
                    WidgetSpan(
                      child: Transform.translate(
                          offset: const Offset(0.0, -1.0),
                          child: Text("City :  ",
                              style:
                                  TextStyle(color: Colors.grey[700], fontSize: 14))),
                    ),
                    TextSpan(
                        text: obj.city.isNotEmpty ? obj.city : '-',
                        style: TextStyle(color: Colors.black, fontSize: 18))
                  ])),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 6.0),
                  child: RichText(
                    textAlign: TextAlign.justify,
                      text: TextSpan(children: [
                    WidgetSpan(
                      child: Transform.translate(
                          offset: const Offset(0.0, -1.0),
                          child: Text("Address :  ",
                              style:
                                  TextStyle(color: Colors.grey[700], fontSize: 14))),
                    ),
                    TextSpan(
                        text: obj.address.isNotEmpty ? obj.address : '-',
                        style: TextStyle(color: Colors.black, fontSize: 18))
                  ])),
                ),
                const SizedBox(height: 10),
          !obj.isSync ? ElevatedButton(
            style: ElevatedButton.styleFrom(
                primary: Theme.of(context).primaryColor,
                minimumSize: const Size.fromHeight(50),
                padding: EdgeInsetsDirectional.all(15),
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(10))),
            onPressed: () {
              deleteCustomer(context, obj);
            },
            child: Text(
              'DELETE',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
          ) : Container(),
                const SizedBox(height: 10)
              ],
            ),
          );}
        ),
      ),
    );
  }
  deleteCustomer(BuildContext context, CustomerState obj) {
    Alert(
        context: context,
        style: AlertStyle(isCloseButton: false),
        type: AlertType.warning,
        title: "Delete "+obj.customerName,
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
              Box<Customer> tblCustomer = Hive.box<Customer>("Customer");
              List<Customer> deleteList = tblCustomer.values.where((element) => element.mobileNo == obj.mobileNo && element.cnicNo == obj.cnic).toList();
              if(deleteList != null && deleteList.isNotEmpty){
                deleteList.first.delete();
                List<CustomerState> list = tblCustomer.values.map((e) => CustomerState(
                    customerCode: e.customerCode  ?? '',
                  customerName: e.customerName  ?? '',
                  mobileNo: e.mobileNo  ?? '',
                  cnic: e.cnicNo  ?? '',
                  phoneNo: e.phoneNo  ?? '',
                  email: e.emailId  ?? '',
                  address: e.address  ?? '',
                  isSync: e.isSync,
                  city: e.city ?? ''
                )).toList();
                context.read<CustomerBloc>().add(GetCustomerListOffline(list: list));
                Navigator.pop(context);
              }
              else{
                Navigator.pop(context);
              }
            },
          ),
        ]).show();
  }
}
