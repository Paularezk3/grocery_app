import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_app/common/strings.dart';
import 'package:grocery_app/features/home/presentation/models/home_page_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home_page_event.dart';
import 'home_page_state.dart';

class HomePageBloc extends Bloc<HomePageEvent, HomePageState> {
  HomePageBloc() : super(HomePageIdleState()) {
    on<LoadHomePage>(_onLoadHomePage);
    on<UpdateFavoriteTrendingDeal>(_onUpdateFavoriteTrendingDeal);
    on<ResetHomePageState>((_, emit) => emit(HomePageIdleState()));
  }
  Future<void> _onLoadHomePage(
      LoadHomePage event, Emitter<HomePageState> emit) async {
    emit(HomePageLoadingState());
    await Future.delayed(Duration(milliseconds: 500));

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception("#402 User is not Signed in");
      }

      final userDoc = await FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .get();

      // Fetch the favoriteTrendingDeals list
      List<dynamic> favoriteIds =
          userDoc.data()?['favouriteTrendingDeals'] ?? [];

      // Define the TrendingDeals list
      List<TrendingDeals> trendingDeals = [
        TrendingDeals(
            favourite: false,
            title: "Avocado",
            price: 4.9,
            imageAssetPath: Strings.carousel3),
        TrendingDeals(
            favourite: false,
            title: "Banana",
            price: 1.5,
            imageAssetPath: Strings.carousel7),
        TrendingDeals(
            favourite: false,
            title: "Brocoli",
            price: 2.8,
            imageAssetPath: Strings.carousel4),
        TrendingDeals(
            favourite: false,
            title: "Tomatoes",
            price: 2.5,
            imageAssetPath: Strings.carousel5),
        TrendingDeals(
            favourite: false,
            title: "Grapes",
            price: 3.8,
            imageAssetPath: Strings.carousel6),
      ];

      // Update the 'favourite' property of trendingDeals based on favoriteIds
      for (int i = 0; i < trendingDeals.length; i++) {
        trendingDeals[i].favourite = favoriteIds.contains(i);
      }

      emit(HomePageLoadedState(
        homePageModel: HomePageModel(
            uidFirebase: user.uid,
            greetingMessage: _getGreetingMessage(),
            shouldShowShowcase: await _shouldShowShowcase(),
            userFirstName: userDoc.get("firstName"),
            userLastName: userDoc.get("lastName"),
            carouselItems: [
              CarouselItems(
                  imageAssetPath: Strings.carousel1,
                  title: "Recommended Recipe Today"),
              CarouselItems(
                  imageAssetPath: Strings.carousel2,
                  title: "Fresh Fruits Delivery"),
            ],
            categoryItems: [
              CategoryItems(imageAssetPath: Strings.category1),
              CategoryItems(imageAssetPath: Strings.category2),
              CategoryItems(imageAssetPath: Strings.category3),
              CategoryItems(imageAssetPath: Strings.category4),
              CategoryItems(imageAssetPath: Strings.category5),
              CategoryItems(imageAssetPath: Strings.category6),
              CategoryItems(imageAssetPath: Strings.category7),
              CategoryItems(imageAssetPath: Strings.category8),
            ],
            trendingDeals: trendingDeals),
      ));
    } catch (e) {
      emit(HomePageErrorState(
          message: e.toString(), isSignedOut: e.toString().contains("#402")));
    }
  }

  Future<void> _onUpdateFavoriteTrendingDeal(
      UpdateFavoriteTrendingDeal event, Emitter<HomePageState> emit) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception("#402 User is not Signed in");
      }

      final userDocRef =
          FirebaseFirestore.instance.collection("users").doc(user.uid);

      // Update the Firestore list
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        final snapshot = await transaction.get(userDocRef);

        List<dynamic> favoriteIds =
            snapshot.data()?['favouriteTrendingDeals'] ?? [];

        if (event.isFavourite) {
          // Add the index to the list if it's not already there
          if (!favoriteIds.contains(event.dealIndex)) {
            favoriteIds.add(event.dealIndex);
          }
        } else {
          // Remove the index from the list
          favoriteIds.remove(event.dealIndex);
        }

        transaction.update(userDocRef, {'favouriteTrendingDeals': favoriteIds});
      });
    } catch (e) {
      emit(HomePageErrorState(
          message: e.toString(), isSignedOut: e.toString().contains("#402")));
    }
  }

  Future<bool> _shouldShowShowcase() async {
    final prefs = await SharedPreferences.getInstance();
    final hasSeenShowcase = prefs.getBool('hasSeenShowcase') ?? false;

    if (!hasSeenShowcase) {
      await prefs.setBool('hasSeenShowcase', true);
    }
    return !hasSeenShowcase;
  }

  String _getGreetingMessage() {
    final hour = DateTime.now().hour;
    if (hour < 12) return "Good Morning";
    if (hour < 18) return "Good Afternoon";
    return "Good Evening";
  }
}
