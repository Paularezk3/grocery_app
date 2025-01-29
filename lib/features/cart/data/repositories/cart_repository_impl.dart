import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:hive/hive.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entity/cart_item_entity.dart';
import '../../domain/entity/cart_item_entity_hive.dart';
import '../../domain/repository/cart_repository.dart';

class CartRepositoryImpl implements CartRepository {
  final FirebaseFirestore firestore;
  final Box<CartItemData> cartBox;

  CartRepositoryImpl({required this.firestore, required this.cartBox});

  @override
  Future<Either<Failure, CartItemEntity>> fetchCartItems() async {
    try {
      final items = cartBox.values.toList();
      final convertedItems = items
          .map((item) => CartItemData(
                id: item.id,
                title: item.title,
                category: item.category,
                imagePath: item.imagePath,
                price: item.price,
                quantity: item.quantity,
              ))
          .toList();
      return Right(CartItemEntity(cartItemData: convertedItems));
    } catch (e) {
      return Left(ServerFailure(message: "Failed to fetch cart items"));
    }
  }

  @override
  Future<Either<Failure, CartItemEntity>> addItemToCart(
      CartItemData item) async {
    try {
      // Fetch product details from Firestore
      final productSnapshot =
          await firestore.collection('products').doc(item.id).get();
      if (!productSnapshot.exists) {
        return Left(ServerFailure(message: "Product not found"));
      }

      final productData = productSnapshot.data()!;
      final price = (productData['price'] as num).toDouble();

      // Add item to Hive
      final hiveItem = CartItemData(
        id: item.id,
        title: item.title,
        category: item.category,
        imagePath: item.imagePath,
        price: price,
        quantity: item.quantity,
      );
      cartBox.put(hiveItem.id, hiveItem);

      return fetchCartItems();
    } catch (e) {
      return Left(ServerFailure(message: "Failed to add item to cart"));
    }
  }

  @override
  Future<Either<Failure, void>> removeFromCart(String itemId) async {
    try {
      cartBox.delete(itemId);
      return fetchCartItems();
    } catch (e) {
      return Left(ServerFailure(message: "Failed to remove item from cart"));
    }
  }

  @override
  Future<Either<Failure, CartItemEntity>> decrementFromCart(
      CartItemData cartItemData) async {
    try {
      CartItemData item = cartBox.get(cartItemData.id)!;
      item = item.copyWith(quantity: cartItemData.quantity);
      cartBox.put(item.id, item);
      return fetchCartItems();
    } catch (e) {
      return Left(CacheFailure(message: "Hive has a problem I think: $e"));
    }
  }
}
