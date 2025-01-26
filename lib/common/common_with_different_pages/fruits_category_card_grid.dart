import 'package:flutter/material.dart';

import '../../core/themes/app_colors.dart';
import '../../features/home/presentation/models/home_page_model.dart';
import 'favourite_icon_animation.dart';

class FruitsCategoryCardGrid extends StatelessWidget {
  final List<TrendingDeals> trendingDeals;
  final bool isScrollable;
  final double verticalPadding;
  final void Function(int) onPressed;
  const FruitsCategoryCardGrid({
    required this.trendingDeals,
    this.isScrollable = false,
    required this.onPressed,
    this.verticalPadding = 0,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.symmetric(vertical: verticalPadding),
      physics: isScrollable
          ? const AlwaysScrollableScrollPhysics()
          : const NeverScrollableScrollPhysics(), // Non-scrollable grid
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // Two columns
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1 / 1.5,
      ),
      itemCount: trendingDeals.length,
      itemBuilder: (context, index) {
        final item = trendingDeals[index];
        return Material(
          color: Colors.transparent, // Keep background transparent
          borderRadius:
              BorderRadius.circular(18), // Match InkWell border radius
          child: InkWell(
            onTap: () => onPressed(index),
            splashColor: AppColors.orange.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(18),
            child: Stack(
              children: [
                // Product Image with Background
                Ink(
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        offset: const Offset(0, 2),
                        blurRadius: 19,
                        spreadRadius: 2,
                        color: AppColors.black.withValues(alpha: 0.05),
                      ),
                    ],
                    image: DecorationImage(
                      image: AssetImage(item.imageAssetPath),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      gradient: LinearGradient(colors: [
                        AppColors.black.withValues(alpha: 0.5),
                        AppColors.black.withValues(alpha: 0.0),
                      ], begin: Alignment.bottomCenter, end: Alignment.center),
                    ),
                  ),
                ),

                // Favorite Button
                Positioned(
                  top: 8,
                  left: 8,
                  child: GestureDetector(
                    onTap: () {
                      // Handle favorite action here
                    },
                    child: FavouriteIconAnimation(
                      item: item,
                      onPressed: () {},
                    ),
                  ),
                ),

                // Product Details (Title and Price)
                Positioned(
                  bottom: 12,
                  left: 12,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Product Title
                      Text(
                        item.title,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              color: Colors.black.withValues(alpha: 0.5),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 4),

                      // Product Price
                      Text(
                        '\$${item.price}',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              color: Colors.black.withValues(alpha: 0.5),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
