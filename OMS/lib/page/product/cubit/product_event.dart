

import 'package:BSProOMS/page/product/cubit/product_state.dart';

abstract class ProductEvent {}

// class SaveProduct extends ProductEvent{
//   final Product Product;
//   SaveProduct({required this.Product});
// }
class GetProductListOffline extends ProductEvent{
  final List<ProductState> list;
  GetProductListOffline({required this.list});
}
class GetProductList extends ProductEvent{}
class ProductSubmitted extends ProductEvent{}