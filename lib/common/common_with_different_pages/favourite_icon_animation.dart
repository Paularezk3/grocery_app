import 'package:flutter/material.dart';
import 'package:grocery_app/common/strings.dart';
import 'package:lottie/lottie.dart';
import '../../core/themes/app_colors.dart';
import '../../features/home/presentation/models/home_page_model.dart';

class FavouriteIconAnimation extends StatefulWidget {
  const FavouriteIconAnimation({
    super.key,
    required this.item,
    required this.onPressed,
  });

  final TrendingDeals item;
  final void Function(bool) onPressed;

  @override
  State<FavouriteIconAnimation> createState() => _FavouriteIconAnimationState();
}

class _FavouriteIconAnimationState extends State<FavouriteIconAnimation> {
  late bool _isFavourite;

  @override
  void initState() {
    super.initState();
    _isFavourite = widget.item.favourite;
  }

  void _toggleFavourite() {
    setState(() {
      _isFavourite = !_isFavourite;
    });
    widget.onPressed(_isFavourite); // Notify the parent about the state change
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleFavourite,
      child: Container(
        padding: EdgeInsets.all(_isFavourite ? 0 : 8),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
        ),
        child: _isFavourite
            ? Lottie.asset(
                Strings.heartAnimation, // Replace with your Lottie file path
                repeat: false, // Play the animation once
                animate: true,
                width: 40,

                onLoaded: (composition) {
                  // Keep the animation at the last frame
                  Future.delayed(
                    composition.duration,
                    () {
                      if (mounted) setState(() {});
                    },
                  );
                },
              )
            : Icon(
                Icons.favorite_border,
                color: AppColors.white,
                size: 24,
              ),
      ),
    );
  }
}
