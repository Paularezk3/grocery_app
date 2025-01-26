// lib\features\product_details_page\domain\repositories\product_details_repository.dart

import 'package:dartz/dartz.dart';
import 'package:grocery_app/features/product_details_page/domain/entity/product_details_entity.dart';

import '../../../../core/errors/failures.dart';

abstract class ProductDetailsRepository {
  Future<Either<Failure, ProductDetailsEntity>> getProductDetails(
      int productId);
}
