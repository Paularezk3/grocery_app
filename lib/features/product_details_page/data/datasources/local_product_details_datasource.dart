// lib\features\product_details_page\data\datasources\local_product_details_data_source.dart

import 'dart:convert';

import 'package:grocery_app/core/errors/failures.dart';
import 'package:grocery_app/features/product_details_page/domain/entity/product_details_entity.dart';
import 'package:sqflite/sqflite.dart';

class LocalProductDetailsDataSource {
  final Future<Database> database;

  LocalProductDetailsDataSource(this.database);

  Future<void> cacheProductDetails(ProductDetailsEntity product) async {
    final db = await database;
    try {
      await db.insert(
        'product_details',
        {
          'productId': product.productId,
          'title': product.title,
          'productName': product.productName,
          'description': product.description,
          'price': product.price,
          'carouselImages': jsonEncode(product.carouselImagesBase64),
          'review': product.reviews.rating,
          'numberOfReviews': product.reviews.reviewsNumber,
          'reviews': jsonEncode(product.reviews.reviews
              .map((e) => {
                    'name': e.name,
                    'review': e.review,
                    'rating': e.rating,
                  })
              .toList()),
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      throw CacheFailure(message: e.toString());
    }
  }

  Future<ProductDetailsEntity> getProductDetails(int productId) async {
    final db = await database;
    final result = await db.query(
      'product_details',
      where: 'productId = ?',
      whereArgs: [productId],
    );

    if (result.isNotEmpty) {
      final data = result.first;
      return ProductDetailsEntity(
        productId: data['productId'] as int,
        title: data['title'] as String,
        productName: data['productName'] as String,
        description: data['description'] as String,
        price: data['price'] as double,
        carouselImagesBase64:
            List<String>.from(jsonDecode(data['carouselImages'] as String)),
        reviews: Review(
          rating: (data['review'] as num).toDouble(),
          reviewsNumber: data['numberOfReviews'] as int,
          reviews: (jsonDecode(data['reviews'] as String) as List)
              .map<ReviewDescription>((review) => ReviewDescription(
                    name: review['name'],
                    review: review['review'],
                    rating: (review['rating'] as num).toDouble(),
                  ))
              .toList(),
        ),
      );
    } else {
      throw CacheFailure(message: "No data found");
    }
  }
}
