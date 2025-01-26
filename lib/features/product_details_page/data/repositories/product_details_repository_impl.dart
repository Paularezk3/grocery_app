// lib\features\product_details_page\data\repositories\product_details_repository_impl.dart

import 'package:dartz/dartz.dart';
import 'package:grocery_app/core/errors/failures.dart';
import 'package:grocery_app/features/product_details_page/domain/entity/product_details_entity.dart';
import 'package:grocery_app/features/product_details_page/domain/repositories/product_details_repository.dart';

import '../datasources/local_product_details_datasource.dart';
import '../datasources/remote_product_details_datasource.dart';

class ProductDetailsRepositoryImpl implements ProductDetailsRepository {
  final RemoteProductDetailsDataSource remoteDataSource;
  final LocalProductDetailsDataSource localDataSource;

  ProductDetailsRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, ProductDetailsEntity>> getProductDetails(
      int productId) async {
    ProductDetailsEntity? remoteProduct;
    try {
      // Fetch data from remote
      remoteProduct = await remoteDataSource.fetchProductDetails(productId);
      // Cache to local storage
      await localDataSource.cacheProductDetails(remoteProduct);
      return Right(remoteProduct);
    } on ServerFailure catch (_) {
      try {
        // Fallback to local storage
        final localProduct = await localDataSource.getProductDetails(productId);
        return Right(localProduct);
      } on CacheFailure catch (e) {
        return Left(CacheFailure(message: e.message));
      }
    } on CacheFailure catch (e) {
      if (remoteProduct != null) {
        return Right(remoteProduct);
      }
      return Left(CacheFailure(message: e.message));
    }
  }
}
