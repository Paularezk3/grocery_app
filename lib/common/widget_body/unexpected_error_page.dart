import 'package:flutter/material.dart';
import 'package:grocery_app/core/themes/app_colors.dart';

class UnexpectedErrorPage extends StatelessWidget {
  final VoidCallback onReload;
  final String? message;

  const UnexpectedErrorPage({
    super.key,
    required this.onReload,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Optional error message
            if (message != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Text(
                  message!,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                  textAlign: TextAlign.center,
                ),
              ),
            // Reload Button
            SizedBox(
              width: 200,
              child: ElevatedButton(
                onPressed: onReload,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.orange, // Brand color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32), // Rounded corners
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                ),
                child: Text(
                  'Reload',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
