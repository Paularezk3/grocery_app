import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class SkeletonBuilder extends StatelessWidget {
  final bool isImageLoading;

  /// no need for scaffold it has one
  const SkeletonBuilder({super.key}) : isImageLoading = false;
  const SkeletonBuilder.imageLoading({super.key}) : isImageLoading = true;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    if (isImageLoading) {
      return _shimmerBox(
          height: double.infinity, width: double.infinity, borderRadius: 0);
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16), // Top margin
              // 1. Title and subtitle (left) + Rounded shimmer (right)
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _shimmerBox(height: 20, width: 150), // Title
                      const SizedBox(height: 8),
                      _shimmerBox(height: 16, width: 100), // Subtitle
                    ],
                  ),
                  const Spacer(),
                  _shimmerCircle(size: 40), // Rounded shimmer
                ],
              ),
              const SizedBox(height: 16),

              // 2. Carousel skeleton
              SizedBox(
                height: 162,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _shimmerBox(
                        height: 162,
                        width: screenWidth * 0.7,
                        borderRadius: 18,
                      ),
                      const SizedBox(width: 16),
                      _shimmerBox(
                        height: 162,
                        width: screenWidth * 0.25,
                        borderRadius: 18,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // 3. Title (left) + Circle (right)
              Row(
                children: [
                  _shimmerBox(height: 20, width: 120), // Title
                  const Spacer(),
                  _shimmerCircle(size: 40), // Circle
                ],
              ),
              const SizedBox(height: 8),

              // 4. Small grid row
              SizedBox(
                height: 73,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(
                      4,
                      (_) => Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: _shimmerBox(
                            height: 73, width: 93, borderRadius: 18),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // 5. Title (left) + Rounded shimmer (right)
              Row(
                children: [
                  _shimmerBox(height: 20, width: 120), // Title
                  const Spacer(),
                  _shimmerCircle(size: 40), // Rounded shimmer
                ],
              ),
              const SizedBox(height: 8),

              // 6. Grid view (2 columns, 4 items)
              SizedBox(
                height: 400, // 200 (item height) * 2 rows
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 93 / 200,
                  ),
                  itemCount: 4,
                  itemBuilder: (context, index) => _shimmerBox(
                    height: 200,
                    width: screenWidth * 0.45,
                    borderRadius: 18,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // 7. Rounded button-like shimmer
              Center(
                child: _shimmerBox(
                  height: 50,
                  width: screenWidth * 0.8,
                  borderRadius: 50,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Shimmer box widget
  Widget _shimmerBox({
    required double height,
    required double width,
    double borderRadius = 18,
  }) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }

  // Shimmer circle widget
  Widget _shimmerCircle({required double size}) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        height: size,
        width: size,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
