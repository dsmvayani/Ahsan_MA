

import 'package:BSProOMS/model/Product.dart';
import 'package:BSProOMS/model/SalesManTab.dart';
import 'package:BSProOMS/page/customer-form/cubit/customer_state.dart';
import 'package:BSProOMS/page/sale-order/cubit/sale_order_state.dart';

import '../../../model/SaleOrderTab.dart';

abstract class SaleOrderEvent {}

// class SaveCustomer extends SaleOrderEvent{
//   final Customer customer;
//   SaveCustomer({required this.customer});
// }
class BillDateChanged extends SaleOrderEvent{
  final String billDate;
  BillDateChanged({required this.billDate});
}
class GetSaleOrderDetail extends SaleOrderEvent{
  final String orderId;
  GetSaleOrderDetail({required this.orderId});
}
class CustomerChanged extends SaleOrderEvent{
  final CustomerState customer;
  CustomerChanged({required this.customer});
}
class SalesmanChanged extends SaleOrderEvent{
  final SalesManTab obj;
  SalesmanChanged({required this.obj});
}
class DescriptionChanged extends SaleOrderEvent{
  final String desc;
  DescriptionChanged({required this.desc});
}
class ProductsChanged extends SaleOrderEvent{
  final List<Product> list;
  ProductsChanged({required this.list});
}
// class CustomerMobileNoChanged extends SaleOrderEvent{
//   final String mobileNo;
//   CustomerMobileNoChanged({required this.mobileNo});
// }
// class CustomerEmailChanged extends SaleOrderEvent{
//   final String email;
//   CustomerEmailChanged({required this.email});
// }
// class CustomerCityChanged extends SaleOrderEvent{
//   final String city;
//   CustomerCityChanged({required this.city});
// }
// class CustomerAddressChanged extends SaleOrderEvent{
//   final String address;
//   CustomerAddressChanged({required this.address});
// }
//
class GetProductLookup extends SaleOrderEvent{
  final List<Product> list;
  GetProductLookup({required this.list});
}
class RefreshSaleOrder extends SaleOrderEvent{}
class GetSaleOrderList extends SaleOrderEvent{
  final String orderType;
  GetSaleOrderList({required this.orderType});
}
class EditOrder extends SaleOrderEvent{}
class StartLoading extends SaleOrderEvent{}
class StopLoading extends SaleOrderEvent{}
class SaveSaleOrder extends SaleOrderEvent{}
class GetSaleOrderListOffline extends SaleOrderEvent{
  final List<SaleOrderState> list;
  GetSaleOrderListOffline({required this.list});
}
// class CustomerSubmitted extends SaleOrderEvent{}