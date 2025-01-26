import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocery_app/common/components/default_icon.dart';
import 'package:grocery_app/core/config/routes/route_names.dart';
import 'package:grocery_app/core/themes/app_colors.dart';
import '../riverpod/category_page_riverpod.dart';
import '../widgets/category_card.dart';

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
        title: Text(
          'Categories',
          style: GoogleFonts.poppins(
            fontSize: 24.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.blackText,
          ),
        ),
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
            return Ink(
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(32),
              ),
              child: InkWell(
                  enableFeedback: true,
                  onTap: () {
                    // Navigator.of(context).pushNamed(RouteNames.fruitsCategoryPage, arguments: {
                    //   'category': category,
                    // });
                  },
                  borderRadius: BorderRadius.circular(32),
                  splashColor: AppColors.lightYellow,
                  canRequestFocus: true,
                  focusColor: AppColors.lightYellow,
                  child: CategoryCard(category: category)),
            );
          },
        ),
      ),
    );
  }
}
