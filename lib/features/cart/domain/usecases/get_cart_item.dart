// lib\features\cart\domain\usecases\get_cart_item.dart

import 'package:dartz/dartz.dart';
import 'package:grocery_app/features/cart/domain/entity/cart_item_entity.dart';
import 'package:grocery_app/features/cart/domain/repository/cart_repository.dart';

import '../../../../core/errors/failures.dart';

class GetCartItems {
  final CartRepository cartRepository;
  GetCartItems(this.cartRepository);

  Future<Either<Failure, CartItemEntity>> call() {
    return cartRepository.fetchCartItems();
  }
}
