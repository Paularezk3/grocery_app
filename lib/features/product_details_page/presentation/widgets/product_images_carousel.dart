import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../common/layout/skeleton_builder.dart';
import '../../../../core/themes/app_colors.dart';

class ProductImagesCarousel extends StatefulWidget {
  final List<String> carousel;
  const ProductImagesCarousel({
    required this.carousel,
    super.key,
  });

  @override
  State<ProductImagesCarousel> createState() => _ProductImagesCarouselState();
}

class _ProductImagesCarouselState extends State<ProductImagesCarousel> {
  final PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PageView.builder(
          itemCount: widget.carousel.length,
          controller: pageController,
          itemBuilder: (context, index) {
            final item = widget.carousel[index];
            return Stack(
              fit: StackFit.expand,
              children: [
                Image.network(
                  item, // Dynamic photo URL
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) {
                      // The image has been fully loaded
                      return child;
                    } else {
                      // Show skeleton builder while loading
                      return SkeletonBuilder.imageLoading();
                    }
                  },
                  errorBuilder: (context, error, stackTrace) {
                    // Handle image load failure
                    return Center(
                      child: Icon(
                        Icons.broken_image,
                        size: 40,
                        color: Colors.grey,
                      ),
                    );
                  },
                ),
                Container(
                  color:
                      AppColors.black.withValues(alpha: 0.2), // Dimming overlay
                ),
              ],
            );
          },
        ),
        // Smooth Page Indicator
        Positioned(
          bottom: 16,
          left: 0,
          right: 0,
          child: Center(
            child: SmoothPageIndicator(
              controller: pageController,
              count: widget.carousel.length,
              effect: SwapEffect(
                activeDotColor: AppColors.lightGrey,
                dotHeight: 6,
                dotWidth: 23,
                dotColor: AppColors.lightGrey.withValues(alpha: 0.3),
              ),
              onDotClicked: (index) {
                pageController.animateToPage(
                  index,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOutCubic,
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
