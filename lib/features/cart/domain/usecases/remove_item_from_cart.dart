import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../repository/cart_repository.dart';

class RemoveItemFromCart {
  final CartRepository repository;

  RemoveItemFromCart(this.repository);

  Future<Either<Failure, void>> call(String itemId) {
    return repository.removeFromCart(itemId);
  }
}
