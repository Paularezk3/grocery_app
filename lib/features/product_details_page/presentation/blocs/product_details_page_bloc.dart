// lib\features\product_details_page\presentation\blocs\product_details_page_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_app/features/product_details_page/domain/usecases/get_product_details.dart';

import 'product_details_page_event.dart';
import 'product_details_page_state.dart';

class ProductDetailsPageBloc
    extends Bloc<ProductDetailsPageEvent, ProductDetailsPageState> {
  final GetProductDetails getProductDetails;
  ProductDetailsPageBloc({required this.getProductDetails})
      : super(ProductDetailsPageInitial()) {
    on<LoadProductDetailsPage>(_onLoadProductDetailsPage);
    on<ReturnToInitialState>(_onRetrunToInitialState);
    // on<IncrementQuantityCounter>(_incrementQuantityCounter);
    // on<DecrementQuantityCounter>(_decrementQuantityCounter);
  }

  Future<void> _onLoadProductDetailsPage(LoadProductDetailsPage event,
      Emitter<ProductDetailsPageState> emit) async {
    emit(ProductDetailsPageLoading());

    try {
      final productDetails = await getProductDetails(event.productId);
      productDetails.fold((l) {
        emit(ProductDetailsPageError());
      }, (r) {
        emit(ProductDetailsPageLoaded(r));
      });
    } catch (e) {
      emit(ProductDetailsPageError());
    }
  }

  _onRetrunToInitialState(
      ReturnToInitialState event, Emitter<ProductDetailsPageState> emit) {
    emit(ProductDetailsPageInitial());
  }

  // void _incrementQuantityCounter(
  //     IncrementQuantityCounter event, Emitter<ProductDetailsPageState> emit) {
  //   if (state is ProductDetailsPageLoaded) {
  //     final currentState = state as ProductDetailsPageLoaded;
  //     emit(ProductDetailsPageLoaded(
  //         currentState.product, currentState.quantityCounter + 1));
  //   }
  // }

  // void _decrementQuantityCounter(
  //     DecrementQuantityCounter event, Emitter<ProductDetailsPageState> emit) {
  //   if (state is ProductDetailsPageLoaded) {
  //     final currentState = state as ProductDetailsPageLoaded;
  //     emit(ProductDetailsPageLoaded(
  //         currentState.product, currentState.quantityCounter - 1));
  //   }
  // }
}
