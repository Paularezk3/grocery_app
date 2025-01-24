import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grocery_app/core/utils/snackbar_utils.dart';
import 'package:grocery_app/features/onboarding/presentation/pages/onboarding_screen.dart';
import 'package:grocery_app/features/sign_up_auth/data/repositories/mock_sign_up_repository.dart';
import 'package:grocery_app/features/sign_up_auth/domain/usecases/sign_up_user.dart';
import 'package:grocery_app/features/sign_up_auth/presentation/bloc/sign_up_auth_bloc.dart';
import 'core/config/routes/route_names.dart';
import 'core/themes/app_theme.dart';
import 'features/login_auth/presentation/bloc/login_auth_bloc.dart';
import 'features/login_auth/presentation/pages/login_page.dart';
import 'features/onboarding/presentation/pages/splash_screen.dart';
import 'features/sign_up_auth/presentation/pages/sign_up_page.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(GroceryApp());
}

class GroceryApp extends StatelessWidget {
  const GroceryApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MultiBlocProvider(
      providers: [
        BlocProvider<LoginAuthBloc>(
          create: (context) => LoginAuthBloc(),
        ),
        BlocProvider<SignUpAuthBloc>(
          create: (context) =>
              SignUpAuthBloc(signUpUser: SignUpUser(MockSignUpRepository())),
        ),
      ],
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) => MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          initialRoute: '/splash',
          routes: {
            RouteNames.splashScreen: (context) => const SplashScreen(),
            RouteNames.onboarding: (context) => const OnboardingPage(),
            RouteNames.login: (context) => LoginPage(),
            RouteNames.signUp: (context) => SignUpPage(),
          },
        ),
      ),
    );
  }
}
