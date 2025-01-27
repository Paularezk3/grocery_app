import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/add_item_to_cart.dart';
import '../../domain/usecases/decrement_from_cart_usecase.dart';
import '../../domain/usecases/get_cart_item.dart';
import '../../domain/usecases/remove_item_from_cart.dart';
import 'cart_page_event.dart';
import 'cart_page_state.dart';

class CartPageBloc extends Bloc<CartPageEvent, CartPageState> {
  final GetCartItems getCartItems;
  final AddItemToCart addItemToCart;
  final RemoveItemFromCart removeItemFromCart;
  final DecrementFromCartUsease decrementFromCart;

  CartPageBloc({
    required this.decrementFromCart,
    required this.getCartItems,
    required this.addItemToCart,
    required this.removeItemFromCart,
  }) : super(CartLoadingState()) {
    on<LoadCartItems>(_onLoadCartItems);
    on<AddToCart>(_onAddToCart);
    on<RemoveFromCart>(_onRemoveFromCart);
    on<DecrementFromCartEvent>(_onDecrementFromCart);
  }

  Future<void> _onLoadCartItems(
      LoadCartItems event, Emitter<CartPageState> emit) async {
    emit(CartLoadingState());
    final result = await getCartItems();
    result.fold(
      (failure) => emit(CartErrorState(message: failure.message)),
      (items) => emit(CartLoadedState(items)),
    );
  }

  Future<void> _onAddToCart(
      AddToCart event, Emitter<CartPageState> emit) async {
    if (state is CartLoadedState) {
      final result = await addItemToCart(event.item);
      result.fold(
        (failure) => emit(CartErrorState(message: failure.message)),
        (updatedCart) => emit(CartLoadedState(updatedCart)),
      );
    }
  }

  Future<void> _onRemoveFromCart(
      RemoveFromCart event, Emitter<CartPageState> emit) async {
    if (state is CartLoadedState) {
      final result = await removeItemFromCart(event.item.id);
      result.fold(
        (failure) => emit(CartErrorState(message: failure.message)),
        (_) {
          add(LoadCartItems()); // Reload cart after removal
        },
      );
    }
  }

  Future<void> _onDecrementFromCart(
      DecrementFromCartEvent event, Emitter<CartPageState> emit) async {
    if (state is CartLoadedState) {
      final result = await decrementFromCart(event.itemWithNewQuantity);
      result.fold(
        (failure) => emit(CartErrorState(message: failure.message)),
        (_) {
          add(LoadCartItems()); // Reload cart after removal
        },
      );
    }
  }
}
