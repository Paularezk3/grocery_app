import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocery_app/features/checkout/presentation/pages/write_reviews.dart';
import '../../../../common/components/primary_button.dart';
import '../../../../common/strings.dart';
import '../../../../core/config/setup_dependencies.dart';
import '../../../../core/themes/app_colors.dart';
import 'package:timelines_plus/timelines_plus.dart';

import '../../../../core/utils/analytics_service.dart';

class OrderTrackingPage extends StatelessWidget {
  const OrderTrackingPage({super.key});

  @override
  Widget build(BuildContext context) {
    getIt<AnalyticsService>().logScreenView(screenName: "Order Tracking Page");
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.whiteBackground,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 60,
              decoration: BoxDecoration(
                  color: AppColors.whiteBackground,
                  border: Border(
                      bottom:
                          BorderSide(width: 0.5, color: AppColors.lightGrey))),
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: InkWell(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.orange,
                            ),
                            child: Icon(
                              Icons.close,
                              size: 18,
                              color: AppColors.white,
                            )),
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      "Order Tracking",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 20.sp,
                        color: AppColors.blackText,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Flexible(
                    flex: 2,
                    fit: FlexFit.tight,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          right: 80.0,
                          top: 10), // Adjust this value to balance the shadow
                      child: Image.asset(
                        Strings.motorcycleImage,
                        alignment: Alignment
                            .centerRight, // Shifts the perceived center
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 3,
                    fit: FlexFit.loose,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Timeline.tileBuilder(
                        builder: TimelineTileBuilder.connected(
                          nodePositionBuilder: (context, index) => -0.5,
                          connectorBuilder: (context, index, type) {
                            if (index == 0) {
                              // Gradient connector for the first step
                              return SolidLineConnector(
                                thickness: 3,
                                color: AppColors.orange,
                              );
                            }
                            // Solid connectors for other steps
                            return DashedLineConnector(
                              color: AppColors.grey,
                            );
                          },
                          indicatorBuilder: (context, index) {
                            final position = 0.01;
                            if (index == 0) {
                              return Indicator.dot(
                                size: 18,
                                position: position,
                                color: AppColors.orange,
                              );
                            } else if (index == 1) {
                              return Indicator.outlined(
                                size: 18,
                                position: position,
                                color: AppColors.orange,
                                borderWidth: 3,
                              );
                            }

                            return Indicator.dot(
                              size: 15,
                              color: AppColors.grey,
                              position: position,
                            );
                          },
                          contentsBuilder: (context, index) => Padding(
                            padding: const EdgeInsets.only(
                                left: 24.0, right: 24, bottom: 24),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Step ${index + 1}',
                                  style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 20),
                                ),
                                Text(
                                  'Lorem ipsum dolor sit amet, adipiscing elit, sed do eiusmod',
                                  style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                          itemCount: 3,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(color: AppColors.white),
              child: Hero(
                tag: "wohooo",
                child: PrimaryButton(
                  text: "Submit review",
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            WriteReviewsPage(),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          const curve = Curves.easeInOutCubic;
                          final tween =
                              Tween(begin: Offset(1, 0), end: Offset(0, 0))
                                  .chain(CurveTween(curve: curve));
                          final offsetAnimation = animation.drive(tween);

                          return SlideTransition(
                            position: offsetAnimation,
                            child: child,
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
