import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../common/components/default_text_field.dart';
import '../../../../core/themes/app_colors.dart';

class TextWithTextField extends StatelessWidget {
  final String title;
  final TextEditingController controller;
  final String hintText;
  final bool isLoading;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  const TextWithTextField(
      {required this.title,
      required this.controller,
      required this.hintText,
      required this.isLoading,
      this.keyboardType = TextInputType.text,
      required this.validator,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          textAlign: TextAlign.left,
          style: GoogleFonts.poppins(
              fontWeight: FontWeight.w500,
              fontSize: 14.sp,
              color: AppColors.blackText),
        ),
        8.verticalSpace,
        DefaultTextField.normal(
          controller: controller,
          hintText: hintText,
          isLoading: isLoading,
          keyboardType: keyboardType,
          validator: validator,
        ),
      ],
    );
  }
}
