import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/themes/app_colors.dart';
import '../models/category_page_model.dart';

class CategoryCard extends StatelessWidget {
  final Category category;

  const CategoryCard({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Image placeholder
          Expanded(
            child: ColorFiltered(
              colorFilter: ColorFilter.mode(
                AppColors.orange, // Desired color to fill the image
                BlendMode.srcIn,
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
  }
}
