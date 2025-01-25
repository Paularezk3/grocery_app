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
import '../../../../common/components/primary_button.dart';
import '../../../../common/widget_body/unexpected_error_page.dart';
import '../../../../core/config/routes/route_names.dart';
import '../widgets/favourite_icon_animation.dart';

class HomePage extends StatelessWidget {
  final Function(int) onTabChange;
  const HomePage({super.key, required this.onTabChange});

  @override
  Widget build(BuildContext context) {
    final homePageBloc = context.read<HomePageBloc>();
    return Scaffold(
      backgroundColor: AppColors.whiteBackground,
      body:
          BlocConsumer<HomePageBloc, HomePageState>(listener: (context, state) {
        if (state is HomePageErrorState && state.isSignedOut) {
          Navigator.of(context).push(
            PageRouteBuilder(
              opaque: false, // Ensures the background is visible
              pageBuilder: (context, animation, secondaryAnimation) {
                return Stack(
                  children: [
                    // Blurred Background
                    BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                      child:
                          Container(color: Colors.black.withValues(alpha: 0.2)),
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
                  const DefaultIcon(
                    Icons.notifications_rounded,
                    hasNotification: true, // Custom parameter for notification
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

            GridView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              physics:
                  const NeverScrollableScrollPhysics(), // Non-scrollable grid
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Two columns
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1 / 1.5, // 1 width : 1.5 height (200px items)
              ),
              itemCount: 4, // Four items only
              itemBuilder: (context, index) {
                final item = state.homePageModel.trendingDeals[index];
                return Stack(
                  children: [
                    // Product Image with Background
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            offset: const Offset(0, 2),
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
                    ),

                    // Favorite Button
                    Positioned(
                      top: 8,
                      left: 8,
                      child: GestureDetector(
                        onTap: () {
                          // Handle favorite action here
                        },
                        child: FavouriteIconAnimation(
                          item: item,
                          onPressed: () {},
                        ),
                      ),
                    ),

                    // Product Details (Title and Price)
                    Positioned(
                      bottom: 12,
                      left: 12,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Product Title
                          Text(
                            item.title,
                            style:
                                Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              shadows: [
                                Shadow(
                                  color: Colors.black.withValues(alpha: 0.5),
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 4),

                          // Product Price
                          Text(
                            '\$${item.price}', // Replace with dynamic price if available
                            style:
                                Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              shadows: [
                                Shadow(
                                  color: Colors.black.withValues(alpha: 0.5),
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
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
                        // Navigator.pushNamed(context, RouteNames.trendingDeals);
                      }),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
