import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocery_app/core/themes/app_colors.dart';

class SecondaryOutlinedButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color buttonColor;
  final Color textColor;
  final double width;
  final double height;

  const SecondaryOutlinedButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.buttonColor = const Color(0xFF000000),
    this.textColor = const Color(0xFF000000),
    this.width = 318.0,
    this.height = 60.0,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          side: BorderSide(
              color: buttonColor, width: 2.0), // Outline color and width
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
        ),
        child: Text(
          text,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w700, // Weight 700
            fontSize: 24, // Font size 24px
            color: AppColors.blackText, // AppColors.blackText
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
