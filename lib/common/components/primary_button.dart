import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocery_app/core/themes/app_colors.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const PrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 318, // Fixed width
        height: 60, // Fixed height
        decoration: BoxDecoration(
          color: AppColors.lightYellow, // AppColors.yellow
          borderRadius: BorderRadius.circular(32), // Rounded corners
        ),
        alignment: Alignment.center, // Center aligned
        child: Text(
          text.toUpperCase(),
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w700, // Weight 700
            fontSize: 24, // Font size 24px
            color: Colors.black, // AppColors.blackText
          ),
        ),
      ),
    );
  }
}
