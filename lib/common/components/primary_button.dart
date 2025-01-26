import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grocery_app/core/themes/app_colors.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final double width;
  final double height;

  const PrimaryButton({
    super.key,
    this.width = 318,
    this.height = 60,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onPressed,
      child: Container(
        width: width.w,
        height: height.h,
        decoration: BoxDecoration(
          color: isLoading ? AppColors.lightGrey : AppColors.lightYellow,
          borderRadius: BorderRadius.circular(32),
        ),
        alignment: Alignment.center,
        child: isLoading
            ? _buildLoadingIndicator(context)
            : Text(
                text.toUpperCase(),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: isLoading ? AppColors.lightGrey : Colors.black,
                    ),
              ),
      ),
    );
  }

  Widget _buildLoadingIndicator(BuildContext context) {
    final isIOS = Theme.of(context).platform == TargetPlatform.iOS;
    return isIOS
        ? const CupertinoActivityIndicator() // Cupertino spinner for iOS
        : const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ); // Material spinner for Android
  }
}
