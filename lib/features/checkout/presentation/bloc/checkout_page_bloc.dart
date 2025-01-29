import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_app/features/checkout/domain/entity/checkout_data_entity.dart';
import 'package:grocery_app/features/checkout/presentation/bloc/checkout_page_event.dart';
import 'package:grocery_app/features/checkout/presentation/bloc/checkout_page_state.dart';

class CheckoutPageBloc extends Bloc<CheckoutPageEvent, CheckoutPageState> {
  CheckoutPageBloc() : super(CheckoutPageInitial()) {
    on<LoadCheckoutPage>(_onLoadCheckoutPage);
    on<ConfirmOrderEvent>(
      (event, emit) {},
    );
    on<GoToThisPage>(_onLoadNextPageEvent);
  }
  Future<void> _onLoadCheckoutPage(
      LoadCheckoutPage event, Emitter<CheckoutPageState> emit) async {
    emit(CheckoutPageLoading());

    try {
      final String? firstName;
      final String? lastName;
      final String? fullName;
      final String emailAddress;
      // Fetch the currently logged-in user
      final user = FirebaseAuth.instance.currentUser;

      // Reference to the user's document
      final doc = FirebaseFirestore.instance.collection("users").doc(user!.uid);

      // Fetch user data
      final snapshot = await doc.get();

      final data = snapshot.data();

      // Extract necessary fields
      firstName = data?['firstName'] as String?;
      lastName = data?['lastName'] as String?;
      fullName = "$firstName $lastName".trim();
      emailAddress = user.email ?? '';

      // Emit the loaded state with the user data
      emit(CheckoutPageLoaded(
          checkoutData: CheckoutDataEntity(
            emailAddress: emailAddress,
            fullName: fullName,
          ),
          isFirstPage: true));
    } catch (e) {
      // Emit an error state with the exception message
      emit(CheckoutPageError(
          message: "Failed to load checkout data: ${e.toString()}"));
    }
  }

  Future<void> _onLoadNextPageEvent(
      GoToThisPage event, Emitter<CheckoutPageState> emit) async {
    emit(CheckoutPageLoaded(
        checkoutData: (state as CheckoutPageLoaded).checkoutData,
        isFirstPage: event.isFirstPage));
  }
}
