import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entity/cart_item_entity.dart';
import '../entity/cart_item_entity_hive.dart';

abstract class CartRepository {
  Future<Either<Failure, CartItemEntity>> fetchCartItems();
  Future<Either<Failure, CartItemEntity>> addItemToCart(CartItemData item);
  Future<Either<Failure, void>> removeFromCart(String itemId);

  Future<Either<Failure, CartItemEntity>> decrementFromCart(
      CartItemData cartItemData);
}
