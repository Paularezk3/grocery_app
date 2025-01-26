import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../common/strings.dart';
import '../models/category_page_model.dart';

// Define the global provider for categories
final categoriesProvider =
    StateNotifierProvider<CategoriesNotifier, List<Category>>(
  (ref) => CategoriesNotifier(),
);

class CategoriesNotifier extends StateNotifier<List<Category>> {
  CategoriesNotifier()
      : super([
          Category(
              title: 'Fruits', itemCount: 15, imagePath: Strings.category1),
          Category(
              title: 'Vegetables', itemCount: 12, imagePath: Strings.category2),
          Category(
              title: 'Mushroom', itemCount: 8, imagePath: Strings.category3),
          Category(title: 'Diary', itemCount: 20, imagePath: Strings.category4),
          Category(title: 'Oats', itemCount: 10, imagePath: Strings.category5),
          Category(title: 'Bread', itemCount: 10, imagePath: Strings.category6),
          Category(title: 'Rice', itemCount: 10, imagePath: Strings.category7),
          Category(title: 'Egg', itemCount: 10, imagePath: Strings.category8),
        ]);
}
