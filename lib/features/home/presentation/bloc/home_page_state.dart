import 'package:grocery_app/features/home/presentation/models/home_page_model.dart';

abstract class HomePageState {}

class HomePageIdleState extends HomePageState {}

class HomePageLoadingState extends HomePageState {}

class HomePageLoadedState extends HomePageState {
  HomePageModel homePageModel;
  HomePageLoadedState({required this.homePageModel});
}

class HomePageErrorState extends HomePageState {
  final String message;
  final bool isSignedOut;
  HomePageErrorState({required this.message, required this.isSignedOut});
}
