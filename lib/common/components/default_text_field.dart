import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grocery_app/core/themes/app_colors.dart';

// Todo: make the toggle typer to have the same brand identity
class DefaultTextField extends StatefulWidget {
  final String? hintText;
  final TextEditingController? controller;
  final bool isPassword;
  final TextInputType keyboardType;

  const DefaultTextField.normal({
    super.key,
    this.hintText,
    this.controller,
    this.keyboardType = TextInputType.text,
  }) : isPassword = false;

  const DefaultTextField.password({
    super.key,
    this.hintText,
    this.controller,
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
    return TextField(
      controller: widget.controller,
      keyboardType: widget.keyboardType,
      obscureText: widget.isPassword ? _obscureText : false,
      obscuringCharacter: '●',
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.notReallyBlackText,
            ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32),
          borderSide: BorderSide(color: AppColors.orange),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32),
          borderSide: BorderSide(color: AppColors.orange, width: 2),
        ),
        contentPadding: EdgeInsets.symmetric(
          vertical: 16.h,
          horizontal: 20.w,
        ),
        suffixIcon: widget.isPassword
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
