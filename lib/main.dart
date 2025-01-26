import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grocery_app/core/config/database_helper.dart';
import 'package:grocery_app/features/home/presentation/bloc/home_page_bloc.dart';
import 'package:grocery_app/features/home/presentation/pages/main_home_page.dart';
import 'package:grocery_app/features/login_auth/domain/usecases/login_user.dart';
import 'package:grocery_app/features/onboarding/presentation/pages/onboarding_screen.dart';
import 'package:grocery_app/features/product_details_page/data/datasources/local_product_details_datasource.dart';
import 'package:grocery_app/features/product_details_page/data/repositories/product_details_repository_impl.dart';
import 'package:grocery_app/features/product_details_page/domain/repositories/product_details_repository.dart';
import 'package:grocery_app/features/product_details_page/domain/usecases/get_product_details.dart';
import 'package:grocery_app/features/sign_up_auth/data/repositories/sign_up_repository_impl.dart';
import 'package:grocery_app/features/sign_up_auth/domain/usecases/sign_up_user.dart';
import 'package:grocery_app/features/sign_up_auth/presentation/bloc/sign_up_auth_bloc.dart';
import 'core/config/routes/route_names.dart';
import 'core/themes/app_theme.dart';
import 'features/fruits_category_page.dart/presentation/pages/fruits_category_page.dart';
import 'features/login_auth/data/repositories/mock_firebase_login_repository.dart';
import 'features/login_auth/presentation/bloc/login_auth_bloc.dart';
import 'features/login_auth/presentation/pages/login_page.dart';
import 'features/onboarding/presentation/pages/splash_screen.dart';
import 'features/product_details_page/data/datasources/remote_product_details_datasource.dart';
import 'features/product_details_page/presentation/blocs/product_details_page_bloc.dart';
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
    final databaseInstance = DatabaseHelper.instance.database;
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MultiBlocProvider(
      providers: [
        BlocProvider<LoginAuthBloc>(
          create: (context) => LoginAuthBloc(
              loginUser: LoginUser(MockFirebaseLoginRepository())),
        ),
        BlocProvider<SignUpAuthBloc>(
          create: (context) =>
              SignUpAuthBloc(signUpUser: SignUpUser(MockSignUpRepository())),
        ),
        BlocProvider<HomePageBloc>(
          create: (context) => HomePageBloc(),
        ),
        BlocProvider<ProductDetailsPageBloc>(
          create: (context) => ProductDetailsPageBloc(
              getProductDetails: GetProductDetails(ProductDetailsRepositoryImpl(
                  localDataSource:
                      LocalProductDetailsDataSource(databaseInstance),
                  remoteDataSource: RemoteProductDetailsDataSource(
                      FirebaseFirestore.instance)))),
        )
      ],
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) => MaterialApp(
          theme: AppTheme.lightTheme,
          initialRoute: '/splash',
          routes: {
            RouteNames.splashScreen: (context) => const SplashScreen(),
            RouteNames.onboarding: (context) => const OnboardingPage(),
            RouteNames.login: (context) => LoginPage(),
            RouteNames.signUp: (context) => SignUpPage(),
            RouteNames.homePage: (context) => MainHomePage(),
            RouteNames.cartPage: (context) => MainHomePage(pageIndex: 2),
            RouteNames.categoriesPage: (context) => MainHomePage(pageIndex: 1),
            RouteNames.favouritesPage: (context) => MainHomePage(pageIndex: 3),
            RouteNames.profilePage: (context) => MainHomePage(pageIndex: 4),
            RouteNames.fruitsCategoryPage: (context) => FruitsCategoryPage(),
          },
        ),
      ),
    );
  }
}
