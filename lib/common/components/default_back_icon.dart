import 'package:flutter/material.dart';

import '../../core/themes/app_colors.dart';

class DefaultBackIcon extends StatelessWidget {
  final Color iconColor;
  final double iconSize;
  final void Function() onPressed;
  const DefaultBackIcon(
      {super.key,
      this.iconColor = AppColors.white,
      this.iconSize = 28,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.arrow_back_rounded,
        color: iconColor,
      ),
      onPressed: () {
        onPressed();
      },
    );
  }
}
