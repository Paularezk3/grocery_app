import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';

class CachedImageHandler {
  /// Returns an `Image.network` with caching and shimmer loading.
  static Widget asImage({
    required String imageUrl,
    double? width,
    double? height,
    double borderRadius = 0.0,
    BoxFit fit = BoxFit.cover,
    Color shimmerBaseColor = const Color(0xFFEEEEEE),
    Color shimmerHighlightColor = const Color(0xFFF5F5F5),
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        width: width,
        height: height,
        fit: fit,
        placeholder: (context, url) => _buildShimmerBox(
          width: width,
          height: height,
          baseColor: shimmerBaseColor,
          highlightColor: shimmerHighlightColor,
        ),
        errorWidget: (context, url, error) => _buildErrorWidget(width, height),
      ),
    );
  }

  /// Returns a `BoxDecoration` with caching and shimmer loading.
  static BoxDecoration asBoxDecoration({
    required String imageUrl,
    double borderRadius = 0.0,
    BoxFit fit = BoxFit.cover,
    Color shimmerBaseColor = const Color(0xFFEEEEEE),
    Color shimmerHighlightColor = const Color(0xFFF5F5F5),
  }) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(borderRadius),
      image: DecorationImage(
        image: CachedNetworkImageProvider(imageUrl),
        fit: fit,
        onError: (error, stackTrace) {
          // Optional: Handle error state (e.g., log or show placeholder image)
        },
      ),
    );
  }

  /// Builds a shimmer effect for loading states.
  static Widget _buildShimmerBox({
    required double? width,
    required double? height,
    required Color baseColor,
    required Color highlightColor,
  }) {
    return Shimmer.fromColors(
      baseColor: baseColor.withValues(alpha: 0.5),
      highlightColor: highlightColor.withValues(alpha: 0.5),
      child: Container(
        width: width ?? double.infinity,
        height: height ?? double.infinity,
        color: baseColor,
      ),
    );
  }

  /// Builds an error widget for failed image loads.
  static Widget _buildErrorWidget(double? width, double? height) {
    return Container(
      width: width ?? double.infinity,
      height: height ?? double.infinity,
      color: Colors.grey.shade300,
      child: const Icon(Icons.error, color: Colors.red),
    );
  }
}
