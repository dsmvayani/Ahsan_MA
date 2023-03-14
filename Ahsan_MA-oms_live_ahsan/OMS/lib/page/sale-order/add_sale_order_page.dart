import 'dart:async';

import 'package:BSProOMS/model/City.dart';
import 'package:BSProOMS/model/Customer.dart';
import 'package:BSProOMS/model/Product.dart';
import 'package:BSProOMS/model/SaleOrderTab.dart';
import 'package:BSProOMS/page/sale-order/sale_order_list.dart';
import 'package:BSProOMS/widget/CustomerLookup.dart';
import 'package:BSProOMS/widget/ProductLookup.dart';
import 'package:BSProOMS/widget/SalesmanLookup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:multi_select_flutter/chip_display/multi_select_chip_display.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:multi_select_flutter/util/multi_select_list_type.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:sizer/sizer.dart';
import '../../auth/form_submission_status.dart';
// import 'package:flutter_masked_text/flutter_masked_text.dart';

import '../../data/Constants.dart';
import '../../model/SalesManTab.dart';
import '../customer-form/cubit/customer_state.dart';
import 'cubit/sale_order_bloc.dart';
import 'cubit/sale_order_event.dart';
import 'cubit/sale_order_state.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class AddSaleOrder extends StatefulWidget {
  bool isEdit = false;
  AddSaleOrder({Key? key, required this.isEdit}) : super(key: key);

  @override
  State<AddSaleOrder> createState() => _AddSaleOrderState();
}

class _AddSaleOrderState extends State<AddSaleOrder> {
  final _formKey = GlobalKey<FormState>();
  List<Product> list = [];
  TextEditingController _billDateController =
      new TextEditingController(text: "");
  TextEditingController _customerController =
      new TextEditingController(text: "");
  TextEditingController descriptionController =
      new TextEditingController(text: "");
  DateTime selectedDate = DateTime.now();
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2015, 1),
      lastDate: DateTime(2050),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: MyConstants.of(context)!
                  .primaryColor, // header background color
              onPrimary: Colors.white, // header text color
              onSurface:
                  MyConstants.of(context)!.primaryColor, // body text color
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                primary:
                    MyConstants.of(context)!.primaryColor, // button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedDate) {
      String date = picked.toLocal().toString().split(' ')[0];
      context.read<SaleOrderBloc>().add(BillDateChanged(billDate: date));
      _billDateController.text = date;
    }
  }

  Timer? _debounce;
  @override
  void initState() {
    super.initState();
    if (widget.isEdit) {
      var a = widget.isEdit;
      context.read<SaleOrderBloc>().add(EditOrder());
    } else {
      String now = DateTime.now().toLocal().toString().split(' ')[0];
      context.read<SaleOrderBloc>().add(BillDateChanged(billDate: now));
      _billDateController.text = now;
      context.read<SaleOrderBloc>().add(RefreshSaleOrder());
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // resizeToAvoidBottomInset: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: MyConstants.of(context)!.primaryColor,
        title: Text('Add Sale Order'),
      ),
      body: SafeArea(
        child: BlocBuilder<SaleOrderBloc, SaleOrderState>(
          builder: (context, state) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: BlocListener<SaleOrderBloc, SaleOrderState>(
                  listener: (context, state) {
                    final formStatus = state.formStatus;
                    if (formStatus is SubmissionFailed) {
                      _showSnackBar(context, formStatus.exception.toString());
                    }
                  },
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        const SizedBox(height: 15),
                        // TextFormField(
                        //   readOnly: true,
                        //   controller: _billDateController,
                        //   onTap: () {
                        //     _selectDate(context);
                        //   },
                        //   decoration: InputDecoration(
                        //       // contentPadding: EdgeInsets.only(top: 10),
                        //       isDense: true,
                        //       labelText: "Bill Date",
                        //       labelStyle: TextStyle(color: MyConstants.of(context)!.primaryColor),
                        //       focusColor: MyConstants.of(context)!.primaryColor,
                        //       focusedBorder: OutlineInputBorder(
                        //         borderSide: BorderSide(
                        //             color: MyConstants.of(context)!.secondaryColor),
                        //       ),
                        //       enabledBorder: OutlineInputBorder(
                        //           borderSide: BorderSide(width: 0.0, color: MyConstants.of(context)!.secondaryColor)),
                        //       border: OutlineInputBorder(),
                        //       prefixIcon: IconTheme(
                        //           data: IconThemeData(
                        //               color: MyConstants.of(context)!.primaryColor),
                        //           child: Icon(FontAwesomeIcons.calendarAlt))),
                        // ),
                        const SizedBox(height: 15),
                        TextFormField(
                          validator: (value) {
                            return state.listProducts!.length > 0
                                ? null
                                : 'Please select item(s) first';
                          },
                          controller: _customerController,
                          readOnly: true,
                          onTap: () async {
                            List<Product> objList = await showDialog(
                              context: context,
                              builder: (_) => ProductLookup(),
                            );
                            if (objList != null && objList.length > 0) {
                              List<Product> aList = objList;
                              context
                                  .read<SaleOrderBloc>()
                                  .add(GetProductLookup(list: aList));
                              // context.read<SaleOrderBloc>().add(RefreshSaleOrder());
                              // _customerController.text = objList.map((e) => e.nBarCode).join(', ');
                            }
                          },
                          decoration: InputDecoration(
                              isDense: true,
                              labelText: "Item Lookup",
                              labelStyle: TextStyle(
                                  color: MyConstants.of(context)!.primaryColor),
                              focusColor: MyConstants.of(context)!.primaryColor,
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: MyConstants.of(context)!
                                        .secondaryColor),
                              ),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 0.0,
                                      color: MyConstants.of(context)!
                                          .secondaryColor)),
                              border: OutlineInputBorder(),
                              prefixIcon: IconTheme(
                                  data: IconThemeData(
                                      color: MyConstants.of(context)!
                                          .primaryColor),
                                  child: Icon(FontAwesomeIcons.userAlt))),
                        ),
                        const SizedBox(height: 15),
                        TextFormField(
                          controller: descriptionController,
                          onChanged: (value) {
                            context
                                .read<SaleOrderBloc>()
                                .add(DescriptionChanged(desc: value));
                          },
                          decoration: InputDecoration(
                              isDense: true,
                              labelText: "Remarks",
                              labelStyle: TextStyle(
                                  color: MyConstants.of(context)!.primaryColor),
                              focusColor: MyConstants.of(context)!.primaryColor,
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: MyConstants.of(context)!
                                        .secondaryColor),
                              ),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(width: 0.0)),
                              border: OutlineInputBorder(),
                              prefixIcon: IconTheme(
                                  data: IconThemeData(
                                      color: MyConstants.of(context)!
                                          .primaryColor),
                                  child: Icon(FontAwesomeIcons.solidComments))),
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                        ),
                        const SizedBox(height: 20),
                        state.listProducts!.length > 0
                            ? SizedBox(
                                height: 50.0.h,
                                child: ListView.builder(
                                    itemCount: state.listProducts!.length,
                                    itemBuilder: (context, index) {
                                      Product p = state.listProducts![index];
                                      var textEditingController =
                                          new TextEditingController(
                                              text: p.nQuantity
                                                  .round()
                                                  .toString());
                                      return Slidable(
                                        // The end action pane is the one at the right or the bottom side.
                                        endActionPane: ActionPane(
                                          motion: ScrollMotion(),
                                          children: [
                                            SlidableAction(
                                              // An action can be bigger than the others.
                                              flex: 2,
                                              onPressed:
                                                  (BuildContext context) {
                                                state.listProducts!.remove(p);
                                                context
                                                    .read<SaleOrderBloc>()
                                                    .add(ProductsChanged(
                                                        list: state
                                                            .listProducts!));
                                              },
                                              backgroundColor: Colors.red,
                                              foregroundColor: Colors.white,
                                              icon:
                                                  Icons.delete_forever_rounded,
                                              label: 'Delete',
                                            ),
                                          ],
                                        ),
                                        child: ListTile(
                                          title: Row(
                                            children: [
                                              Expanded(
                                                  child: Text(p.nBarCode +
                                                      ' | ' +
                                                      p.nAttribute +
                                                      ' | ' +
                                                      p.nAmount.toString())),
                                              p.nQuantity > 1
                                                  ? new IconButton(
                                                      icon: new Icon(
                                                        Icons.remove,
                                                        color: MyConstants.of(
                                                                context)!
                                                            .primaryColor,
                                                      ),
                                                      onPressed: () {
                                                        setState(() {
                                                          p.nQuantity--;
                                                        });
                                                        setState(() {
                                                          p.nAmount =
                                                              p.nQuantity *
                                                                  p.nSalesRate;
                                                        });
                                                        context
                                                            .read<
                                                                SaleOrderBloc>()
                                                            .add(ProductsChanged(
                                                                list: state
                                                                    .listProducts!));
                                                      })
                                                  : new Container(),
                                              SizedBox(
                                                  width: 50,
                                                  child: TextFormField(
                                                    keyboardType:
                                                        TextInputType.number,
                                                    controller:
                                                        textEditingController,
                                                    decoration: InputDecoration(
                                                      enabledBorder:
                                                          UnderlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: MyConstants
                                                                    .of(context)!
                                                                .primaryColor),
                                                      ),
                                                      focusedBorder:
                                                          UnderlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: MyConstants
                                                                    .of(context)!
                                                                .primaryColor),
                                                      ),
                                                    ),
                                                    onTap: () =>
                                                        textEditingController
                                                                .selection =
                                                            TextSelection(
                                                                baseOffset: 0,
                                                                extentOffset:
                                                                    textEditingController
                                                                        .value
                                                                        .text
                                                                        .length),
                                                    onChanged: (text) {
                                                      if (double.parse(text) <
                                                          1) {
                                                        text = "1";
                                                      }
                                                      if (_debounce?.isActive ??
                                                          false)
                                                        _debounce!.cancel();
                                                      _debounce = Timer(
                                                          const Duration(
                                                              seconds: 5), () {
                                                        // do something with query
                                                        setState(() {
                                                          p.nQuantity =
                                                              double.parse(
                                                                  text);
                                                        });
                                                        setState(() {
                                                          p.nAmount =
                                                              p.nQuantity *
                                                                  p.nSalesRate;
                                                        });
                                                        context
                                                            .read<
                                                                SaleOrderBloc>()
                                                            .add(ProductsChanged(
                                                                list: state
                                                                    .listProducts!));
                                                      });
                                                    },
                                                  )),
                                              new IconButton(
                                                  icon: new Icon(Icons.add,
                                                      color: MyConstants.of(
                                                              context)!
                                                          .primaryColor),
                                                  onPressed: () {
                                                    setState(() {
                                                      p.nQuantity++;
                                                    });
                                                    setState(() {
                                                      p.nAmount = p.nQuantity *
                                                          p.nSalesRate;
                                                    });
                                                    context
                                                        .read<SaleOrderBloc>()
                                                        .add(ProductsChanged(
                                                            list: state
                                                                .listProducts!));
                                                  }),
                                            ],
                                          ),
                                          // subtitle: Text(p.nAmount),
                                        ),
                                      );
                                    }))
                            : const SizedBox(height: 20),
                        Row(
                            // mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                  child: Center(
                                      child: Text(
                                          'Total Items: ' +
                                              state.totalItems.toStringAsFixed(0),
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold)))),
                              Expanded(
                                  child: Center(
                                      child: Text(
                                          'Total Quantity: ' +
                                              state.totalQuantity.toStringAsFixed(0),
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold)))),
                              Expanded(
                                  child: Center(
                                      child: Text(
                                          'Net Amount: ' +
                                              state.netAmount.toStringAsFixed(0),
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold))))
                            ]),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(flex: 45, child: _saveButton()),
                            Expanded(flex: 5, child: const SizedBox(width: 5)),
                            Expanded(
                                flex: 45,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      primary:
                                          MyConstants.of(context)!.primaryColor,
                                      minimumSize: const Size.fromHeight(50),
                                      padding: EdgeInsetsDirectional.all(15),
                                      shape: new RoundedRectangleBorder(
                                          borderRadius:
                                              new BorderRadius.circular(10))),
                                  onPressed: () async {
                                    Alert(
                                        context: context,
                                        style: AlertStyle(
                                            isCloseButton: false,
                                            titleStyle: TextStyle(
                                                fontWeight: FontWeight.bold)),
                                        type: AlertType.warning,
                                        title: "Do you want to reset it?",
                                        buttons: [
                                          DialogButton(
                                            child: Text("No",
                                                style: TextStyle(
                                                    color: Colors.white)),
                                            color: Colors.grey[800],
                                            onPressed: () {
                                              Navigator.of(context,
                                                      rootNavigator: true)
                                                  .pop();
                                            },
                                          ),
                                          DialogButton(
                                            child: Text("Yes",
                                                style: TextStyle(
                                                    color: Colors.white)),
                                            color: MyConstants.of(context)!
                                                .primaryColor,
                                            onPressed: () {
                                              context
                                                  .read<SaleOrderBloc>()
                                                  .add(RefreshSaleOrder());
                                              descriptionController.text = "";
                                              Navigator.of(context,
                                                      rootNavigator: true)
                                                  .pop();
                                            },
                                          ),
                                        ]).show();
                                  },
                                  child: Text(
                                    'RESET',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                )),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Widget _saveButton() {
    return BlocBuilder<SaleOrderBloc, SaleOrderState>(
      builder: (context, state) {
        return state.formStatus is FormSubmitting
            ? CircularProgressIndicator(
                color: MyConstants.of(context)!.primaryColor,
              )
            : ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: MyConstants.of(context)!.primaryColor,
                    minimumSize: const Size.fromHeight(50),
                    padding: EdgeInsetsDirectional.all(15),
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(10))),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    context
                        .read<SaleOrderBloc>()
                        .add(ProductsChanged(list: state.listProducts!));
                    context.read<SaleOrderBloc>().add(StartLoading());
                    await Future.delayed(Duration(seconds: 2));
                    final bloc = BlocProvider.of<SaleOrderBloc>(context);
                    bool result = await bloc.isSaveOrder();
                    context.read<SaleOrderBloc>().add(StopLoading());
                    if (result) {
                      Navigator.pop(context);
                    } else {
                      EasyLoading.showError("Failed to Save",
                          duration: const Duration(milliseconds: 1000));
                    }
                  }
                },
                child: Text(
                  state.isEdit == 0 ?
                  'SAVE' : 'UPDATE',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              );
      },
    );
  }
}
