import 'package:grocery_app/core/errors/failures.dart';
import 'package:grocery_app/features/product_details_page/domain/entity/product_details_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RemoteProductDetailsDataSource {
  final FirebaseFirestore firestore;

  RemoteProductDetailsDataSource(this.firestore);

  Future<ProductDetailsEntity> fetchProductDetails(int productId) async {
    try {
      final snapshot =
          await firestore.collection('products').doc('$productId').get();

      if (snapshot.exists) {
        final data = snapshot.data()!;
        return ProductDetailsEntity(
          productId: productId,
          title: data['title'] as String,
          productName: data['productName'] as String,
          description: data['description'] as String,
          price: (data['price'] as num).toDouble(),
          carouselImagesBase64: List<String>.from(data['carouselImages']),
          reviews: Review(
            rating: (data['reviews']['rating'] as num).toDouble(),
            reviewsNumber: data['reviews']['reviewsNumber'] as int,
            reviews: (data['reviews']['reviewDetails'] as List)
                .map((review) => ReviewDescription(
                      name: review['name'] as String,
                      review: review['review'] as String,
                      rating: (review['rating'] as num).toDouble(),
                    ))
                .toList(),
          ),
        );
      } else {
        throw ServerFailure(message: "No data found");
      }
    } catch (e) {
      throw ServerFailure(message: e.toString());
    }
  }
}
