// lib\features\sign_up_auth\presentation\widgets\sign_up_form.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grocery_app/features/sign_up_auth/presentation/bloc/sign_up_auth_state.dart';

import '../../../../common/components/default_text_field.dart';
import '../../../../common/components/primary_button.dart';
import '../../../../core/themes/app_colors.dart';
import '../bloc/sign_up_auth_bloc.dart';
import '../bloc/sign_up_auth_event.dart';
import 'terms_and_conditions.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({
    super.key,
  });

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final formKey = GlobalKey<FormState>();

  final firstNameController = TextEditingController();

  final lastNameController = TextEditingController();

  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  @override
  void dispose() {
    // Dispose controllers to prevent memory leaks
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading =
        context.read<SignUpAuthBloc>().state is SignUpPageLoadingState;
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.6,
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
                          "Create your account",
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
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                          child: DefaultTextField.normal(
                            controller: firstNameController,
                            isLoading: isLoading,
                            hintText: 'First Name',
                            keyboardType: TextInputType.name,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'First name is required';
                              } else if (value.length < 2) {
                                return 'First name must be at least 2 characters';
                              } else if (!RegExp(r"^[a-zA-Z]+$")
                                  .hasMatch(value)) {
                                return 'First name can only contain letters';
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(width: 16.w),
                        Expanded(
                          child: DefaultTextField.normal(
                            controller: lastNameController,
                            isLoading: isLoading,
                            hintText: 'Last Name',
                            keyboardType: TextInputType.name,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Last name is required';
                              } else if (value.length < 2) {
                                return 'Last name must be at least 2 characters';
                              } else if (!RegExp(r"^[a-zA-Z]+$")
                                  .hasMatch(value)) {
                                return 'Last name can only contain letters';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  16.verticalSpace,
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
                            .hasMatch(value.trim())) {
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
                        if (value == null || value.isEmpty) {
                          return 'Password is required';
                        } else if (value.length < 8) {
                          return 'Password must be at least 8 characters long';
                        } else if (!RegExp(r'[A-Z]').hasMatch(value)) {
                          return 'Password must contain at least one uppercase letter';
                        } else if (!RegExp(r'[a-z]').hasMatch(value)) {
                          return 'Password must contain at least one lowercase letter';
                        } else if (!RegExp(r'[0-9]').hasMatch(value)) {
                          return 'Password must contain at least one number';
                        } else if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]')
                            .hasMatch(value)) {
                          return 'Password must contain at least one special character';
                        }
                        return null;
                      },
                    ),
                  ),
                  16.verticalSpace,
                  Flexible(child: TermsAndConditions()),
                  16.verticalSpace,
                  Flexible(
                      child: Hero(
                    tag: "createAccount",
                    child: PrimaryButton(
                      text: "Create an account",
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          context.read<SignUpAuthBloc>().add(
                                SignUpButtonClickedEvent(
                                  firstName: firstNameController.text.trim(),
                                  lastName: lastNameController.text.trim(),
                                  email:
                                      emailController.text.trim().toLowerCase(),
                                  password: passwordController.text.trim(),
                                ),
                              );
                        }
                      },
                      isLoading: isLoading,
                    ),
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
