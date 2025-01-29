abstract class HomePageEvent {}

class LoadHomePage extends HomePageEvent {}

class UpdateFavoriteTrendingDeal extends HomePageEvent {
  final int dealIndex; // The index of the deal in the trendingDeals list
  final bool isFavourite; // True if adding, false if removing

  UpdateFavoriteTrendingDeal({
    required this.dealIndex,
    required this.isFavourite,
  });
}

class ResetHomePageState extends HomePageEvent {}
