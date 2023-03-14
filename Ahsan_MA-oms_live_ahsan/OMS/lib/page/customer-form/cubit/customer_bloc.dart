import 'package:BSProOMS/auth/form_submission_status.dart';
import 'package:BSProOMS/repository/customer_repositry.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../model/City.dart';
import '../../../model/Customer.dart';
import 'customer_event.dart';
import 'customer_state.dart';

class CustomerBloc extends Bloc<CustomerEvent, CustomerState> {
  final CustomerRepository customerRepository;

  CustomerBloc({required this.customerRepository}) : super(CustomerState()) {
    on<CustomerEvent>(_onEvent);
  }

  Future<void> _onEvent(
      CustomerEvent event, Emitter<CustomerState> emit) async {
    if (event is CustomerNameChanged) {
      emit(state.copyWith(customerName: event.customerName));
    } else if (event is CustomerCNICChanged) {
      emit(state.copyWith(cnic: event.cnic));
    } else if (event is CustomerPhoneNoChanged) {
      emit(state.copyWith(phoneNo: event.phoneNo));
    } else if (event is CustomerMobileNoChanged) {
      emit(state.copyWith(mobileNo: event.mobileNo));
    } else if (event is CustomerEmailChanged) {
      emit(state.copyWith(email: event.email));
    } else if (event is CustomerCityChanged) {
      emit(state.copyWith(city: event.city));
    } else if (event is CustomerAddressChanged) {
      emit(state.copyWith(address: event.address));
    }
    if (event is SaveCustomer) {
      emit(state.copyWith(formStatus: FormSubmitting()));

      try {
        final Response? response =
            await customerRepository.saveCustomer(event.customer);
        if (response != null) {
          emit(state.copyWith(formStatus: SubmissionSuccess()));
        } else {
          emit(state.copyWith(
              formStatus:
                  SubmissionFailed(new Exception("Saving Customer Failed"))));
        }
      } catch (e) {
        emit(state.copyWith(formStatus: SubmissionFailed(new Exception(e))));
      }
    }
    if (event is GetCustomerList) {
      emit(state.copyWith(formStatus: FormSubmitting()));

      try {
        List<CustomerState> list = [];
        Box<Customer> tblCustomer = Hive.box<Customer>("Customer");
        final Response? response = await customerRepository.getAllCustomers();
        if (response != null) {
          if (response.statusCode == 200) {
            List<Customer> deleteList = tblCustomer.values.where((element) => element.isSync).toList();
            for(int i = 0; i < deleteList.length; i++){
              await deleteList[i].delete();
            }
            var responsejson = response.data;
            for (int i = 0; i < responsejson.length; i++) {
              Map obj = responsejson[i];
              CustomerState cs = state.customerStateFromJson(obj);
              Customer objC = Customer(customerCode: cs.customerCode, customerName: cs.customerName, cnicNo: cs.cnic, phoneNo: cs.phoneNo, mobileNo: cs.mobileNo,emailId:  cs.email, address: cs.address, city: cs.city, isSync: true);

              
              tblCustomer.add(objC);
              // list.add(state.customerStateFromJson(obj));
            }
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
            list.sort((a, b) => a.customerName
                .toString()
                .toLowerCase()
                .compareTo(b.customerName.toString().toLowerCase()));
            emit(state.copyWith(list: list));
          }
          final Response? response1 = await customerRepository.getAllCities();
          if (response1 != null) {
            if (response1.statusCode == 200) {
              var responsejson = response1.data;
              List<City> cityList = [];
              Box<City> tblCity = Hive.box<City>("City");
              tblCity.deleteAll(tblCity.keys);
              for (int i = 0; i < responsejson.length; i++) {
                Map obj = responsejson[i];
                City city = City.cityStateFromJson(obj);
                tblCity.add(city);
              }
              for (int i = 0; i < tblCity.length; i++) {
                City city = City(
                    city: tblCity.getAt(i)?.city ?? '',
                    cityCode: tblCity.getAt(i)?.cityCode ?? '');
                if (city.cityCode.length > 0) {
                  cityList.add(city);
                }
              }
              cityList.sort((a, b) => a.cityCode
                  .toString()
                  .toLowerCase()
                  .compareTo(b.cityCode.toString().toLowerCase()));
              emit(state.copyWith(cityList: cityList));
            }
          }
          emit(state.copyWith(formStatus: SubmissionSuccess()));
        } else {
          emit(state.copyWith(
              formStatus:
                  SubmissionFailed(new Exception("Saving Customer Failed"))));
        }
      } catch (e) {
        emit(state.copyWith(formStatus: SubmissionFailed(new Exception(e))));
      }
    }
    if (event is GetCustomerListOffline) {
      event.list.sort((a, b) => a.customerName
          .toString()
          .toLowerCase()
          .compareTo(b.customerName.toString().toLowerCase()));
      emit(state.copyWith(list: event.list));
    }
  }

   syncCustomers() async {
    EasyLoading.dismiss();
    Box<Customer> tblCustomer = Hive.box<Customer>("Customer");
    List<Customer> list = tblCustomer.values.where((element) => !element.isSync).toList();
    if (list.length > 0) {
      EasyLoading.show(status: "Uploading");
      String alreadyCreated = "";
      for (int i = 0; i < list.length; i++) {
        try {
          Customer cc = list[i];
          final Response? response = await customerRepository.saveCustomer(cc);
          if (response != null) {
            if(response.statusCode == 201){
              alreadyCreated += cc.mobileNo! + " ";
              cc.delete();
            }
            else if (response.statusCode == 200) {
              cc.delete();
            }

          }
        } catch (e) {
          EasyLoading.dismiss();
        }
      }
      String warning = alreadyCreated.length > 0 ? " These duplicate number(s) didn't save "+ alreadyCreated : '';
      String msg = "Customers uploaded successfully!"+warning;
      EasyLoading.showSuccess(msg,duration: const Duration(milliseconds: 1000));
      // EasyLoading.show(status: msg, );
      // EasyLoading.dismiss();
    } else {
      EasyLoading.showInfo("No customers found to upload",
          duration: const Duration(milliseconds: 3000));
      // EasyLoading.show(status: "No customers found to upload");
      // EasyLoading.dismiss();
    }

    // authRepo.logOut();
    // emit(Unauthenticated());
  }
}
