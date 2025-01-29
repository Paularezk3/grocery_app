import 'package:grocery_app/features/checkout/domain/entity/checkout_data_entity.dart';

abstract class CheckoutPageState {}

class CheckoutPageInitial extends CheckoutPageState {}

class CheckoutPageLoading extends CheckoutPageState {}

class CheckoutPageLoaded extends CheckoutPageState {
  final CheckoutDataEntity checkoutData;
  final bool isFirstPage;
  CheckoutPageLoaded({required this.isFirstPage, required this.checkoutData});
}

class CheckoutPageError extends CheckoutPageState {
  final String message;

  CheckoutPageError({this.message = "An unknown error occurred."});
}
