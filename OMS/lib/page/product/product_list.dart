import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:BSProOMS/data/Constants.dart';
import 'package:BSProOMS/page/product/cubit/product_bloc.dart';
import 'package:BSProOMS/page/product/cubit/product_event.dart';
import 'package:BSProOMS/page/product/cubit/product_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../../auth/form_submission_status.dart';
import '../../widget/DrawermenuWidget.dart';
import '../../widget/MyShimmerEffectUI.dart';

class ProductList extends StatefulWidget {
  final VoidCallback openDrawer;
  ProductList({Key? key, required this.openDrawer}) : super(key: key);

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  TextEditingController editingController = TextEditingController();
  bool isShowClose = false;
  @override
  void initState() {
    super.initState();
    context.read<ProductBloc>().add(GetProductList());
  }

  Future<void> _pullRefresh() async {
    FocusManager.instance.primaryFocus?.unfocus();
    isShowClose = false;
    editingController.text = '';
    context.read<ProductBloc>().add(GetProductList());
    // await Future.delayed(Duration(milliseconds: 1000));
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
        title: Text('Product List'),
        actions: [
          // IconButton(
          //     icon: const Icon(Icons.add),
          //     tooltip: "Open Customer Save",
          //     onPressed: () {
          //       Navigator.of(context)
          //           .push(MaterialPageRoute(builder: (_) => AddCustomer()));
          //     }),
          // Padding(
          //   padding: const EdgeInsets.only(right: 10.0),
          //   child: IconButton(
          //       icon: const Icon(Icons.sync),
          //       tooltip: "Sync Customers",
          //       onPressed: () {
          //         showSync(context);
          //       }),
          // )
        ],
      ),
      body: RefreshIndicator(
        color: MyConstants.of(context)!.primaryColor,
        onRefresh: _pullRefresh,
        child: SafeArea(
          child: BlocBuilder<ProductBloc, ProductState>(
            builder: (context, state) {
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      onChanged: (value) {
                        value.length > 0
                            ? callProductsOffline(value, state.list!, state.list1!)
                            : callProductsOffline('', state.list!, state.list1!);
                      },
                      controller: editingController,
                      decoration: InputDecoration(
                          labelText: "Search",
                          hintText: "Search",
                          prefixIcon: Icon(Icons.search, color: MyConstants.of(context)!.primaryColor,),
                          labelStyle: TextStyle(color: MyConstants.of(context)!.primaryColor),
                          suffixIcon: isShowClose
                              ? IconButton(
                                  icon: Icon(Icons.close),
                                  onPressed: () {
                                    editingController.clear();
                                    FocusManager.instance.primaryFocus
                                        ?.unfocus();
                                    // callCustomerOffline(editingController.text);
                                  })
                              : null,
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(25.0)), borderSide: BorderSide(color: MyConstants.of(context)!.primaryColor)),
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
                          color: MyConstants.of(context)!.primaryColor,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Total Items: " +
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
  Widget listViewUI(ProductState obj) => Card(
        child: ListTile(
          // onTap: () =>
          //     Navigator.push(context, MaterialPageRoute(builder: (context) {
          //   return CustomerDetail(obj: obj);
          // })),
          leading: CircleAvatar(
            radius: 25,
            child: Container(child: obj.nAttribute1Image.length > 1 ? Image.memory(base64Decode(obj.nAttribute1Image)) : Text(obj.nAttribute.substring(0,2)))
          ),
          title: Text(obj.nAttribute1Code + " - " + obj.nAttribute,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          subtitle: Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Barcode: "+obj.nBarcode),
                Text("Sales Rate: "+obj.nSalesRate.toString()),
                // obj.nBarcode.isNotEmpty
                //     ? RichText(
                //         text: TextSpan( children: [
                //         TextSpan(
                //             text: "Barcode:  ",
                //             style: TextStyle(color: Colors.grey[700])),
                //         TextSpan(
                //             text: obj.nBarcode,
                //             style: TextStyle(color: Colors.black))
                //       ]))
                //     : Container(),
                // obj.nSalesRate >= 0
                //     ? Expanded(
                //         child: RichText(
                //             overflow: TextOverflow.ellipsis,
                //             text: TextSpan(children: [
                //               TextSpan(
                //                   text: "Sales Rate:  ",
                //                   style: TextStyle(color: Colors.grey[700])),
                //               TextSpan(
                //                   text: obj.nSalesRate.toString(),
                //                   style: TextStyle(color: Colors.black))
                //             ])),
                //       )
                //     : Container(),
              ],
            ),
           ]),
        ),
      );
  void callProductsOffline(String query, List<ProductState> _list, List<ProductState> _list1) {
    if (query.length > 0) {
      isShowClose = true;
      _list = _list1.where((element) => element.nBarcode.toLowerCase().contains(query.toLowerCase())).toList();
    } else {
      isShowClose = false;
      _list = _list1;
    }
    context.read<ProductBloc>().add(GetProductListOffline(list: _list));
  }

}
