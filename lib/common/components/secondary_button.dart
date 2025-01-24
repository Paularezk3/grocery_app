import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/themes/app_colors.dart';

class SecondaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color buttonColor;
  final Color textColor;
  final double width;
  final double height;

  const SecondaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.buttonColor = const Color(0xFF000000),
    this.textColor = const Color(0xFFFFFFFF),
    this.width = 318.0,
    this.height = 60.0,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width.w,
      height: height.h,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor,
          overlayColor: Colors.white,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          elevation: 0, // Remove shadow if needed
        ),
        child: Text(
          text.toUpperCase(),
          style: Theme.of(context)
              .textTheme
              .headlineSmall!
              .copyWith(color: AppColors.whiteText),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
