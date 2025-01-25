import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocery_app/common/components/default_icon.dart';
import 'package:grocery_app/common/strings.dart';
import 'package:grocery_app/core/themes/app_colors.dart';

// Mock Riverpod StateNotifier and Provider for Categories
class Category {
  final String title;
  final int itemCount;
  final String imagePath;
  Category(
      {required this.title, required this.itemCount, required this.imagePath});
}

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

final categoriesProvider =
    StateNotifierProvider<CategoriesNotifier, List<Category>>(
        (ref) => CategoriesNotifier());

// Categories Page
class CategoriesPage extends ConsumerWidget {
  final Function(int) onTabChange;
  const CategoriesPage({super.key, required this.onTabChange});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(categoriesProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: Hero(
          tag: 'backButton',
          child: DefaultIcon.back(
            onPressed: () => onTabChange(0),
            iconColor: AppColors.black,
          ),
        ),
        title: Text('Categories',
            style: GoogleFonts.poppins(
              fontSize: 24.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.blackText,
            )),
      ),
      backgroundColor: AppColors.lightGrey,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // 2 items per row
            mainAxisSpacing: 16, // Spacing between rows
            crossAxisSpacing: 16, // Spacing between columns
            childAspectRatio: 1, // Square items
          ),
          padding: const EdgeInsetsDirectional.only(top: 16, bottom: 75),
          itemCount: categories.length,
          physics: const AlwaysScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            final category = categories[index];
            return Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(32),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Image placeholder
                  Expanded(
                    child: ColorFiltered(
                      colorFilter: ColorFilter.mode(
                        AppColors.orange, // The desired color to fill the image
                        BlendMode
                            .srcIn, // Replace the image's original color with the specified color
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(category.imagePath),
                            fit: BoxFit.contain,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  4.verticalSpace,
                  // Title
                  Text(
                    category.title,
                    style: GoogleFonts.poppins(
                      fontSize: 16.sp,
                      letterSpacing: 0.2,
                      color: AppColors.orange,
                      fontWeight: FontWeight.w800,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  // Item Count
                  Text(
                    "${category.itemCount} Items",
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.orange,
                        ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
