import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocery_app/features/checkout/presentation/pages/order_tracking_page.dart';
import '../../../../common/components/primary_button.dart';
import '../../../../common/strings.dart';
import '../../../../core/config/setup_dependencies.dart';
import '../../../../core/themes/app_colors.dart';
import '../../../../core/utils/analytics_service.dart';

class ThankYouPage extends StatelessWidget {
  const ThankYouPage({super.key});

  @override
  Widget build(BuildContext context) {
    getIt<AnalyticsService>().logScreenView(screenName: "Thank you Page");
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.whiteBackground,
        body: Column(
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
                      "Thank You",
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
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                      flex: 4,
                      child: Image.asset(Strings.onBoardingDeliveryPhoto)),
                  Spacer(),
                  Flexible(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 26.0),
                        child: Column(
                          children: [
                            Text(
                              "Your Order in process",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w600, fontSize: 20),
                            ),
                            16.verticalSpace,
                            Text(
                              "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w400, fontSize: 14),
                            ),
                          ],
                        ),
                      ))
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(color: AppColors.white),
              height: 90,
              child: Hero(
                tag: "wohooo",
                child: PrimaryButton(
                  text: "Track Your Order",
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            OrderTrackingPage(),
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
