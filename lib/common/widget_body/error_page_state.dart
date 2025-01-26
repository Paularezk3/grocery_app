import 'package:flutter/material.dart';
import 'package:grocery_app/core/themes/app_colors.dart';

import '../components/primary_button.dart';

class ErrorStatePage extends StatelessWidget {
  final String? title;
  final String? message;
  final VoidCallback? onRetry;

  /// No need for scaffold it already exists in the widget
  const ErrorStatePage({
    super.key,
    this.title,
    this.message,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Error Title
              if (title != null)
                Text(
                  title!,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: AppColors.orange,
                        fontWeight: FontWeight.bold,
                      ),
                  textAlign: TextAlign.center,
                ),
              const SizedBox(height: 16),

              // Error Message
              if (message != null)
                Text(
                  message!,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.grey,
                        fontWeight: FontWeight.w400,
                      ),
                  textAlign: TextAlign.center,
                ),
              const SizedBox(height: 32),

              // Retry Button
              if (onRetry != null)
                SizedBox(
                  width: 200,
                  child: PrimaryButton(
                    text: 'Retry',
                    onPressed: onRetry,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
