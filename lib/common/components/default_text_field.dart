import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grocery_app/core/themes/app_colors.dart';

class DefaultTextField extends StatefulWidget {
  final String? hintText;
  final TextEditingController? controller;
  final bool isPassword;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final bool isLoading;
  final bool dynamicHeight; // New parameter for dynamic height

  const DefaultTextField.normal({
    super.key,
    this.hintText,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.isLoading = false,
    this.dynamicHeight = false,
  }) : isPassword = false;

  const DefaultTextField.password({
    super.key,
    this.hintText,
    this.controller,
    this.validator,
    this.isLoading = false,
    this.dynamicHeight = false,
  })  : isPassword = true,
        keyboardType = TextInputType.text;

  @override
  State<DefaultTextField> createState() => _DefaultTextFieldState();
}

class _DefaultTextFieldState extends State<DefaultTextField> {
  bool _obscureText = true;

  void _toggleObscureText() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDisabled = widget.isLoading;

    return TextFormField(
      controller: widget.controller,
      cursorColor: AppColors.orange,
      cursorRadius: const Radius.circular(2),
      keyboardType: widget.keyboardType,
      validator: widget.validator,
      obscureText: widget.isPassword ? _obscureText : false,
      obscuringCharacter: '●',
      enabled: !isDisabled,
      maxLines:
          widget.dynamicHeight ? null : 1, // Infinite lines if dynamicHeight
      minLines: widget.dynamicHeight ? 1 : null,
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: isDisabled
                  ? AppColors.lightGrey
                  : AppColors.notReallyBlackText,
            ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32),
          borderSide: BorderSide(
            color: isDisabled ? AppColors.lightGrey : AppColors.orange,
          ),
        ),
        focusedBorder: isDisabled
            ? OutlineInputBorder(
                borderRadius: BorderRadius.circular(32),
                borderSide: BorderSide(color: AppColors.lightGrey),
              )
            : OutlineInputBorder(
                borderRadius: BorderRadius.circular(32),
                borderSide: BorderSide(color: AppColors.orange, width: 2),
              ),
        fillColor: isDisabled ? AppColors.lightGrey : Colors.white,
        filled: true,
        contentPadding: EdgeInsets.only(
          top: 16.h, // Align text to the top
          left: 20.w,
          right: 20.w,
        ),
        alignLabelWithHint: true, // Ensures the hint aligns with the text
        suffixIcon: widget.isPassword && !isDisabled
            ? IconButton(
                icon: Icon(
                  _obscureText
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: AppColors.orange,
                ),
                onPressed: _toggleObscureText,
              )
            : null,
      ),
    );
  }
}
