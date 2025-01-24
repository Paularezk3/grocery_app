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

  const DefaultTextField.normal({
    super.key,
    this.hintText,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.isLoading = false,
  }) : isPassword = false;

  const DefaultTextField.password({
    super.key,
    this.hintText,
    this.controller,
    this.validator,
    this.isLoading = false,
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
      cursorColor: AppColors.orange,

      cursorRadius: Radius.circular(2),

      controller: widget.controller,
      keyboardType: widget.keyboardType,
      validator: widget.validator,
      obscureText: widget.isPassword ? _obscureText : false,
      obscuringCharacter: '●',
      enabled: !isDisabled, // Disable the text field when isLoading is true
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: isDisabled
                  ? AppColors.lightGrey // Grey hint for disabled state
                  : AppColors.notReallyBlackText,
            ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32),
          borderSide: BorderSide(
            color: isDisabled
                ? AppColors.lightGrey // Grey border for disabled state
                : AppColors.orange,
          ),
        ),
        focusedBorder: isDisabled
            ? OutlineInputBorder(
                borderRadius: BorderRadius.circular(32),
                borderSide: BorderSide(
                  color: AppColors.lightGrey, // Grey border for disabled state
                ),
              )
            : OutlineInputBorder(
                borderRadius: BorderRadius.circular(32),
                borderSide: BorderSide(color: AppColors.orange, width: 2),
              ),
        contentPadding: EdgeInsets.symmetric(
          vertical: 16.h,
          horizontal: 20.w,
        ),

        fillColor: Colors.white, // White background
        filled: true, // Ensure the background is visible
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
