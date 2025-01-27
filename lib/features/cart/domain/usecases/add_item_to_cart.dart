import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entity/cart_item_entity.dart';
import '../entity/cart_item_entity_hive.dart';
import '../repository/cart_repository.dart';

class AddItemToCart {
  final CartRepository repository;

  AddItemToCart(this.repository);

  Future<Either<Failure, CartItemEntity>> call(CartItemData item) {
    return repository.addItemToCart(item);
  }
}
