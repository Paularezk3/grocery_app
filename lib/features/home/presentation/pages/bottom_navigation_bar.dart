import 'package:flutter/material.dart';
import 'package:grocery_app/common/components/default_icon.dart';
import 'package:grocery_app/core/themes/app_colors.dart';

import '../../../../common/strings.dart';

class DefaultBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  // final List<BottomNavigationBarItem> items;
  final Color backgroundColor;
  final Color selectedItemColor;
  final Color unselectedItemColor;
  final double elevation;

  const DefaultBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    // required this.items,
    this.backgroundColor = AppColors.whiteBackground,
    this.selectedItemColor = AppColors.orange,
    this.unselectedItemColor = AppColors.grey,
    this.elevation = 8.0,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      backgroundColor: backgroundColor,
      selectedItemColor: selectedItemColor,
      unselectedItemColor: unselectedItemColor,
      type: BottomNavigationBarType.fixed,
      elevation: elevation,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      items: [
        // Home Icon
        BottomNavigationBarItem(
          icon: DefaultIcon(
            Icons.home_rounded,
            iconColor: currentIndex == 0 ? AppColors.orange : AppColors.grey,
          ),
          label: 'Home',
        ),
        // Arrows Icon
        BottomNavigationBarItem(
          icon: DefaultIcon(
            Icons.compare_arrows_rounded,
            iconColor: currentIndex == 1 ? AppColors.orange : AppColors.grey,
          ),
          label: 'Exchange',
        ),
        // Cart Icon with Notification
        BottomNavigationBarItem(
          icon: DefaultIcon(
            Icons.shopping_cart_rounded,
            iconColor: currentIndex == 2 ? AppColors.orange : AppColors.grey,
            hasNotification: true,
          ),
          label: 'Cart',
        ),
        // Heart Icon
        BottomNavigationBarItem(
          icon: DefaultIcon(
            Icons.favorite_rounded,
            iconColor: currentIndex == 3 ? AppColors.orange : AppColors.grey,
          ),
          label: 'Favorites',
        ),
        // Profile Picture Icon
        BottomNavigationBarItem(
          icon: CircleAvatar(
            radius: 12, // Adjust size as needed
            backgroundImage: AssetImage(Strings.smallProfileImage),
          ),
          label: 'Profile',
        ),
      ],
    );
  }
}
