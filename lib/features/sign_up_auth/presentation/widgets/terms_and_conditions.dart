import 'package:flutter/material.dart';

import '../../../../core/themes/app_colors.dart';

class TermsAndConditions extends StatelessWidget {
  const TermsAndConditions({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            text: 'By tapping Sign up you accept all ',
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black, // Default text color
            ),
            children: [
              TextSpan(
                text: 'terms',
                style: const TextStyle(
                  color: AppColors.lightYellow, // Highlight color for "terms"
                  fontWeight: FontWeight.bold,
                ),
              ),
              const TextSpan(text: ' and '),
              TextSpan(
                text: 'condition',
                style: const TextStyle(
                  color:
                      AppColors.lightYellow, // Highlight color for "condition"
                  fontWeight: FontWeight.bold,
                ),
              ),
              const TextSpan(text: '.'),
            ],
          ),
        ),
      ),
    );
  }
}
