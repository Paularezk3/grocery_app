import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocery_app/common/components/default_icon.dart';
import 'package:grocery_app/common/components/primary_button.dart';
import 'package:grocery_app/common/components/quantity_counter.dart';
import 'package:grocery_app/common/layout/skeleton_builder.dart';
import 'package:grocery_app/common/widget_body/error_page_state.dart';
import 'package:grocery_app/common/widget_body/unexpected_error_page.dart';
import 'package:grocery_app/core/config/routes/route_names.dart';
import 'package:grocery_app/core/themes/app_colors.dart';
import 'package:grocery_app/features/cart/presentation/bloc/cart_page_bloc.dart';
import 'package:grocery_app/features/cart/presentation/bloc/cart_page_event.dart';
import 'package:grocery_app/features/product_details_page/presentation/blocs/product_details_page_bloc.dart';
import 'package:grocery_app/features/product_details_page/presentation/blocs/product_details_page_state.dart';
import '../../../cart/domain/entity/cart_item_entity_hive.dart';
import '../blocs/product_details_page_event.dart';
import '../widgets/product_images_carousel.dart';

class ProductDetailsPage extends StatelessWidget {
  final int productId;
  const ProductDetailsPage({required this.productId, super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (didPop, result) => didPop
          ? context.read<ProductDetailsPageBloc>().add(ReturnToInitialState())
          : null,
      child: SafeArea(
          child: BlocBuilder<ProductDetailsPageBloc, ProductDetailsPageState>(
              buildWhen: (previous, current) {
        if (current is! ProductDetailsPageInitial &&
            current.runtimeType != previous.runtimeType) {
          return true;
        }
        return false;
      }, builder: (context, state) {
        if (state is ProductDetailsPageLoading) {
          return _thisPageScaffold(body: SkeletonBuilder());
        } else if (state is ProductDetailsPageError) {
          return ErrorStatePage(
              message: state.message,
              onRetry: () => context
                  .read<ProductDetailsPageBloc>()
                  .add(LoadProductDetailsPage(productId)));
        } else if (state is ProductDetailsPageInitial) {
          context
              .read<ProductDetailsPageBloc>()
              .add(LoadProductDetailsPage(productId));
          return const SkeletonBuilder();
        } else if (state is ProductDetailsPageLoaded) {
          return _thisPageScaffold(
              body: _productDetailsPageLoaded(context, state));
        } else {
          return UnexpectedErrorPage(
              onReload: () => context
                  .read<ProductDetailsPageBloc>()
                  .add(LoadProductDetailsPage(productId)));
        }
      })),
    );
  }

  Widget _thisPageScaffold({required body}) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: body,
    );
  }

  Widget _productDetailsPageLoaded(
      BuildContext context, ProductDetailsPageLoaded state) {
    return Stack(
      children: [
        CustomScrollView(slivers: [
          SliverAppBar(
            backgroundColor: AppColors.black,
            pinned: true,
            collapsedHeight: 50,
            toolbarHeight: 50,
            expandedHeight: MediaQuery.of(context).size.height * 0.33,
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.parallax,
              background: ProductImagesCarousel(
                carousel: state.product.carouselImagesBase64,
              ),
            ),
            leading: DefaultIcon.back(
              onPressed: () => Navigator.of(context).pop(),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.share_rounded, color: AppColors.white),
                onPressed: () {}, // Add share functionality
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      4.verticalSpace,
                      Text(state.product.productName.toUpperCase(),
                          style: GoogleFonts.poppins(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.blackText,
                          )),
                      4.verticalSpace,
                      Text(state.product.title,
                          style: GoogleFonts.poppins(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColors.blackText,
                          )),
                      8.verticalSpace,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("\$${state.product.price.toStringAsFixed(1)}",
                              style: GoogleFonts.poppins(
                                fontSize: 24.sp,
                                fontWeight: FontWeight.w500,
                                color: AppColors.lightYellow,
                              )),
                          QuantityCounter(
                            counterValue: state.quantity,
                            onIncrement: () {
                              context
                                  .read<ProductDetailsPageBloc>()
                                  .add(IncrementQuantityCounter());
                            },
                            onDecrement: () {
                              context
                                  .read<ProductDetailsPageBloc>()
                                  .add(DecrementQuantityCounter());
                            },
                          ),
                        ],
                      ),
                      12.verticalSpace,
                      _buildReviewsNumber(state),
                      DefaultTabController(
                        length: 2,
                        child: Column(
                          mainAxisSize:
                              MainAxisSize.min, // Shrink-wrap the children
                          children: [
                            TabBar(
                              labelColor: AppColors.blackText,
                              unselectedLabelColor: AppColors.grey,
                              indicatorColor: AppColors.lightYellow,
                              tabs: const [
                                Tab(text: "Description"),
                                Tab(text: "Reviews"),
                              ],
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.6,
                              child: TabBarView(
                                children: [
                                  SingleChildScrollView(
                                    child: Text(
                                      state.product.description,
                                      style: GoogleFonts.poppins(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w400,
                                        color: AppColors.blackText,
                                      ),
                                    ),
                                  ),
                                  SingleChildScrollView(
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: state.product.reviews.reviews
                                            .map((review) {
                                          return Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 8.0),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                CircleAvatar(
                                                  child: Text(review.name[0]),
                                                ),
                                                8.horizontalSpace,
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        review.name,
                                                        style:
                                                            GoogleFonts.poppins(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 14.sp,
                                                        ),
                                                      ),
                                                      4.verticalSpace,
                                                      Text(
                                                        review.review,
                                                        style:
                                                            GoogleFonts.poppins(
                                                          fontSize: 14.sp,
                                                        ),
                                                      ),
                                                      4.verticalSpace,
                                                      Row(
                                                        children: List.generate(
                                                            review.rating
                                                                .round(),
                                                            (index) {
                                                          return Icon(
                                                            Icons.star,
                                                            color: AppColors
                                                                .lightYellow,
                                                            size: 16,
                                                          );
                                                        }),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 100,
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ]),
        _bottomPageContainer(context)
      ],
    );
  }

  Positioned _bottomPageContainer(BuildContext context) {
    return Positioned(
      bottom: 0,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 96, // Adjusted height for more padding
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            // Green Icon Button
            Container(
              width: MediaQuery.of(context).size.width * 0.3, // 20% width
              height: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.gPercent,
                borderRadius: BorderRadius.circular(32), // More rounded corners
              ),
              child: IconButton(
                onPressed: () {
                  // Handle button action
                },
                icon: const Icon(Icons.favorite, color: Colors.white),
                iconSize: 28, // Icon size
              ),
            ),
            const SizedBox(width: 16), // Spacing between buttons

            // Yellow Button with Text
            BlocBuilder<ProductDetailsPageBloc, ProductDetailsPageState>(
              buildWhen: (previous, current) {
                if (current is ProductDetailsPageLoaded &&
                    (previous as ProductDetailsPageLoaded).quantity !=
                        current.quantity) {
                  return true;
                }
                return false;
              },
              builder: (context, state) => Expanded(
                  child: PrimaryButton(
                text:
                    "ADD To Cart\n\$${((state as ProductDetailsPageLoaded).product.price * state.quantity).toStringAsFixed(1)}",
                onPressed: () {
                  final item = state.product;
                  context.read<CartPageBloc>().add(AddToCart(CartItemData(
                      id: item.productId.toString(),
                      title: item.title,
                      category: item.productName,
                      imagePath: item.carouselImagesBase64[0],
                      price: item.price,
                      quantity: state.quantity)));
                  Navigator.of(context).popAndPushNamed(RouteNames.cartPage);
                },
                height: double.infinity,
              )),
            )
          ],
        ),
      ),
    );
  }

  Row _buildReviewsNumber(ProductDetailsPageLoaded state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            // Star Icon and Rating
            DefaultIcon(
              Icons.star_rounded,
              iconSize: 26,
              iconColor: AppColors.lightYellow,
            ),
            4.horizontalSpace,
            Text(
              state.product.reviews.rating.toStringAsFixed(0),
              style: GoogleFonts.poppins(
                fontSize: 20.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.blackText,
              ),
            ),
            4.horizontalSpace,
            Text(
              "(${state.product.reviews.reviewsNumber} reviews)",
              style: GoogleFonts.poppins(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: const Color(0xFFAAAAAA),
              ),
            ),
          ],
        ),
        _reviewersStackedPhotos(),
      ],
    );
  }

  SizedBox _reviewersStackedPhotos() {
    return SizedBox(
      width: 115,
      height: 45,
      child: Stack(
        children: List.generate(
          3,
          (index) {
            final image = [
              "https://s3-alpha-sig.figma.com/img/d47b/2cc5/f550dd4d6f62ddb2d08c6a9ed5691c3a?Expires=1738540800&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=pHb4ngjYcRBft4SoPm-YwuFsS6qysSIstzan995D~gwx4EA~fzJ58L63PD5ZuYJlRjvjSjP4mSnGWl6t4aazSWP9H8-MVC0IlxwGrTPjXXXuWzv0rjWGLPctZo6tiGvB-gY6aRy2sXMjsa8MU3qQF5YWlRs4pURLcqLc74YQkJc3m0ax1eCa-lhGVrvtl19Esyw5bnL3nudDdDrxWIjxGD73r845l3YRHBWo9OFdaoP~dFeYpRZ~jxYneJ7sr36LMqoJMtfJEuZk~80S93DjunKkiD-amlbaRzt-epug9YS928s65P91y~p8z1mm5cbJbvfh6CPaRuzqv6MFxoUdEA__",
              "https://s3-alpha-sig.figma.com/img/c804/c898/ea803d64cf555b58f3ecfc269d8dd873?Expires=1738540800&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=lzzvf4v8~kizfwiIPK0QH6fTPchSVt5R25WAilD3OPBvRhwCxyu5kehuTqTegerHHbJoK2UkSM8r39bpcrrn1Z6U2~nAZ5av3oNjlh4Qzxl~10JaJQYbX3VeFrkUbkQboPeVZK4-~lGGsmlcvXYiCGzW~TaOQC5Sq0oenSRUA-RMpUj5-JwmU9S6nxk5RClMT1sEsx8gQtY~aKUdhBtPyGgTyIwUUJI50f439ys~aJ1DjSnhWzWutrT34pREtX6PNqHKGuMWonCuLIUWvDYGN-a1MkTfYyM1tuWoPZc0Ct~F0ZgoTsW1HGHCh~GPI0cvaGywlg193fp3l1op5apmtA__",
              "https://www.figma.com/file/xy2BtHhAdzzr3z42UBQr0P/image/226d0826b5d8fcfe28f780dd49d66507e6015078"
            ][index]; // Example image path
            return Positioned(
              left: index * 35, // Adjust spacing between images
              child: Container(
                width: 45, // Circle size
                height: 45,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border:
                      Border.all(color: Colors.white, width: 2), // White border
                  image: DecorationImage(
                    image: NetworkImage(
                        image), // Replace with NetworkImage if needed
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
