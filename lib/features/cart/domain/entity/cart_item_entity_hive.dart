// lib\features\cart\domain\entity\cart_item_entity_hive.dart

import 'package:hive/hive.dart';

part 'cart_item_entity_hive.g.dart';

@HiveType(typeId: 0)
class CartItemData {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final String category;
  @HiveField(3)
  final String imagePath;
  @HiveField(4)
  final double price;
  @HiveField(5)
  final int quantity;

  CartItemData({
    required this.id,
    required this.title,
    required this.category,
    required this.imagePath,
    required this.price,
    required this.quantity,
  });

  CartItemData copyWith({
    String? id,
    String? title,
    String? category,
    String? imagePath,
    double? price,
    int? quantity,
  }) {
    return CartItemData(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      imagePath: imagePath ?? this.imagePath,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
    );
  }
}
