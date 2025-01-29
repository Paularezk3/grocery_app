import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:grocery_app/features/cart/domain/entity/cart_item_entity_hive.dart';
import 'package:grocery_app/features/cart/presentation/bloc/cart_page_bloc.dart';
import 'package:grocery_app/features/cart/presentation/bloc/cart_page_state.dart';
import '../../../../common/components/default_text_field.dart';
import '../../../../common/components/primary_button.dart';
import '../../../../core/config/routes/route_names.dart';
import '../../../../core/config/setup_dependencies.dart';
import '../../../../core/themes/app_colors.dart';
import '../../../../core/utils/analytics_service.dart';

class WriteReviewsPage extends StatefulWidget {
  const WriteReviewsPage({super.key});

  @override
  _WriteReviewsPageState createState() => _WriteReviewsPageState();
}

class _WriteReviewsPageState extends State<WriteReviewsPage> {
  double _rating = 0; // Stores selected rating
  bool isLoading = false;
  final TextEditingController _reviewController = TextEditingController();

  @override
  void initState() {
    getIt<AnalyticsService>().logScreenView(screenName: "Write Reviews Page");
    super.initState();
  }

  Future<void> _submitReview() async {
    isLoading = true;
    setState(() {});

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance
            .collection("users")
            .doc(user.uid)
            .collection("reviews")
            .add({
          "rating": _rating,
          "review": _reviewController.text.trim(),
          "timestamp": FieldValue.serverTimestamp(),
        });

        for (CartItemData item
            in (context.read<CartPageBloc>().state as CartLoadedState)
                .items
                .cartItemData) {
          final productRef =
              FirebaseFirestore.instance.collection("products").doc(item.id);

          try {
            final docSnapshot = await productRef.get();

            if (docSnapshot.exists) {
              // Extract existing reviews or initialize empty map
              final data = docSnapshot.data() as Map<String, dynamic>;
              final reviews = data["reviews"] ?? {"reviewDetails": []};

              // Ensure reviewDetails is a list
              List<dynamic> reviewDetails =
                  List.from(reviews["reviewDetails"] ?? []);

              // Append new review
              reviewDetails.add({
                "rating": _rating,
                "review": _reviewController.text.trim(),
                "name": user.displayName?.trim() == ""
                    ? "Anonymous"
                    : user.displayName?.trim() ?? "Anonymous",
              });

              // Update Firestore
              await productRef.update({
                "reviews.reviewDetails": reviewDetails,
              });
            } else {
              Exception("There's no product with this id: ${item.id}");
            }
          } catch (e) {
            print("Error submitting review for ${item.id}: $e");
          }
        }

        // Navigate to home and clear navigation stack
        Navigator.of(context).pushNamedAndRemoveUntil(
          RouteNames.homePage, // Use your RouteNames.homePage
          (route) => false,
        );
      }
    } catch (e) {
      debugPrint("Error submitting review: $e");
    }

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.whiteBackground,
        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(), // Dismiss keyboard
          behavior: HitTestBehavior
              .opaque, // Ensures taps outside input fields are detected
          child: Column(
            children: [
              // Content + Scrollable Area
              Expanded(
                child: SingleChildScrollView(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.manual,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // App Bar
                      Container(
                        height: 60,
                        decoration: BoxDecoration(
                          color: AppColors.whiteBackground,
                          border: Border(
                              bottom: BorderSide(
                                  width: 0.5, color: AppColors.lightGrey)),
                        ),
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
                                    child: Icon(Icons.close,
                                        size: 18, color: AppColors.white),
                                  ),
                                ),
                              ),
                            ),
                            Center(
                              child: Text(
                                "Write Reviews",
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

                      // Content Section
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(height: 16), // Spacing after app bar

                            // Title and Description
                            Text(
                              "Tell Us to Improve",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                fontSize: 20.sp,
                              ),
                            ),
                            16.verticalSpace,
                            Text(
                              "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w400,
                                fontSize: 14.sp,
                              ),
                            ),
                            16.verticalSpace,

                            // ⭐ Rating System ⭐
                            Text(
                              _rating.toStringAsFixed(1), // Display Rating
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                fontSize: 50.sp,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(5, (index) {
                                return IconButton(
                                  icon: Icon(
                                    index < _rating
                                        ? Icons.star
                                        : Icons.star_border,
                                    size: 40,
                                    color: Colors.orange,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _rating = index + 1.0;
                                    });
                                  },
                                );
                              }),
                            ),
                            16.verticalSpace,

                            // Review Input Field
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Let us know what you think",
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14.sp,
                                  color: AppColors.blackText,
                                ),
                              ),
                            ),
                            8.verticalSpace,
                            DefaultTextField.normal(
                              dynamicHeight: true,
                              controller: _reviewController,
                              hintText: "Write your review here",
                              isLoading: isLoading,
                              keyboardType: TextInputType.text,
                            ),
                            SizedBox(height: 80), // Extra spacing if needed
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Fixed Submit Button at Bottom
              Container(
                padding: const EdgeInsets.all(16),
                width: double.infinity,
                decoration: const BoxDecoration(color: AppColors.white),
                child: Hero(
                  tag: "wohooo",
                  child: PrimaryButton(
                    text: "Submit Review",
                    isLoading: isLoading,
                    onPressed: () => _submitReview(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
