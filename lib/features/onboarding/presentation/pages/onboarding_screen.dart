import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grocery_app/common/components/primary_button.dart';
import 'package:grocery_app/common/components/secondary_button.dart';
import 'package:grocery_app/common/components/secondary_outlined_button.dart';
import 'package:grocery_app/core/config/routes/route_names.dart';
import 'package:grocery_app/core/themes/app_colors.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../common/components/default_icon.dart';
import '../widgets/onboarding_content.dart';

class OnboardingPage extends StatefulWidget {
  final int? onBoardingPage;
  const OnboardingPage({this.onBoardingPage, super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  late int _currentPage;

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
  void initState() {
    _currentPage = widget.onBoardingPage ?? 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      backgroundColor: AppColors.white,
      body: Column(
        children: [
          _buildPageView(),
          _buildPageIndicator(),
          25.verticalSpace,
          _buildActionButton(context),
          25.verticalSpace,
        ],
      ),
    );
  }

  Column _buildActionButton(BuildContext context) {
    return Column(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: _currentPage == 2 ? (60) : 0, // Animates height
          child: Hero(
            tag: "createAccount",
            child: SecondaryButton(
              text: 'Create An Account',
              onPressed: () {
                // Handle secondary button action
                Navigator.pushNamed(context, RouteNames.signUp);
              },
            ),
          ),
        ),
        25.verticalSpace,
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
                ? Hero(
                    tag: "signInButton",
                    child: SecondaryOutlinedButton(
                      text: 'Login',
                      onPressed: () {
                        // Handle secondary button action
                        Navigator.pushNamed(context, RouteNames.login);
                      },
                    ),
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
      ],
    );
  }

  SmoothPageIndicator _buildPageIndicator() {
    return SmoothPageIndicator(
      controller: _pageController,
      count: _onboardingTitleTexts.length,
      effect: SwapEffect(
        activeDotColor: AppColors.gPercent,
        dotHeight: 6,
        dotWidth: 23,
        dotColor: AppColors.lightGrey,
      ),
      onDotClicked: (index) => _pageController.animateToPage(index,
          duration: Duration(milliseconds: 300), curve: Curves.easeInOutCubic),
    );
  }

  Expanded _buildPageView() {
    return Expanded(
      child: PageView.builder(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentPage = index;
          });
        },
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _onboardingTitleTexts.length,
        itemBuilder: (context, index) {
          return OnboardingContent(
            title: _onboardingTitleTexts[index],
            body: _onboardingBodyTexts[index],
            isFirstPage: index == 0,
            isLastPage: index == _onboardingTitleTexts.length - 1,
          );
        },
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: _currentPage == 0
          ? null
          : DefaultIcon.back(
              iconColor: AppColors.orange,
              iconSize: 28,
              onPressed: () {
                _pageController.previousPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOutCubic,
                );
              }),
    );
  }
}
