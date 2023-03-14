import 'package:BSProOMS/model/City.dart';
import 'package:BSProOMS/model/Customer.dart';
import 'package:BSProOMS/page/customer-form/cubit/customer_bloc.dart';
import 'package:BSProOMS/page/customer-form/cubit/customer_event.dart';
import 'package:BSProOMS/page/customer-form/cubit/customer_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../../auth/form_submission_status.dart';

class AddCustomer extends StatefulWidget {
  // final VoidCallback openDrawer;
  AddCustomer({Key? key}) : super(key: key);

  @override
  State<AddCustomer> createState() => _AddCustomerState();
}

class _AddCustomerState extends State<AddCustomer> {
  final _formKey = GlobalKey<FormState>();
  late Box<Customer> tblCustomer;
  late Box<City> tblCity;
  @override
  void initState() {
    super.initState();
    tblCustomer = Hive.box<Customer>("Customer");
    tblCity = Hive.box<City>("City");
    BlocProvider.of<CustomerBloc>(context).add(CustomerCityChanged(city: ''));
  }

  // var _currencies = ['KHI', 'KPK', 'ISB', 'Quetta'];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // resizeToAvoidBottomInset: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        title: Text('Add Customer'),
      ),
      body: SafeArea(
        child: BlocBuilder<CustomerBloc, CustomerState>(
          builder: (context, state) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: BlocListener<CustomerBloc, CustomerState>(
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
                        TextFormField(
                          onChanged: (value) {
                            context
                                .read<CustomerBloc>()
                                .add(CustomerNameChanged(customerName: value));
                          },
                          decoration: InputDecoration(
                              // contentPadding: EdgeInsets.only(top: 10),
                              isDense: true,
                              labelText: "Customer Name",
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(width: 0.0)),
                              border: OutlineInputBorder(),
                              prefixIcon: IconTheme(
                                  data: IconThemeData(
                                      color: Theme.of(context).primaryColor),
                                  child: Icon(FontAwesomeIcons.user))),
                        ),
                        const SizedBox(height: 15),
                        TextFormField(
                            validator: (value) { return state.isValidCNIC ? null : 'CNIC invalid format XXXXX-XXXXXXX-X'; },
                            onChanged: (value) {
                              context
                                  .read<CustomerBloc>()
                                  .add(CustomerCNICChanged(cnic: value));
                            },
                            inputFormatters: [new LengthLimitingTextInputFormatter(15)],
                            decoration: InputDecoration(
                                isDense: true,
                                labelText: "CNIC No",
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(width: 0.0)),
                                border: OutlineInputBorder(),
                                prefixIcon: IconTheme(
                                    data: IconThemeData(
                                        color: Theme.of(context).primaryColor),
                                    child: Icon(
                                        FontAwesomeIcons.digitalTachograph))),
                            keyboardType: TextInputType.number),
                        const SizedBox(height: 15),
                        TextFormField(
                            onChanged: (value) {
                              context
                                  .read<CustomerBloc>()
                                  .add(CustomerPhoneNoChanged(phoneNo: value));
                            },
                            decoration: InputDecoration(
                                isDense: true,
                                labelText: "Phone No",
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(width: 0.0)),
                                border: OutlineInputBorder(),
                                prefixIcon: IconTheme(
                                    data: IconThemeData(
                                        color: Theme.of(context).primaryColor),
                                    child: Icon(FontAwesomeIcons.phone))),
                            keyboardType: TextInputType.phone),
                        const SizedBox(height: 15),
                        TextFormField(
                          validator: (value) { return state.isValidMobile ? null : 'Invalid Mobile format'; },
                            onChanged: (value) {
                              context.read<CustomerBloc>().add(
                                  CustomerMobileNoChanged(mobileNo: value));
                            },
                            decoration: InputDecoration(
                                isDense: true,
                                labelText: "Mobile No",
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(width: 0.0)),
                                border: OutlineInputBorder(),
                                prefixIcon: IconTheme(
                                    data: IconThemeData(
                                        color: Theme.of(context).primaryColor),
                                    child: Icon(FontAwesomeIcons.mobileAlt))),
                            keyboardType: TextInputType.phone),
                        const SizedBox(height: 15),
                        TextFormField(
                          validator: (value) { return state.isValidEmail ? null : 'Invalid Email format'; },
                            onChanged: (value) {
                              context
                                  .read<CustomerBloc>()
                                  .add(CustomerEmailChanged(email: value));
                            },
                            decoration: InputDecoration(
                                isDense: true,
                                labelText: "Email",
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(width: 0.0)),
                                border: OutlineInputBorder(),
                                prefixIcon: IconTheme(
                                    data: IconThemeData(
                                        color: Theme.of(context).primaryColor),
                                    child: Icon(FontAwesomeIcons.at))),
                            keyboardType: TextInputType.emailAddress),
                        const SizedBox(height: 15),
                        InputDecorator(
                          decoration: InputDecoration(
                              labelText: "City",
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(width: 0.0)),
                              border: OutlineInputBorder(),
                              prefixIcon: IconTheme(
                                  data: IconThemeData(
                                      color: Theme.of(context).primaryColor),
                                  child: Icon(Icons.location_city_rounded))),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton(
                              isExpanded: true,
                              isDense: true,
                              value: state.city.isNotEmpty ? state.city : null,
                              iconEnabledColor: Theme.of(context).primaryColor,
                              items: tblCity.values.map((City city) {
                                return DropdownMenuItem<String>(
                                  value: city.cityCode,
                                  child: Text(city.city),
                                );
                              }).toList(),
                              onChanged: (String? value) {
                                if (value != null) {
                                  context.read<CustomerBloc>().add(CustomerCityChanged(city: value));
                                }
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        TextFormField(
                          onChanged: (value) {
                            context
                                .read<CustomerBloc>()
                                .add(CustomerAddressChanged(address: value));
                          },
                          decoration: InputDecoration(
                              isDense: true,
                              labelText: "Address",
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(width: 0.0)),
                              border: OutlineInputBorder(),
                              prefixIcon: IconTheme(
                                  data: IconThemeData(
                                      color: Theme.of(context).primaryColor),
                                  child: Icon(FontAwesomeIcons.addressCard))),
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                        ),
                        const SizedBox(height: 15),
                        _saveButton(),
                        const SizedBox(height: 10),
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
    return BlocBuilder<CustomerBloc, CustomerState>(
      builder: (context, state) {
        return state.formStatus is FormSubmitting
            ? CircularProgressIndicator()
            : ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: Theme.of(context).primaryColor,
                    minimumSize: const Size.fromHeight(50),
                    padding: EdgeInsetsDirectional.all(15),
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(10))),
                onPressed: ()async {
                  if (_formKey.currentState!.validate()) {
                    var tblCustomer = await Hive.box<Customer>("Customer").values.where((element) => element.mobileNo == state.mobileNo);
                    bool saveCustomer = tblCustomer != null && tblCustomer.length > 0 && tblCustomer.toList().first != null ? true : false;
                    if(!saveCustomer){
                      Customer objC = Customer(customerName: state.customerName, cnicNo: state.cnic, phoneNo: state.phoneNo, mobileNo: state.mobileNo,emailId:  state.email, address: state.address, city: state.city, isSync: false);

                      var box = await Hive.openBox<Customer>("Customer");
                      box.add(objC);
                      callCustomerOffline();
                      Navigator.pop(context);
                    }
                    else{
                      EasyLoading.showInfo("Customer already present with " + state.mobileNo,
                          duration: const Duration(milliseconds: 1000));
                    }

                  }
                },
                child: Text(
                  'SAVE',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              );
      },
    );
  }

  void callCustomerOffline() {
    List<CustomerState> list = [];
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
    context.read<CustomerBloc>().add(GetCustomerListOffline(list: list));
  }

  void cityChangeCallback(String? value) {
    print("Yasir is " + value!);
  }
}
