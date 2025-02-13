// lib\features\sign_up_auth\presentation\pages\sign_up_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_app/common/strings.dart';
import 'package:grocery_app/core/utils/snackbar_utils.dart';
import 'package:grocery_app/features/home/presentation/bloc/home_page_event.dart';
import 'package:grocery_app/features/login_auth/presentation/bloc/login_auth_bloc.dart';
import 'package:grocery_app/features/login_auth/presentation/bloc/login_auth_state.dart';
import '../../../../common/components/default_icon.dart';
import '../../../../core/config/setup_dependencies.dart';
import '../../../../core/utils/analytics_service.dart';
import '../../../home/presentation/bloc/home_page_bloc.dart';
import '../../../home/presentation/pages/main_home_page.dart';
import '../widgets/sign_in_form.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    getIt<AnalyticsService>().logScreenView(screenName: "Sign in Page");
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: BlocConsumer<LoginAuthBloc, LoginAuthState>(
        listener: (context, state) {
          if (state is LoginSuccessState) {
            // Push home page and pop all the stack
            context.read<HomePageBloc>().add(ResetHomePageState());
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const MainHomePage()),
              (route) => false,
            );
          } else if (state is LoginErrorState) {
            // Show reusable SnackBar widget
            context.showSnackBar(context, state.error);
          }
        },
        builder: (context, state) {
          return Stack(
            children: [
              // Background image with overlay
              _backgroundImage(size),

              // Back button
              Positioned(
                top: 40,
                left: 16,
                child: DefaultIcon.back(
                  onPressed: () => Navigator.pop(context),
                ),
              ),

              // Sign-in form
              SignInForm(),
            ],
          );
        },
      ),
    );
  }

  Positioned _backgroundImage(Size size) {
    return Positioned.fill(
      child: Column(
        children: [
          SizedBox(
            height: size.height * 0.6,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(
                  Strings.signInPhoto,
                  fit: BoxFit.cover,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
