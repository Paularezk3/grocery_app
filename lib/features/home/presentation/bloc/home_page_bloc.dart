import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_app/common/strings.dart';
import 'package:grocery_app/features/home/presentation/models/home_page_model.dart';

import 'home_page_event.dart';
import 'home_page_state.dart';

class HomePageBloc extends Bloc<HomePageEvent, HomePageState> {
  HomePageBloc() : super(HomePageIdleState()) {
    on<LoadHomePage>(_onLoadHomePage);
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

      emit(HomePageLoadedState(
        homePageModel: HomePageModel(
            greetingMessage: _getGreetingMessage(),
            userFirstName: userDoc.get("firstName"),
            userLastName: userDoc.get("lastName"),
            carouselItems: [
              CarouselItems(
                  imageAssetPath: Strings.carousel1,
                  title: "Recomended Recipe Today"),
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
            trendingDeals: [
              TrendingDeals(
                  favourite: true,
                  title: "Avocado",
                  price: 6.7,
                  imageAssetPath: Strings.carousel3),
              TrendingDeals(
                  favourite: false,
                  title: "Brocoli",
                  price: 8.7,
                  imageAssetPath: Strings.carousel4),
              TrendingDeals(
                  favourite: false,
                  title: "Tomatoes",
                  price: 4.9,
                  imageAssetPath: Strings.carousel5),
              TrendingDeals(
                  favourite: false,
                  title: "Grapes",
                  price: 7.2,
                  imageAssetPath: Strings.carousel6),
              TrendingDeals(
                  favourite: false,
                  title: "Grapes",
                  price: 7.2,
                  imageAssetPath: Strings.carousel6),
            ]),
      ));
    } catch (e) {
      emit(HomePageErrorState(
          message: e.toString(), isSignedOut: e.toString().contains("#402")));
    }
  }

  String _getGreetingMessage() {
    final hour = DateTime.now().hour;
    if (hour < 12) return "Good Morning";
    if (hour < 18) return "Good Afternoon";
    return "Good Evening";
  }
}
