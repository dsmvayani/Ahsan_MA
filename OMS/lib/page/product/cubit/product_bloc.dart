import 'dart:convert';
import 'dart:typed_data';

import 'package:BSProOMS/page/product/cubit/product_event.dart';
import 'package:BSProOMS/page/product/cubit/product_state.dart';
import 'package:BSProOMS/repository/product_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../auth/form_submission_status.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository productRepository;

  ProductBloc({required this.productRepository}) : super(ProductState()) {
    on<ProductEvent>(_onEvent);
  }

  Future<void> _onEvent(ProductEvent event, Emitter<ProductState> emit) async {
    if(event is GetProductList){
      emit(state.copyWith(list: [], list1: [], formStatus: FormSubmitting()));
      try {
        final Response? response = await productRepository.getData("GEN_BSProOMSSP",["@nType", "@nsType"],['0', '8']);

        if (response != null && response.statusCode == 200) {
          var json = jsonDecode(response.data);
          List<ProductState> _list = [];
          for(var pro in json){
            ProductState productState = ProductState(nBarcode: pro["BarCode"].toString(), nSalesRate: double.parse(pro["SalesRate"].toString()), nAttribute1Code: pro["Attribute1Code"].toString(), nAttribute: pro["Attribute"].toString(), nAttribute1Image: pro["Base64Image"] != null ? pro["Base64Image"] : '');
            _list.add(productState);
          }
          emit(state.copyWith(list: _list, list1: _list, formStatus: SubmissionSuccess()));
        } else {
          emit(state.copyWith(
              formStatus: SubmissionFailed(new Exception("Login Failed"))));
        }
      } catch (e) {
        emit(state.copyWith(formStatus: SubmissionFailed(new Exception(e))));
      }
      // emit(state.copyWith(billDate: '', formStatus: InitialFormStatus(), customerState: CustomerState(customerName: '', customerCode: ''), salesManTab: SalesManTab(nSalesManCode: '', nSalesMan: '', nShortName: ''), list: [], customerName: '', netAmount: 0, totalItems: 0, totalQuantity: 0, description: '', saleOrderList: [], isSync: false));
    }
    else if(event is GetProductListOffline){
      emit(state.copyWith(list: event.list));
    }
  }
}
