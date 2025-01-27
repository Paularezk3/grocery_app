// lib\features\cart\presentation\bloc\cart_page_event.dart

import '../../domain/entity/cart_item_entity_hive.dart';

abstract class CartPageEvent {}

class LoadCartItems extends CartPageEvent {}

class AddToCart extends CartPageEvent {
  final CartItemData item;

  AddToCart(this.item);
}

class DecrementFromCartEvent extends CartPageEvent {
  final CartItemData itemWithNewQuantity;
  DecrementFromCartEvent(this.itemWithNewQuantity);
}

class RemoveFromCart extends CartPageEvent {
  final CartItemData item;

  RemoveFromCart(this.item);
}
