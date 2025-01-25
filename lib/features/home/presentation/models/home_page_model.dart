class HomePageModel {
  final String userFirstName;
  final String userLastName;
  final String greetingMessage;
  final List<CategoryItems> categoryItems;
  final List<CarouselItems> carouselItems;
  final List<TrendingDeals> trendingDeals;
  HomePageModel(
      {required this.categoryItems,
      required this.trendingDeals,
      required this.carouselItems,
      required this.greetingMessage,
      required this.userFirstName,
      required this.userLastName});
}

class CategoryItems {
  final String imageAssetPath;
  CategoryItems({required this.imageAssetPath});
}

class CarouselItems {
  final String imageAssetPath;
  final String title;
  CarouselItems({required this.title, required this.imageAssetPath});
}

class TrendingDeals {
  final bool favourite;
  final String title;
  final double price;
  final String imageAssetPath;

  TrendingDeals(
      {required this.favourite,
      required this.title,
      required this.price,
      required this.imageAssetPath});
}
