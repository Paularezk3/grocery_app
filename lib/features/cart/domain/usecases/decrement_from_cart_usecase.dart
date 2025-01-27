import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entity/cart_item_entity_hive.dart';
import '../repository/cart_repository.dart';

class DecrementFromCartUsease {
  final CartRepository repository;

  DecrementFromCartUsease(this.repository);

  Future<Either<Failure, void>> call(CartItemData cartItemData) {
    return repository.decrementFromCart(cartItemData);
  }
}
