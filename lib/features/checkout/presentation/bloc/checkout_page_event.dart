abstract class CheckoutPageEvent {}

class ConfirmOrderEvent extends CheckoutPageEvent {}

class LoadCheckoutPage extends CheckoutPageEvent {}

class GoToThisPage extends CheckoutPageEvent {
  final bool isFirstPage;
  GoToThisPage({required this.isFirstPage});
}
