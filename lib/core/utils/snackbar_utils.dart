import 'package:flutter/material.dart';

import '../themes/app_colors.dart';

// abstract class ISnackBarUtils {
//   void showErrorSnackBar(BuildContext context, String message);

//   void showSnackBar(
//     BuildContext context,
//     String message, {
//     Color backgroundColor = Colors.blue,
//     IconData icon = Icons.info,
//   });
// }

extension SnackBarUtils on BuildContext {
  // Private constructor to prevent instantiation
  // SnackBarUtils._();

  /// Shows a SnackBar with a custom error style
  void showErrorSnackBar(BuildContext context, String message) {
    _showSnackBar(
      context,
      message,
      backgroundColor: AppColors.red,
      icon: Icons.error_outline,
    );
  }

  /// Shows a generic styled SnackBar
  void showSnackBar(
    BuildContext context,
    String message, {
    Color backgroundColor = Colors.blue,
    IconData icon = Icons.info,
  }) {
    _showSnackBar(context, message,
        backgroundColor: backgroundColor, icon: icon);
  }

  /// Internal method to build and display the SnackBar
  static void _showSnackBar(
    BuildContext context,
    String message, {
    required Color backgroundColor,
    required IconData icon,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            // Icon wrapped with a circle
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: backgroundColor,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 16,
              ),
            ),
            const SizedBox(width: 16), // Spacing between icon and text
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  message,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32),
        ),
        elevation: 4,
        margin: const EdgeInsets.all(32),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
