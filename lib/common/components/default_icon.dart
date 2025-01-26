import 'package:flutter/material.dart';
import '../../core/themes/app_colors.dart';

class DefaultIcon extends StatelessWidget {
  final IconData icon;
  final double iconSize;
  final Color iconColor;
  final VoidCallback? onPressed;
  final bool hasNotification;

  // Default constructor
  const DefaultIcon(
    this.icon, {
    super.key,
    this.hasNotification = false,
    this.iconColor = AppColors.apparentlyBlack,
    this.iconSize = 28,
    this.onPressed,
  });

  // Back icon factory constructor
  const DefaultIcon.back({
    super.key,
    this.hasNotification = false,
    this.icon = Icons.arrow_back_rounded,
    this.iconColor = AppColors.white,
    this.iconSize = 28,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: iconSize + 16, // Adjust width to fit icon and possible badge
      height: iconSize,
      child: GestureDetector(
        onTap: onPressed, // If null, icon is non-clickable
        behavior: onPressed != null ? HitTestBehavior.opaque : null,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Main Icon
            Align(
              alignment: Alignment.center,
              child: Icon(
                icon,
                size: iconSize,
                color: iconColor,
              ),
            ),
            // Optional Badge
            if (hasNotification) // Only for specific icons
              Positioned(
                top: -4,
                right: 6,
                child: Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    border:
                        Border.all(color: AppColors.whiteBackground, width: 2),
                    color: AppColors.lightYellow,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
