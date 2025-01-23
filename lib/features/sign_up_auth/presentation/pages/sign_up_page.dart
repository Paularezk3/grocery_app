import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grocery_app/common/components/default_text_field.dart';
import 'package:grocery_app/common/components/primary_button.dart';
import 'package:grocery_app/common/strings.dart';
import 'package:grocery_app/core/themes/app_colors.dart';
import 'package:grocery_app/features/sign_up_auth/presentation/widgets/terms_and_conditions.dart';

import '../../../../common/components/default_back_icon.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // Background image with overlay
          Positioned.fill(
            child: Column(
              children: [
                SizedBox(
                  height: size.height * 0.5,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.asset(
                        Strings
                            .signUpPhoto, // Replace with your image asset path
                        fit: BoxFit.cover,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.black
                                  .withValues(alpha: 0.5), // Transparent black
                              Colors.transparent, // Fully transparent
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Back button
          Positioned(
            top: 40, // Adjust to match your app's design
            left: 16,
            child: DefaultBackIcon(
              onPressed: () => Navigator.pop(context),
            ),
          ),

          // Sign-up form
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: size.height * 0.6,
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
                                      fontWeight: FontWeight.w600,
                                      fontSize: 20.sp),
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
                              child: const DefaultTextField.normal(
                                hintText: 'First Name',
                              ),
                            ),
                            SizedBox(width: 16.w),
                            Expanded(
                              child: const DefaultTextField.normal(
                                hintText: 'Last Name',
                              ),
                            ),
                          ],
                        ),
                      ),
                      16.verticalSpace,
                      Flexible(
                        child: const DefaultTextField.normal(
                          hintText: 'Email',
                          keyboardType: TextInputType.emailAddress,
                        ),
                      ),
                      16.verticalSpace,
                      Flexible(
                        child: const DefaultTextField.password(
                          hintText: 'Password',
                        ),
                      ),
                      16.verticalSpace,
                      Flexible(child: TermsAndConditions()),
                      16.verticalSpace,
                      Flexible(
                          child: PrimaryButton(
                        text: "Create an account",
                        onPressed: () {},
                        isLoading: false,
                      ))
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
