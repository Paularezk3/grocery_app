import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grocery_app/common/components/primary_button.dart';
import 'package:grocery_app/common/components/secondary_button.dart';
import 'package:grocery_app/common/components/secondary_outlined_button.dart';
import 'package:grocery_app/common/strings.dart';
import 'package:grocery_app/core/config/routes/route_names.dart';
import 'package:grocery_app/core/themes/app_colors.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<String> _onboardingTitleTexts = [
    'Welcome to Fresh Fruits!',
    'We provide the best quality Fruits for your family.',
    'Fast and responsible delivery by our courier.',
  ];
  final List<String> _onboardingBodyTexts = [
    'Discover the best fruits delivered straight to your home.',
    'Only the freshest and highest-quality produce.',
    'Enjoy quick and reliable delivery, every time.',
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 400;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: _currentPage == 0
            ? null
            : IconButton(
                onPressed: () {
                  _pageController.previousPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOutCubic,
                  );
                },
                icon: Icon(
                  Icons.arrow_back_rounded,
                  color: AppColors.orange,
                  size: 28,
                ),
              ),
      ),
      backgroundColor: AppColors.white,
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              physics: NeverScrollableScrollPhysics(),
              itemCount: _onboardingTitleTexts.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      20.verticalSpace,
                      Expanded(
                        flex: 3,
                        child: Image.asset(
                          Strings.onBoardingFruitsPhoto,
                          fit: BoxFit.contain,
                        ),
                      ),
                      Text(
                        _onboardingTitleTexts[index],
                        style:
                            Theme.of(context).textTheme.headlineLarge?.copyWith(
                                  fontSize: isSmallScreen ? 20 : 28,
                                  fontWeight: FontWeight.bold,
                                ),
                        textAlign: TextAlign.center,
                      ),
                      if (_currentPage == 0) ...[
                        20.verticalSpace,
                        Text(
                          "Grocery application",
                          style: Theme.of(context).textTheme.headlineSmall,
                          textAlign: TextAlign.center,
                        ),
                      ],
                      20.verticalSpace,
                      Text(
                        _onboardingBodyTexts[index],
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.notReallyBlackText,
                              fontWeight: FontWeight.w300,
                              fontSize: isSmallScreen ? 14 : 16,
                            ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          SmoothPageIndicator(
            controller: _pageController,
            count: _onboardingTitleTexts.length,
            effect: SwapEffect(
              activeDotColor: AppColors.gPercent,
              dotHeight: 6,
              dotWidth: 23,
              dotColor: AppColors.lightGrey,
            ),
            onDotClicked: (index) => _pageController.animateToPage(index,
                duration: Duration(milliseconds: 300),
                curve: Curves.easeInOutCubic),
          ),
          25.verticalSpace,
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: _currentPage == 2 ? (60 + 16) : 0, // Animates height
            padding: EdgeInsets.symmetric(vertical: 8),
            child: SecondaryButton(
              text: 'Create An Account',
              onPressed: () {
                // Handle secondary button action
                Navigator.pushReplacementNamed(context, RouteNames.login);
              },
            ),
          ),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, animation) => FadeTransition(
              opacity: animation,
              child: child,
            ),
            child: Padding(
              key: ValueKey(
                  _currentPage == 2), // Ensure a unique key for each child
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: _currentPage == 2
                  ? SecondaryOutlinedButton(
                      text: 'Login',
                      onPressed: () {
                        // Handle secondary button action
                        Navigator.pushReplacementNamed(
                            context, RouteNames.login);
                      },
                    )
                  : PrimaryButton(
                      text: 'Next',
                      onPressed: () {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      },
                    ),
            ),
          ),
          25.verticalSpace,
        ],
      ),
    );
  }
}
