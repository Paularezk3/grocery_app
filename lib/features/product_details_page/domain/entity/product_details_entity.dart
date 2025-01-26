// lib\features\product_details_page\domain\entity\product_details_entity.dart

class ProductDetailsEntity {
  final int productId;
  final String title;
  final String productName;
  final String description;
  final List<String> carouselImagesBase64;

  final double price;
  final Review reviews;

  ProductDetailsEntity(
      {required this.title,
      required this.productName,
      required this.reviews,
      required this.productId,
      required this.description,
      required this.price,
      required this.carouselImagesBase64});

  get id => null;
}

class Review {
  final double rating;
  final int reviewsNumber;
  final List<ReviewDescription> reviews;

  Review(
      {required this.rating,
      required this.reviewsNumber,
      required this.reviews});
}

class ReviewDescription {
  final String name;
  final String review;
  final double rating;

  ReviewDescription(
      {required this.name, required this.review, required this.rating});
}
