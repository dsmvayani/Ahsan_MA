import 'package:BSProOMS/model/Customer.dart';
import 'package:BSProOMS/model/Product.dart';
import 'package:BSProOMS/model/SalesManTab.dart';
import 'package:BSProOMS/page/customer-form/cubit/customer_state.dart';
import 'package:dio/dio.dart';
import 'package:hive/hive.dart';

import '../data/SharedPreferencesConfig.dart';
import '../model/City.dart';

class CustomerRepository {

  Future<Response?> saveCustomer(Customer obj) async {
    try {
      var api = await SharedPreferencesConfig.getAPIUrl();
      Dio dio = new Dio();
      dio.options.headers['Authorization'] =
          'Bearer ' + await SharedPreferencesConfig.getToken();
      dio.options.headers['Content-Type'] = 'application/json';
      var json = {
        "Customer": obj.customerName,
        "Address": obj.address,
        "City": obj.city,
        "Phone": obj.phoneNo,
        "MobileNo": obj.mobileNo,
        "EmailId": obj.emailId,
        "CNICNo": obj.cnicNo
      };
      Response response = await dio.post(
          api + "GSAPI/BSProLite/SaveCustomer", data: json);
      return response;
    }
    catch (error) {
      return null;
    }
  }

  Future<Response?> getAllCustomers() async {
    try {
      var api = await SharedPreferencesConfig.getAPIUrl();
      Dio dio = new Dio();
      dio.options.headers['Authorization'] =
          'Bearer ' + await SharedPreferencesConfig.getToken();
      dio.options.headers['Content-Type'] = 'application/json';
      Response response = await dio.get(
          api + "GSAPI/BSProLite/GetAllCustomers");
      return response;
    }
    catch (error) {
      return null;
    }
  }

  Future<Response?> getAllCities() async {
    try {
      var api = await SharedPreferencesConfig.getAPIUrl();
      Dio dio = new Dio();
      dio.options.headers['Authorization'] =
          'Bearer ' + await SharedPreferencesConfig.getToken();
      dio.options.headers['Content-Type'] = 'application/json';
      Response response = await dio.get(api + "GSAPI/BSProLite/GetAllCities");
      return response;
    }
    catch (error) {
      return null;
    }
  }
  Future<Response?> getAllSalesman() async {
    try {
      var api = await SharedPreferencesConfig.getAPIUrl();
      var query = 'Select * from Gen_SalesmanTab';
      Dio dio = new Dio();
      dio.options.headers['Authorization'] =
          'Bearer ' + await SharedPreferencesConfig.getToken();
      dio.options.headers['Content-Type'] = 'application/json';
      Response response = await dio.get(api + "GSAPI/BSProLite/GetQueryRecord?query="+query);
      return response;
    }
    catch (error) {
      return null;
    }
  }
  Future<Response?> getAllProducts() async {
    try {
      var api = await SharedPreferencesConfig.getAPIUrl();
      var query = 'Select * from Inv_ItemTab';
      Dio dio = new Dio();
      dio.options.headers['Authorization'] =
          'Bearer ' + await SharedPreferencesConfig.getToken();
      dio.options.headers['Content-Type'] = 'application/json';
      Response response = await dio.get(api + "GSAPI/BSProLite/GetQueryRecord?query="+query);
      return response;
    }
    catch (error) {
      return null;
    }
  }
  // Future<List<Product>?> syncProducts() async{
  //   try{
  //     final Response? response1 = await getAllProducts();
  //     if (response1 != null) {
  //       if (response1.statusCode == 200) {
  //         var responsejson = response1.data;
  //         List<Product> productList = [];
  //         Box<Product> tblProduct = Hive.box<Product>("Product");
  //         tblProduct.deleteAll(tblProduct.keys);
  //         for (int i = 0; i < responsejson.length; i++) {
  //           Map obj = responsejson[i];
  //           Product product = Product.ProductStateFromJson(obj);
  //           tblProduct.add(product);
  //         }
  //         for (int i = 0; i < tblProduct.length; i++) {
  //           Product product = Product(
  //               nBarCode: tblProduct.getAt(i)?.nBarCode ?? '',
  //               nItem: tblProduct.getAt(i)?.nItem ?? '',
  //               nSalesRate: tblProduct.getAt(i)?.nSalesRate ?? 0,
  //               nQuantity: tblProduct.getAt(i)?.nQuantity ?? 1,
  //               nAmount: tblProduct.getAt(i)?.nAmount ?? 0
  //           );
  //           if (product.nBarCode.length > 0) {
  //             productList.add(product);
  //           }
  //         }
  //         productList.sort((a, b) => a.nItem
  //             .toString()
  //             .toLowerCase()
  //             .compareTo(b.nItem.toString().toLowerCase()));
  //         return productList;
  //       }
  //     }
  //     return null;
  //   }
  //   catch(e){
  //     return null;
  //   }
  // }
  Future<List<SalesManTab>?> syncSalesman() async{
    final Response? response1 = await getAllSalesman();
    if (response1 != null) {
      if (response1.statusCode == 200) {
        var responsejson = response1.data;
        List<SalesManTab> salesmanList = [];
        Box<SalesManTab> tblSalesman = Hive.box<SalesManTab>("SalesManTab");
        tblSalesman.deleteAll(tblSalesman.keys);
        for (int i = 0; i < responsejson.length; i++) {
          Map obj = responsejson[i];
          SalesManTab salesManTab = SalesManTab.SalesManTabStateFromJson(obj);
          tblSalesman.add(salesManTab);
        }
        for (int i = 0; i < tblSalesman.length; i++) {
          SalesManTab salesManTab = SalesManTab(
              nSalesManCode: tblSalesman.getAt(i)?.nSalesManCode ?? '',
              nSalesMan: tblSalesman.getAt(i)?.nSalesMan ?? '',
              nShortName: tblSalesman.getAt(i)?.nShortName ?? '');
          if (salesManTab.nSalesMan.length > 0) {
            salesmanList.add(salesManTab);
          }
        }
        salesmanList.sort((a, b) => a.nSalesMan
            .toString()
            .toLowerCase()
            .compareTo(b.nSalesMan.toString().toLowerCase()));
        return salesmanList;
      }
    }
    return null;
  }
  Future<List<CustomerState>?> syncCustomers() async {
    try{
      List<CustomerState> list = [];
      Box<Customer> tblCustomer = Hive.box<Customer>("Customer");
      final Response? response = await getAllCustomers();
      if (response != null) {
        if (response.statusCode == 200) {
          List<Customer> deleteList = tblCustomer.values.where((
              element) => element.isSync).toList();
          for (int i = 0; i < deleteList.length; i++) {
            await deleteList[i].delete();
          }
          var responsejson = response.data;
          for (int i = 0; i < responsejson.length; i++) {
            Map obj = responsejson[i];
            CustomerState cs = new CustomerState().customerStateFromJson(obj);
            // CustomerState cs = state.customerStateFromJson(obj);
            Customer objC = Customer(customerName: cs.customerName, cnicNo: cs.cnic, phoneNo: cs.phoneNo, mobileNo: cs.mobileNo,emailId:  cs.email, address: cs.address, city: cs.city, isSync: true);


            tblCustomer.add(objC);
          }
          for (int i = 0; i < tblCustomer.length; i++) {
            list.add(CustomerState(
                customerCode: tblCustomer
                    .getAt(i)
                    ?.customerCode ?? '',
                customerName: tblCustomer
                    .getAt(i)
                    ?.customerName ?? '',
                cnic: tblCustomer
                    .getAt(i)
                    ?.cnicNo ?? '',
                phoneNo: tblCustomer
                    .getAt(i)
                    ?.phoneNo ?? '',
                mobileNo: tblCustomer
                    .getAt(i)
                    ?.mobileNo ?? '',
                email: tblCustomer
                    .getAt(i)
                    ?.emailId ?? '',
                address: tblCustomer
                    .getAt(i)
                    ?.address ?? '',
                isSync: tblCustomer
                    .getAt(i)
                    ?.isSync ?? false,
                city: tblCustomer
                    .getAt(i)
                    ?.city ?? ''));
          }
          list.sort((a, b) =>
              a.customerName
                  .toString()
                  .toLowerCase()
                  .compareTo(b.customerName.toString().toLowerCase()));

          return list;
        }
      }
      return null;
    }
    catch(e){
      return null;
    }
  }
  Future<List<City>?> syncCities() async{
    try{
      final Response? response1 = await getAllCities();
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
          return cityList;
        }
      }
      return null;
    }
    catch(e){
      return null;
    }
  }
}

class NetworkException implements Exception {}