import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../../core/themes/app_colors.dart';
import '../../../../core/utils/cached_image_handler.dart';

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
                CachedImageHandler.asImage(
                    imageUrl: item,
                    shimmerBaseColor: Color(0xFFEEEEEE),
                    shimmerHighlightColor: Color.fromARGB(255, 201, 201, 201)),
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
