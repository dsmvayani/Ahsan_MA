import 'dart:async';

import 'package:BSProOMS/model/Customer.dart';
import 'package:BSProOMS/page/customer-form/cubit/customer_bloc.dart';
import 'package:BSProOMS/page/customer-form/cubit/customer_event.dart';
import 'package:BSProOMS/page/customer-form/cubit/customer_state.dart';
import 'package:BSProOMS/page/customer-form/customer_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../../auth/form_submission_status.dart';
import '../../widget/DrawermenuWidget.dart';
import '../../widget/MyShimmerEffectUI.dart';
import 'add_customer_page.dart';

class CustomerList extends StatefulWidget {
  final VoidCallback openDrawer;
  CustomerList({Key? key, required this.openDrawer}) : super(key: key);

  @override
  State<CustomerList> createState() => _CustomerListState();
}

class _CustomerListState extends State<CustomerList> {
  Timer? _timer;
  late Box<Customer> tblCustomer;
  TextEditingController editingController = TextEditingController();
  bool isShowClose = false;
  @override
  void initState() {
    // context.read<CustomerBloc>().add(GetCustomerList());
    super.initState();
    tblCustomer = Hive.box<Customer>("Customer");
    callCustomerOffline('');
    EasyLoading.addStatusCallback((status) {
      if (status == EasyLoadingStatus.dismiss) {
        _timer?.cancel();
      }
    });
  }

  Future<void> _pullRefresh() async {
    FocusManager.instance.primaryFocus?.unfocus();
    isShowClose = false;
    editingController.text = '';
    context.read<CustomerBloc>().add(GetCustomerList());
    // await Future.delayed(Duration(milliseconds: 1000));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // resizeToAvoidBottomInset: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        leading: DrawerMenuWidget(
          onClicked: widget.openDrawer,
        ),
        title: Text('Customer'),
        actions: [
          IconButton(
              icon: const Icon(Icons.add),
              tooltip: "Open Customer Save",
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (_) => AddCustomer()));
              }),
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: IconButton(
                icon: const Icon(Icons.sync),
                tooltip: "Sync Customers",
                onPressed: () {
                  showSync(context);
                }),
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _pullRefresh,
        child: SafeArea(
          child: BlocBuilder<CustomerBloc, CustomerState>(
            builder: (context, state) {
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      onChanged: (value) {
                        value.length > 0
                            ? callCustomerOffline(value)
                            : callCustomerOffline('');
                      },
                      controller: editingController,
                      decoration: InputDecoration(
                          labelText: "Search",
                          hintText: "Search",
                          prefixIcon: Icon(Icons.search),
                          suffixIcon: isShowClose
                              ? IconButton(
                                  icon: Icon(Icons.close),
                                  onPressed: () {
                                    editingController.clear();
                                    FocusManager.instance.primaryFocus
                                        ?.unfocus();
                                    callCustomerOffline(editingController.text);
                                  })
                              : null,
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(25.0)))),
                    ),
                  ),
                  Expanded(
                    flex: 15,
                    child: ListView.builder(
                        itemCount: state.formStatus is FormSubmitting
                            ? 12
                            : state.list!.length,
                        // physics: BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          return state.formStatus is FormSubmitting
                              ? shimmerEffectUIWidget()
                              : listViewUI(state.list![index]);
                        }),
                  ),
                  Expanded(
                      flex: 1,
                      child: Container(
                          width: MediaQuery.of(context).size.width,
                          color: Theme.of(context).primaryColor,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Total Customers: " +
                                    state.list!.length.toString(),
                                style: TextStyle(
                                    color:
                                        Theme.of(context).secondaryHeaderColor,
                                    fontSize: 14),
                              ),
                            ],
                          )))
                ],
              );
            },
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
  Widget listViewUI(CustomerState obj) => Card(
        child: ListTile(
          onTap: () =>
              Navigator.push(context, MaterialPageRoute(builder: (context) {
            return CustomerDetail(obj: obj);
          })),
          leading: Icon(
            FontAwesomeIcons.userTie,
            color: obj.isSync ? Theme.of(context).primaryColor : Colors.orange,
            size: 35,
          ),
          // leading: CircleAvatar(
          //   radius: 25,
          //   // backgroundImage: AssetImage('assets/images/profile_image.png'),
          // ),
          title: Text(obj.customerName,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          subtitle: Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                obj.mobileNo.isNotEmpty
                    ? RichText(
                        text: TextSpan(children: [
                        TextSpan(
                            text: "Mobile:  ",
                            style: TextStyle(color: Colors.grey[700])),
                        TextSpan(
                            text: obj.mobileNo,
                            style: TextStyle(color: Colors.black))
                      ]))
                    : Container(),
                obj.cnic.isNotEmpty
                    ? Expanded(
                        child: RichText(
                            overflow: TextOverflow.ellipsis,
                            text: TextSpan(children: [
                              TextSpan(
                                  text: "CNIC:  ",
                                  style: TextStyle(color: Colors.grey[700])),
                              TextSpan(
                                  text: obj.cnic,
                                  style: TextStyle(color: Colors.black))
                            ])),
                      )
                    : Container(),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                obj.email.isNotEmpty
                    ? RichText(
                        overflow: TextOverflow.ellipsis,
                        text: TextSpan(children: [
                          TextSpan(
                              text: "Email:  ",
                              style: TextStyle(color: Colors.grey[700])),
                          TextSpan(
                              text: obj.email,
                              style: TextStyle(color: Colors.black))
                        ]))
                    : Container(),
                obj.city.isNotEmpty
                    ? RichText(
                        text: TextSpan(children: [
                        TextSpan(
                            text: "City:  ",
                            style: TextStyle(color: Colors.grey[700])),
                        TextSpan(
                            text: obj.city,
                            style: TextStyle(color: Colors.black))
                      ]))
                    : Container(),
              ],
            ),
          ]),
        ),
      );

  void callCustomerOffline(String query) {
    List<CustomerState> list = [];
    if (query.length > 0) {
      isShowClose = true;
      var filteredList = tblCustomer.values
          .where((c) =>
              c.customerName!.toLowerCase().contains(query.toLowerCase()))
          .toList();
      for (int i = 0; i < filteredList.length; i++) {
        list.add(CustomerState(
            customerCode: filteredList[i].customerCode ?? '',
            customerName: filteredList[i].customerName ?? '',
            cnic: filteredList[i].cnicNo ?? '',
            phoneNo: filteredList[i].phoneNo ?? '',
            mobileNo: filteredList[i].mobileNo ?? '',
            email: filteredList[i].emailId ?? '',
            address: filteredList[i].address ?? '',
            isSync: filteredList[i].isSync,
            city: filteredList[i].city ?? ''));
      }
    } else {
      isShowClose = false;
      for (int i = 0; i < tblCustomer.length; i++) {
        list.add(CustomerState(
            customerCode: tblCustomer.getAt(i)?.customerCode ?? '',
            customerName: tblCustomer.getAt(i)?.customerName ?? '',
            cnic: tblCustomer.getAt(i)?.cnicNo ?? '',
            phoneNo: tblCustomer.getAt(i)?.phoneNo ?? '',
            mobileNo: tblCustomer.getAt(i)?.mobileNo ?? '',
            email: tblCustomer.getAt(i)?.emailId ?? '',
            address: tblCustomer.getAt(i)?.address ?? '',
            isSync: tblCustomer.getAt(i)?.isSync ?? false,
            city: tblCustomer.getAt(i)?.city ?? ''));
      }
    }
    context.read<CustomerBloc>().add(GetCustomerListOffline(list: list));
  }

  showSync(BuildContext context) {
    FocusManager.instance.primaryFocus?.unfocus();
    Alert(
        context: context,
        style: AlertStyle(isCloseButton: false),
        type: AlertType.warning,
        title: "Sync",
        content: Text(
          "Offline Customers are about to sync. Are you sure you want to upload?",
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
              final bloc = BlocProvider.of<CustomerBloc>(context);
              await bloc.syncCustomers();
              _pullRefresh();
              // final loginBloc = BlocProvider.of<SessionCubit>(context);
              // loginBloc.signOUt();
            },
          ),
        ]).show();
  }
}
