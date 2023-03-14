import 'dart:convert';
import 'dart:typed_data';

import 'package:BSProOMS/data/Constants.dart';
import 'package:BSProOMS/model/Product.dart';
import 'package:BSProOMS/repository/sale_order_repositry.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart';

import '../model/Customer.dart';
import '../page/sale-order/cubit/sale_order_bloc.dart';
import '../page/sale-order/cubit/sale_order_event.dart';
import '../page/sale-order/cubit/sale_order_state.dart';

class ProductLookup extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ProductLookupState();
}

class ProductLookupState extends State<ProductLookup>
    with SingleTickerProviderStateMixin {
  List<int> _SelectedIndex = [];
  late AnimationController controller;
  late Animation<double> scaleAnimation;
  bool isLoading = false;
  List<Product> list = [];
  List<Product> originalList = [];
  final ids = Set();
  List<String> _filters = [];
  TextEditingController editingController = TextEditingController();
  @override
  void initState() {
    super.initState();
    callCustomerOffline(true, '');
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
        child: ScaleTransition(
          scale: scaleAnimation,
          child: Container(
              margin: EdgeInsets.all(20.0),
              // padding: EdgeInsets.all(15.0),
              width: MediaQuery.of(context).size.width - 10,
              height: MediaQuery.of(context).size.height - 80,
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
                            ? callCustomerOffline(false, value)
                            : callCustomerOffline(false, '');
                      },
                      controller: editingController,
                      decoration: InputDecoration(
                          labelText: "Search",
                          hintText: "Search",
                          prefixIcon: Icon(
                            Icons.search,
                            color: MyConstants.of(context)!.primaryColor,
                          ),
                          suffixIcon: editingController.text.length > 1
                              ? IconButton(
                                  icon: Icon(Icons.close,
                                      color: MyConstants.of(context)!
                                          .primaryColor),
                                  onPressed: () {
                                    editingController.clear();
                                    FocusManager.instance.primaryFocus
                                        ?.unfocus();
                                    callCustomerOffline(
                                        false, editingController.text);
                                  })
                              : null,
                          labelStyle: TextStyle(
                              color: MyConstants.of(context)!.primaryColor),
                          focusColor: MyConstants.of(context)!.primaryColor,
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: MyConstants.of(context)!.secondaryColor),
                          ),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 0.0,
                                  color:
                                      MyConstants.of(context)!.secondaryColor)),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: MyConstants.of(context)!.primaryColor),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(25.0)))),
                    ),
                  ),
                  SizedBox(
                    height: 70,
                    child: Scrollbar(
                      thickness: 5,
                      thumbVisibility: true,
                      radius: Radius.circular(25),
                      controller: ScrollController(),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10, right: 40),
                          child: Wrap(
                              spacing: 30,
                              children: ids
                                  .map((e) => Transform(
                                        transform: new Matrix4.identity()
                                          ..scale(2.0),
                                        child: FilterChip(
                                            materialTapTargetSize:
                                                MaterialTapTargetSize
                                                    .shrinkWrap,
                                            showCheckmark: true,
                                            selectedColor: Colors.transparent,
                                            checkmarkColor: Colors.white,
                                            avatar: CircleAvatar(
                                                radius: 25,
                                                child: Container(
                                                    child: e.length > 1
                                                        ? Image.memory(
                                                            base64Decode(e),
                                                            width: 500,
                                                            height: 500,
                                                            gaplessPlayback:
                                                                true,
                                                          )
                                                        : Text(''))),
                                            label: Text(''),
                                            backgroundColor: Colors.transparent,
                                            labelPadding:
                                                EdgeInsets.fromLTRB(0, 0, 0, 0),
                                            selected: _filters.contains(e),
                                            onSelected: (bool selected) {
                                              setState(() {
                                                if (selected) {
                                                  _filters.add(e);
                                                } else {
                                                  _filters.removeWhere(
                                                      (String name) {
                                                    return name == e;
                                                  });
                                                }
                                              });
                                              callCustomerOffline(false, '');
                                            }),
                                      ))
                                  .toList()
                                  .toList()),
                        ),
                      ),
                    ),
                  ),
                  isLoading
                      ? CircularProgressIndicator(
                          color: MyConstants.of(context)!.primaryColor)
                      : Expanded(
                          flex: 20,
                          child: ListView.builder(
                              itemCount: list.length,
                              itemBuilder: (context, index) {
                                return listViewUI(list[index], index);
                              })),
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
                                        .primaryColor, backgroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                        side: BorderSide(
                                            color: MyConstants.of(context)!
                                                .primaryColor),
                                        borderRadius:
                                            BorderRadius.circular(5.0)),
                                  ),
                                  /*color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                          color: MyConstants.of(context)!
                                              .primaryColor),
                                      borderRadius: BorderRadius.circular(5.0)),
                                  splashColor: Colors.white.withAlpha(40),*/
                                  child: Text(
                                    'OK',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: MyConstants.of(context)!
                                            .primaryColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13.0),
                                  ),
                                  onPressed: () {
                                    print(_SelectedIndex);
                                    List<Product> filteredList = [];
                                    for (var index in _SelectedIndex) {
                                      filteredList.add(list[index]);
                                    }
                                    Navigator.pop(context, filteredList);
                                  },
                                )),
                          ),
                          Padding(
                              padding: const EdgeInsets.only(
                                  left: 20.0,
                                  right: 10.0,
                                  top: 10.0,
                                  bottom: 10.0),
                              child: ButtonTheme(
                                  height: 35.0,
                                  minWidth: 110.0,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      foregroundColor: MyConstants.of(context)!
                                          .primaryColor, backgroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                          side: BorderSide(
                                              color: MyConstants.of(context)!
                                                  .primaryColor),
                                          borderRadius:
                                          BorderRadius.circular(5.0)),
                                    ),
                                   /* color: Colors.white,
                                    shape: RoundedRectangleBorder(
                                        side: BorderSide(
                                            color: MyConstants.of(context)!
                                                .primaryColor),
                                        borderRadius:
                                            BorderRadius.circular(5.0)),
                                    splashColor: Colors.white.withAlpha(40),*/
                                    child: Text(
                                      'Cancel',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: MyConstants.of(context)!
                                              .primaryColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13.0),
                                    ),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ))),
                        ],
                      ))
                ],
              )),
        ),
      ),
    );
  }

  Widget listViewUI(Product obj, int index) => Card(
        child: Ink(
          color: _SelectedIndex.indexOf(index) >= 0
              ? MyConstants.of(context)!.primaryColor.withOpacity(0.3)
              : Colors.transparent,
          child: ListTile(
            onTap: () {
              setState(() {
                _SelectedIndex.indexOf(index) == -1
                    ? _SelectedIndex.add(index)
                    : _SelectedIndex.remove(index);
              });
            },
            leading: CircleAvatar(
                child: Container(
                    child: obj.nAttribute1Image.length > 1
                        ? Image.memory(
                            base64Decode(obj.nAttribute1Image),
                            gaplessPlayback: true,
                          )
                        : Text(obj.nAttribute.substring(0, 2)))),
            title: Text(obj.nAttribute,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            subtitle: Column(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  obj.nAttribute.isNotEmpty
                      ? RichText(
                          text: TextSpan(children: [
                          TextSpan(
                              text: "Barcode:  ",
                              style: TextStyle(
                                  fontSize: 12, color: Colors.grey[700])),
                          TextSpan(
                              text: obj.nBarCode,
                              style:
                                  TextStyle(fontSize: 12, color: Colors.black))
                        ]))
                      : Container(),
                  RichText(
                      overflow: TextOverflow.ellipsis,
                      text: TextSpan(children: [
                        TextSpan(
                            text: "Sales Rate:  ",
                            style: TextStyle(
                                fontSize: 12, color: Colors.grey[700])),
                        TextSpan(
                            text: obj.nSalesRate.toString(),
                            style: TextStyle(fontSize: 12, color: Colors.black))
                      ])),
                ],
              ),
            ]),
          ),
        ),
      );
  Future<void> callCustomerOffline(bool apiCall, String query) async {
    try {
      this.setState(() {
        this.isLoading = true;
      });
      if (query.length > 0 && _filters.length < 1) {
        this.list = this
            .originalList
            .where((element) => element.nAttribute.contains(query))
            .toList();
      } else if (query.length > 0 && _filters.length > 0) {
        this.list = this
            .originalList
            .where((element) =>
                element.nAttribute
                    .toLowerCase()
                    .contains(query.toLowerCase()) &&
                _filters.contains(element.nAttribute1Image))
            .toList();
      } else if (query.length < 1 && _filters.length > 0) {
        this.list = this
            .originalList
            .where((element) => _filters.contains(element.nAttribute1Image))
            .toList();
      } else if (apiCall) {
        final Response? response =
            await SaleOrderRepository().getProductLookup();
        if (response != null && response.statusCode == 200) {
          var json = jsonDecode(response.data);
          List<Product> list = [];
          for (var item in json) {
            list.add(Product.fromJson(item));
          }

          setState(() {
            this.list = list;
            this.originalList = list;
            List<Product> xList = list.toList();
            xList.retainWhere((x) => ids.add(x.nAttribute1Image));
          });
        }
      } else {
        this.list = this.originalList;
      }
      this.setState(() {
        this.isLoading = false;
      });
    } catch (e) {
      this.setState(() {
        this.isLoading = false;
      });
    }
  }
}
