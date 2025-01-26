// lib\features\product_details_page\domain\usecases\get_product_details.dart

import 'package:dartz/dartz.dart';
import 'package:grocery_app/features/product_details_page/domain/entity/product_details_entity.dart';
import 'package:grocery_app/features/product_details_page/domain/repositories/product_details_repository.dart';
import '../../../../core/errors/failures.dart';

class GetProductDetails {
  final ProductDetailsRepository repository;

  GetProductDetails(this.repository);

  Future<Either<Failure, ProductDetailsEntity>> call(int productId) {
    return repository.getProductDetails(productId);
  }
}
