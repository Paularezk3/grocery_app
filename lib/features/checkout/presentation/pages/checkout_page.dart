import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocery_app/common/components/default_icon.dart';
import 'package:grocery_app/common/components/primary_button.dart';
import 'package:grocery_app/common/layout/skeleton_builder.dart';
import 'package:grocery_app/common/widget_body/error_page_state.dart';
import 'package:grocery_app/common/widget_body/unexpected_error_page.dart';
import 'package:grocery_app/features/checkout/presentation/bloc/checkout_page_bloc.dart';
import 'package:grocery_app/features/checkout/presentation/bloc/checkout_page_state.dart';
import 'package:grocery_app/features/checkout/presentation/widgets/checkout_first_form.dart';

import '../../../../core/themes/app_colors.dart';
import '../bloc/checkout_page_event.dart';
import '../widgets/checkout_second_page_body.dart';
import '../widgets/the_two_circular_indicators.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final formKey = GlobalKey<FormState>();
  final formKey2 = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    double additionalHeight = 20 + MediaQuery.of(context).viewPadding.bottom;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Checkout",
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              fontSize: 20.sp,
              color: AppColors.blackText,
            ),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          leading: DefaultIcon.back(
            iconColor: AppColors.black,
            onPressed: () {
              if (!(context.read<CheckoutPageBloc>().state
                      as CheckoutPageLoaded)
                  .isFirstPage) {
                return context
                    .read<CheckoutPageBloc>()
                    .add(GoToThisPage(isFirstPage: true));
              }
              return Navigator.of(context).pop();
            },
          ),
        ),
        body: BlocBuilder<CheckoutPageBloc, CheckoutPageState>(
          builder: (context, state) {
            if (state is CheckoutPageInitial) {
              context.read<CheckoutPageBloc>().add(LoadCheckoutPage());
              return SkeletonBuilder();
            } else if (state is CheckoutPageLoaded) {
              return Stack(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      TheTwoCircularIndicators(
                        isFirstPage: state.isFirstPage,
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height -
                            MediaQuery.of(context).padding.bottom -
                            MediaQuery.of(context).padding.top -
                            90 -
                            100 -
                            80,
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 24.h,
                                horizontal: state.isFirstPage ? 24.h : 0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                PageTransitionSwitcher(
                                  duration: const Duration(milliseconds: 500),
                                  reverse: state.isFirstPage,
                                  transitionBuilder:
                                      (child, animation, secondaryAnimation) {
                                    return SlideTransition(
                                      position: Tween<Offset>(
                                        begin: const Offset(1.0, 0.0),
                                        end: Offset.zero,
                                      ).animate(animation),
                                      child: child,
                                    );
                                  },
                                  child: state.isFirstPage
                                      ? CheckoutFirstForm(
                                          key: const ValueKey("FirstPageForm"),
                                          formKey: formKey,
                                          checkoutData: state.checkoutData,
                                        )
                                      : CheckoutSecondPageBody(
                                          key: const ValueKey("SecondPageForm"),
                                          formKey: formKey2,
                                          checkoutData: state.checkoutData,
                                        ),
                                ),
                                SizedBox(
                                  height: additionalHeight,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    bottom: 0,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      width: MediaQuery.of(context).size.width,
                      decoration: const BoxDecoration(color: AppColors.white),
                      height: 90,
                      child: Hero(
                        tag: "wohooo",
                        child: PrimaryButton(
                          text: state.isFirstPage ? "Next" : "Confirm ORDER",
                          onPressed: () {
                            // if (formKey.currentState != null &&
                            //     formKey.currentState!.validate()) {
                            if (state.isFirstPage) {
                              context.read<CheckoutPageBloc>().add(GoToThisPage(
                                  isFirstPage:
                                      false)); // Trigger the transition
                              // } else {
                              //   // Confirm the order
                              // }
                              // } else {
                              //   context.showSnackBar(
                              //       context, "Please fill all required fields");
                              // }
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              );
            } else if (state is CheckoutPageError) {
              return ErrorStatePage(
                message: state.message,
                onRetry: () =>
                    context.read<CheckoutPageBloc>().add(LoadCheckoutPage()),
              );
            } else if (state is CheckoutPageLoading) {
              return SkeletonBuilder();
            } else {
              return UnexpectedErrorPage(
                onReload: () =>
                    context.read<CheckoutPageBloc>().add(LoadCheckoutPage()),
              );
            }
          },
        ),
      ),
    );
  }
}
