// lib\features\sign_up_auth\presentation\widgets\sign_up_form.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grocery_app/features/login_auth/presentation/bloc/login_auth_bloc.dart';
import 'package:grocery_app/features/login_auth/presentation/bloc/login_auth_event.dart';
import 'package:grocery_app/features/login_auth/presentation/bloc/login_auth_state.dart';
import '../../../../common/components/default_text_field.dart';
import '../../../../common/components/primary_button.dart';
import '../../../../core/themes/app_colors.dart';

class SignInForm extends StatefulWidget {
  const SignInForm({
    super.key,
  });

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  @override
  void dispose() {
    // Dispose controllers to prevent memory leaks
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.read<LoginAuthBloc>().state is LoginPageLoading;
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.5,
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: const BorderRadius.all(
            Radius.circular(32),
          ),
        ),
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Sign In",
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium!
                              .copyWith(
                                  fontWeight: FontWeight.w600, fontSize: 20.sp),
                        ),
                        InkWell(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                              width: 26.w,
                              height: 26.h,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.black,
                              ),
                              child: Icon(
                                Icons.close,
                                size: 18.sp,
                                color: AppColors.white,
                              )),
                        )
                      ]),
                  SizedBox(height: 16.h),
                  Flexible(
                    child: DefaultTextField.normal(
                      hintText: 'Email',
                      controller: emailController,
                      isLoading: isLoading,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Email is required';
                        } else if (!RegExp(
                                r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
                            .hasMatch(value)) {
                          return 'Enter a valid email address';
                        }
                        return null;
                      },
                    ),
                  ),
                  16.verticalSpace,
                  Flexible(
                    child: DefaultTextField.password(
                      hintText: 'Password',
                      controller: passwordController,
                      isLoading: isLoading,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Password is required';
                        }
                        return null;
                      },
                    ),
                  ),
                  // 8.verticalSpace,
                  Flexible(
                      child: TextButton(
                          onPressed: () {},
                          child: Text(
                            "Forgot Password?",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(color: AppColors.orange),
                          ))),
                  24.verticalSpace,
                  Flexible(
                      child: PrimaryButton(
                    text: "Sign In",
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        context.read<LoginAuthBloc>().add(
                              LoginClicked(
                                email: emailController.text.trim(),
                                password: passwordController.text.trim(),
                              ),
                            );
                      }
                    },
                    isLoading: isLoading,
                  ))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
