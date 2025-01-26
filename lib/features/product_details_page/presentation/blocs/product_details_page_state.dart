import 'package:grocery_app/features/product_details_page/domain/entity/product_details_entity.dart';

abstract class ProductDetailsPageState {}

class ProductDetailsPageInitial extends ProductDetailsPageState {}

class ProductDetailsPageLoading extends ProductDetailsPageState {}

class ProductDetailsPageLoaded extends ProductDetailsPageState {
  final ProductDetailsEntity product;
  ProductDetailsPageLoaded(this.product);
}

class ProductDetailsPageError extends ProductDetailsPageState {
  final String message;

  ProductDetailsPageError({this.message = "An Error Occurred"});
}
