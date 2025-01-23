import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../common/strings.dart';
import '../../../../core/themes/app_colors.dart';

class OnboardingContent extends StatelessWidget {
  final String title;
  final String body;
  final bool isFirstPage;
  final bool isLastPage;

  const OnboardingContent({
    required this.title,
    required this.body,
    required this.isFirstPage,
    required this.isLastPage,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 20),
          Expanded(
            flex: 3,
            child: AnimatedCrossFade(
              firstChild: Image.asset(
                Strings.onBoardingFruitsPhoto,
                fit: BoxFit.contain,
              ),
              secondChild: Center(
                child: Image.asset(
                  Strings.onBoardingDeliveryPhoto,
                  fit: BoxFit.contain,
                ),
              ),
              crossFadeState: isLastPage
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 300),
            ),
          ),
          Text(
            title,
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                ),
            textAlign: TextAlign.center,
          ),
          if (isFirstPage) ...[
            const SizedBox(height: 20),
            Text(
              "Grocery application",
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
          ],
          const SizedBox(height: 20),
          Text(
            body,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.notReallyBlackText,
                  fontWeight: FontWeight.w300,
                  fontSize: 15.sp,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
