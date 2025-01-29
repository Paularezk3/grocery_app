import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsService {
  final FirebaseAnalytics _analytics;

  AnalyticsService(this._analytics);

  /// 📌 Log screen views
  Future<void> logScreenView({required String screenName}) async {
    await _analytics.logScreenView(
      screenName: screenName,
      screenClass: screenName,
    );
  }

  /// 📌 Track when a user adds a product to the cart
  Future<void> logAddToCart({
    required String productId,
    required String productName,
    required double price,
  }) async {
    await _analytics.logEvent(
      name: "add_to_cart",
      parameters: {
        "product_id": productId,
        "product_name": productName,
        "price": price,
      },
    );
  }

  /// 📌 Track when a user removes a product from the cart
  Future<void> logRemoveFromCart({
    required String productId,
    required String productName,
    required double price,
  }) async {
    await _analytics.logEvent(
      name: "remove_from_cart",
      parameters: {
        "product_id": productId,
        "product_name": productName,
        "price": price,
      },
    );
  }

  /// 📌 Track when a user completes a purchase
  Future<void> logPurchase({
    required String orderId,
    required double totalAmount,
    required List<Map<String, dynamic>> items,
  }) async {
    // Flattening the list of items into a format Firebase accepts
    final Map<String, dynamic> itemParameters = {};

    for (int i = 0; i < items.length; i++) {
      itemParameters["item_${i}_id"] = items[i]["product_id"];
      itemParameters["item_${i}_name"] = items[i]["product_name"];
      itemParameters["item_${i}_price"] = items[i]["price"];
      itemParameters["item_${i}_quantity"] = items[i]["quantity"];
    }

    await _analytics.logEvent(
      name: "purchase",
      parameters: {
        "order_id": orderId,
        "total_amount": totalAmount,
        ...itemParameters, // Spread flattened item properties
      },
    );
  }

  /// 📌 Track when a user signs in
  Future<void> logUserSignIn({required String userId}) async {
    await _analytics.logLogin();
    await _analytics.setUserId(id: userId);
  }

  /// 📌 Track when a user signs out
  Future<void> logUserSignOut() async {
    await _analytics.logEvent(name: "logout");
  }

  /// 📌 Track custom events
  Future<void> logCustomEvent(
      {required String eventName, Map<String, Object>? parameters}) async {
    await _analytics.logEvent(name: eventName, parameters: parameters);
  }
}
