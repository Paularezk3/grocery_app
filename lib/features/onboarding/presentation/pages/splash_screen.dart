import 'package:flutter/material.dart';
import 'package:grocery_app/common/strings.dart';
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

    // Navigate to onboarding after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (context.mounted) {
        Navigator.pushReplacementNamed(context, '/onboarding');
      }
    });
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
