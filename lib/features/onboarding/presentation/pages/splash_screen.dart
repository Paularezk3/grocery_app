import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:grocery_app/common/strings.dart';
import 'package:grocery_app/core/config/routes/route_names.dart';
import 'package:grocery_app/core/themes/app_colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late User? user;

  @override
  void initState() {
    super.initState();

    // Initialize the animation controller and animation
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true, count: 2);

    _animation = Tween<double>(begin: 0, end: 20).animate(CurvedAnimation(
      parent: _controller,
      reverseCurve: Curves.easeIn,
      curve: Curves.bounceIn,
    ));

    // Check authentication state and navigate accordingly
    Future.delayed(const Duration(seconds: 3), _navigateToNextScreen);
    user = FirebaseAuth.instance.currentUser;
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
      // Update the token in Firestore for the signed-in user
      if (user != null) {
        FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .update({'fcmToken': newToken});
      }
    });
  }

  Future<void> _navigateToNextScreen() async {
    // user = FirebaseAuth.instance.currentUser;

    if (context.mounted) {
      if (user != null) {
        // User is signed in
        Navigator.pushReplacementNamed(context, RouteNames.homePage);
      } else {
        // User is not signed in
        Navigator.pushReplacementNamed(context, RouteNames.onboarding);
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightYellow,
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(flex: 3),
            Flexible(
              flex: 4,
              child: Center(
                child: Column(
                  children: [
                    AnimatedBuilder(
                      animation: _animation,
                      builder: (context, child) {
                        return Transform.translate(
                          offset: Offset(0, -_animation.value),
                          child: child,
                        );
                      },
                      child: Image.asset(
                        Strings.splashScreenPhoto,
                        alignment: Alignment.center,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      "Fresh Fruits",
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .headlineLarge!
                          .copyWith(
                              color: AppColors.whiteText,
                              fontSize: 40,
                              letterSpacing: 2,
                              fontWeight: FontWeight.w900),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
