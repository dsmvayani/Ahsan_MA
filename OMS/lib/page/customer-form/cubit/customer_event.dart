import 'package:BSProOMS/model/Customer.dart';
import 'package:BSProOMS/page/customer-form/cubit/customer_state.dart';

abstract class CustomerEvent {}

class SaveCustomer extends CustomerEvent{
  final Customer customer;
  SaveCustomer({required this.customer});
}
class CustomerNameChanged extends CustomerEvent{
  final String customerName;
  CustomerNameChanged({required this.customerName});
}
class CustomerCNICChanged extends CustomerEvent{
  final String cnic;
  CustomerCNICChanged({required this.cnic});
}
class CustomerPhoneNoChanged extends CustomerEvent{
  final String phoneNo;
  CustomerPhoneNoChanged({required this.phoneNo});
}
class CustomerMobileNoChanged extends CustomerEvent{
  final String mobileNo;
  CustomerMobileNoChanged({required this.mobileNo});
}
class CustomerEmailChanged extends CustomerEvent{
  final String email;
  CustomerEmailChanged({required this.email});
}
class CustomerCityChanged extends CustomerEvent{
  final String city;
  CustomerCityChanged({required this.city});
}
class CustomerAddressChanged extends CustomerEvent{
  final String address;
  CustomerAddressChanged({required this.address});
}

class GetCustomerList extends CustomerEvent{}
class GetCustomerListOffline extends CustomerEvent{
  final List<CustomerState> list;
    GetCustomerListOffline({required this.list});
}
class CustomerSubmitted extends CustomerEvent{}