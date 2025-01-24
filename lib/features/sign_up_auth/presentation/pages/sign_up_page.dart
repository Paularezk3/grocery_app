// lib\features\sign_up_auth\presentation\pages\sign_up_page.dart

import 'dart:ui';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_app/common/strings.dart';
import 'package:grocery_app/core/themes/app_colors.dart';
import '../../../../common/components/default_back_icon.dart';
import '../../../../common/components/primary_button.dart';
import '../../../../core/utils/snackbar_utils.dart';
import '../bloc/sign_up_auth_bloc.dart';
import '../bloc/sign_up_auth_state.dart';
import '../widgets/sign_up_form.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: BlocConsumer<SignUpAuthBloc, SignUpAuthState>(
          listener: (context, state) {
        if (state is SignUpSuccessState) {
          // todo: make it when pop up make the background blured
          showDialog(
            context: context,
            barrierDismissible:
                false, // Prevent dismissing the dialog by tapping outside
            builder: (context) {
              return Stack(
                children: [
                  BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5)),
                  Center(
                    child: Dialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32),
                      ),
                      child: SizedBox(
                        width: 333,
                        height: size.height < 400 ? size.height : 400,
                        child: Stack(
                          alignment: Alignment.topCenter,
                          children: [
                            // Confetti Animation Widget
                            Positioned.fill(
                              child: ConfettiWidget(
                                confettiController: ConfettiController(
                                  duration: const Duration(seconds: 3),
                                )..play(),
                                blastDirectionality:
                                    BlastDirectionality.explosive,
                                shouldLoop: false,
                                colors: const [
                                  AppColors.lightYellow,
                                  AppColors.orange,
                                  AppColors.gPercent,
                                  Colors.pink,
                                  Colors.blue,
                                ],
                                numberOfParticles:
                                    100, // Increase for more confetti
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // Title
                                  Text(
                                    "Congratulations!",
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineMedium
                                        ?.copyWith(
                                          color: AppColors.orange,
                                          fontWeight: FontWeight.bold,
                                        ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 16),

                                  // User's First and Last Name
                                  Text(
                                    '${state.message.firstName} ${state.message.lastName}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.copyWith(
                                          fontWeight: FontWeight.w600,
                                        ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 40),

                                  //TODO: Sign in button animation to sign in page
                                  // Primary Button
                                  Flexible(
                                    child: Align(
                                      alignment: Alignment.bottomCenter,
                                      child: PrimaryButton(
                                        text: 'Sign In',
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        } else if (state is SignUpErrorState) {
          context.showSnackBar(context, state.error);
        }
      }, builder: (context, state) {
        return Stack(
          children: [
            // Background image with overlay
            _backgroundImage(size),

            // Back button
            Positioned(
              top: 40, // Adjust to match your app's design
              left: 16,
              child: DefaultBackIcon(
                onPressed: () => Navigator.pop(context),
              ),
            ),

            // Sign-up form
            SignUpForm(),
          ],
        );
      }),
    );
  }

  Positioned _backgroundImage(Size size) {
    return Positioned.fill(
      child: Column(
        children: [
          SizedBox(
            height: size.height * 0.5,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(
                  Strings.signUpPhoto, // Replace with your image asset path
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
    );
  }
}
