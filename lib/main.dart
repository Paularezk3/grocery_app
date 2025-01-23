import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grocery_app/features/onboarding/presentation/pages/onboarding_screen.dart';
import 'package:grocery_app/features/sign_up_auth/presentation/bloc/sign_up_auth_bloc.dart';
import 'core/config/routes/route_names.dart';
import 'core/themes/app_theme.dart';
import 'features/login_auth/presentation/bloc/login_auth_bloc.dart';
import 'features/onboarding/presentation/pages/splash_screen.dart';

void main() {
  runApp(const GroceryApp());
}

class GroceryApp extends StatelessWidget {
  const GroceryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LoginAuthBloc>(
          create: (context) => LoginAuthBloc(),
        ),
        BlocProvider<SignUpAuthBloc>(
          create: (context) => SignUpAuthBloc(),
        ),
      ],
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: true,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          initialRoute: '/splash',
          routes: {
            RouteNames.splashScreen: (context) => const SplashScreen(),
            RouteNames.onboarding: (context) => const OnboardingPage(),
            // '/login': (context) => const LoginPage(),
          },
        ),
      ),
    );
  }
}
