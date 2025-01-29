// lib\features\cart\presentation\bloc\cart_page_state.dart

import '../../domain/entity/cart_item_entity.dart';

abstract class CartPageState {}

class CartLoadingState extends CartPageState {}

class CartLoadedState extends CartPageState {
  final CartItemEntity items;

  CartLoadedState(this.items);
}

class CartErrorState extends CartPageState {
  final String message;
  CartErrorState({required this.message});
}
