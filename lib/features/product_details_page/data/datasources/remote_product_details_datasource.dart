import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grocery_app/core/errors/failures.dart';
import 'package:grocery_app/features/product_details_page/domain/entity/product_details_entity.dart';

class RemoteProductDetailsDataSource {
  final FirebaseFirestore firestore;

  RemoteProductDetailsDataSource(this.firestore);

  Future<ProductDetailsEntity> fetchProductDetails(int productId) async {
    try {
      // Fetch document snapshot
      final snapshot =
          await firestore.collection('products').doc('$productId').get();

      if (!snapshot.exists) {
        throw ServerFailure(
            message: "No data found for product ID: $productId");
      }

      final data = snapshot.data();

      // Null checks for required fields
      if (data == null ||
          data['title'] == null ||
          data['category'] == null ||
          data['description'] == null ||
          data['price'] == null ||
          data['carouselImages'] == null) {
        throw ServerFailure(
            message: "Incomplete data for product ID: $productId");
      }

      // Parse reviews safely
      final reviewsData = data['reviews'] as Map<String, dynamic>? ?? {};
      final reviewRating = (reviewsData['rating'] as num?)?.toDouble() ?? 0.0;
      final reviewNumber = reviewsData['reviewsNumber'] as int? ?? 0;

      final reviewDetails = (reviewsData['reviewDetails'] as List?)
              ?.map((review) => ReviewDescription(
                    name: review['name'] as String? ?? "Anonymous",
                    review: review['review'] as String? ?? "No review provided",
                    rating: (review['rating'] as num?)?.toDouble() ?? 0.0,
                  ))
              .toList() ??
          [];

      // Construct ProductDetailsEntity
      return ProductDetailsEntity(
        productId: productId,
        title: data['title'] as String,
        productName: data['category'] as String,
        description: data['description'] as String,
        price: (data['price'] as num).toDouble(),
        carouselImagesBase64: List<String>.from(data['carouselImages']),
        reviews: Review(
          rating: reviewRating,
          reviewsNumber: reviewNumber,
          reviews: reviewDetails,
        ),
      );
    } catch (e) {
      throw ServerFailure(
          message: "Error fetching product details: ${e.toString()}");
    }
  }
}
