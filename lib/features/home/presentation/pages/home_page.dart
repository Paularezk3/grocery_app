import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocery_app/common/components/default_icon.dart';
import 'package:grocery_app/common/components/secondary_button.dart';
import 'package:grocery_app/common/layout/skeleton_builder.dart';
import 'package:grocery_app/common/widget_body/error_page_state.dart';
import 'package:grocery_app/core/themes/app_colors.dart';
import 'package:grocery_app/features/home/presentation/bloc/home_page_bloc.dart';
import 'package:grocery_app/features/home/presentation/bloc/home_page_event.dart';
import 'package:grocery_app/features/home/presentation/bloc/home_page_state.dart';
import '../../../../common/common_with_different_pages/fruits_category_card_grid.dart';
import '../../../../common/components/primary_button.dart';
import '../../../../common/widget_body/unexpected_error_page.dart';
import '../../../../core/config/routes/route_names.dart';
import 'package:showcaseview/showcaseview.dart';

import '../widgets/notifications_dialog.dart';

class HomePage extends StatelessWidget {
  final Function(int) onTabChange;
  static final GlobalKey _notificationKey = GlobalKey();
  const HomePage({super.key, required this.onTabChange});

  @override
  Widget build(BuildContext context) {
    final homePageBloc = context.read<HomePageBloc>();
    return Scaffold(
      backgroundColor: AppColors.whiteBackground,
      body:
          BlocConsumer<HomePageBloc, HomePageState>(listener: (context, state) {
        if (state is HomePageErrorState && state.isSignedOut) {
          _signedInByMistake(context);
        }

        if (state is HomePageLoadedState &&
            state.homePageModel.shouldShowShowcase) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ShowCaseWidget.of(context).startShowCase([_notificationKey]);
          });
        }
      }, builder: (context, state) {
        if (state is HomePageIdleState) {
          homePageBloc.add(LoadHomePage());
          return SkeletonBuilder();
        }
        if (state is HomePageLoadedState) {
          return _homePageLoadedState(state, context);
        } else if (state is HomePageErrorState) {
          return ErrorStatePage(
            onRetry: () => homePageBloc.add(LoadHomePage()),
            title: 'Error Happened',
            message: state.message,
          );
        } else if (state is HomePageLoadingState) {
          return SkeletonBuilder();
        } else {
          return UnexpectedErrorPage(
            onReload: () => homePageBloc.add(LoadHomePage()),
          );
        }
      }),
    );
  }

  Widget _homePageLoadedState(HomePageLoadedState state, BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),

            // 1. Title (depending on time) and Notification Icon
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        state.homePageModel
                            .greetingMessage, // Get greeting message dynamically
                        style: GoogleFonts.poppins(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.darkerGrey,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      Text(
                        "${state.homePageModel.userFirstName} ${state.homePageModel.userLastName}",
                        style: Theme.of(context).textTheme.headlineMedium,
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                  Showcase(
                    key: _notificationKey,
                    description: 'Tap here to check your notifications!',
                    descriptionPadding: const EdgeInsets.all(16),
                    descTextStyle: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.darkerGrey,
                    ),
                    overlayColor: AppColors.lightYellow,
                    overlayOpacity: 0.8,
                    targetShapeBorder: const CircleBorder(),
                    showArrow: true,
                    tooltipBackgroundColor: AppColors.white,
                    scaleAnimationDuration: Duration(milliseconds: 300),
                    tooltipBorderRadius: BorderRadius.circular(12),
                    targetPadding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    scaleAnimationCurve: Curves.easeInOutCubic,
                    blurValue: 2.5,
                    tooltipActions: [
                      TooltipActionButton(
                          type: TooltipDefaultActionType.skip,
                          borderRadius: BorderRadius.circular(32),
                          backgroundColor: AppColors.lightYellow,
                          textStyle: GoogleFonts.poppins(
                              fontSize: 14, fontWeight: FontWeight.bold))
                    ],
                    child: DefaultIcon(
                      Icons.notifications_rounded,
                      hasNotification: true,
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => NotificationsDialog(
                              userId: state.homePageModel.uidFirebase),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // 2. Carousel (Horizontally Scrollable)
            SizedBox(
              height: 162,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                itemCount:
                    state.homePageModel.carouselItems.length, // Dynamic items
                itemBuilder: (context, index) {
                  final item = state.homePageModel.carouselItems[index];
                  return Padding(
                    padding: EdgeInsets.only(
                      right:
                          index == state.homePageModel.carouselItems.length - 1
                              ? 0
                              : 16,
                    ),
                    child: Ink(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        color: AppColors.lightGrey,
                        boxShadow: [
                          BoxShadow(
                            offset: const Offset(9, 0),
                            blurRadius: 19,
                            spreadRadius: 2,
                            color: AppColors.black.withValues(alpha: 0.05),
                          ),
                        ],
                        image: DecorationImage(
                          image: AssetImage(item.imageAssetPath),
                          fit: BoxFit.cover,
                        ),
                      ),
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: InkWell(
                        onTap: () {},
                        enableFeedback: true,
                        borderRadius: BorderRadius.circular(18),
                        child: Stack(
                          children: [
                            // Blur Gradient
                            Positioned.fill(
                              child: Container(
                                alignment: Alignment.centerLeft,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                clipBehavior: Clip.antiAlias,
                                child: ShaderMask(
                                  shaderCallback: (rect) {
                                    return LinearGradient(
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                      colors: [
                                        Colors.black.withValues(
                                            alpha: 0.5), // Full blur
                                        Colors.transparent, // No blur
                                      ],
                                      stops: [
                                        0.0,
                                        0.8
                                      ], // Control blur distribution
                                    ).createShader(rect);
                                  },
                                  blendMode: BlendMode.lighten,
                                  child: BackdropFilter(
                                    filter: ImageFilter.blur(
                                      sigmaX: 10,
                                      sigmaY: 10,
                                    ),
                                    child: Container(
                                      color: Colors
                                          .transparent, // Required for BackdropFilter
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            // Text at Bottom Left
                            Positioned(
                              bottom: 16,
                              left: 16,
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width *
                                    0.7 *
                                    0.55,
                                child: Text(
                                  item.title,
                                  maxLines: 3,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall
                                      ?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),

            // 3. "Categories" Title and Right Arrow Icon
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Categories",
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  Hero(
                    tag: 'backButton',
                    child: const DefaultIcon(
                      Icons.arrow_forward_rounded,
                      iconSize: 20,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // 4. Horizontal Scrollable Small Grid
            SizedBox(
              height: 90,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                itemCount: state.homePageModel.categoryItems.length,
                itemBuilder: (context, index) {
                  final category = state.homePageModel.categoryItems[index];
                  return Padding(
                      padding: EdgeInsets.only(
                          right: index ==
                                  state.homePageModel.categoryItems.length - 1
                              ? 0
                              : 16),
                      child: Ink(
                        width: 93,
                        decoration: BoxDecoration(
                          color: AppColors
                              .white, // Background color for categories
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withValues(alpha: 0.2),
                              blurRadius: 9,
                              offset: const Offset(9, 0),
                            ),
                          ],
                        ),
                        child: InkWell(
                          enableFeedback: true,
                          onTap: () {
                            // Use the callback to switch to index 1
                            onTabChange(1);
                          },
                          borderRadius: BorderRadius.circular(18),
                          child: Center(
                            child: ColorFiltered(
                              colorFilter: ColorFilter.mode(
                                AppColors
                                    .purple, // The desired color to fill the image
                                BlendMode
                                    .srcIn, // Replace the image's original color with the specified color
                              ),
                              child: Image.asset(
                                category.imageAssetPath,
                                fit: BoxFit.contain,
                                width: 50,
                                height: 50,
                              ),
                            ),
                          ),
                        ),
                      ));
                },
              ),
            ),
            const SizedBox(height: 24),

            // 5. "Trending Deals" Title and Right Arrow Icon
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Trending Deals",
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const DefaultIcon(
                    Icons.arrow_forward_ios_rounded,
                    iconSize: 20,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
              ),
              child: Hero(
                tag: 'fruitsCategoryGrid',
                child: FruitsCategoryCardGrid(
                    onPressed: (_) {
                      Navigator.pushNamed(
                          context, RouteNames.fruitsCategoryPage);
                    },
                    trendingDeals: state.homePageModel.trendingDeals),
              ),
            ),
            24.verticalSpace,
            Align(
              alignment: Alignment.center,
              child: SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: SecondaryButton(
                      text: "More",
                      onPressed: () {
                        Navigator.pushNamed(
                            context, RouteNames.fruitsCategoryPage);
                      }),
                ),
              ),
            ),
            70.verticalSpace
          ],
        ),
      ),
    );
  }

  void _signedInByMistake(BuildContext context) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false, // Ensures the background is visible
        pageBuilder: (context, animation, secondaryAnimation) {
          return Stack(
            children: [
              // Blurred Background
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Container(color: Colors.black.withValues(alpha: 0.2)),
              ),
              // Dialog Content
              Center(
                child: Dialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32),
                  ),
                  child: SizedBox(
                    child: Stack(
                      alignment: Alignment.topCenter,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Error Happened!",
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium
                                    ?.copyWith(
                                      color: AppColors.red,
                                      fontWeight: FontWeight.bold,
                                    ),
                                textAlign: TextAlign.center,
                              ),
                              16.verticalSpace,
                              Text(
                                "Please Sign Out",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 40),
                              Hero(
                                tag: 'signInButton',
                                child: PrimaryButton(
                                  text: 'Sign Out',
                                  onPressed: () {
                                    Navigator.pushNamedAndRemoveUntil(
                                      context,
                                      RouteNames.login,
                                      (route) => false,
                                    );
                                  },
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
      ),
    );
  }
}
