import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grocery_app/common/components/default_icon.dart';
import 'package:grocery_app/core/themes/app_colors.dart';

import '../../../../common/common_with_different_pages/fruits_category_card_grid.dart';
import '../../../home/presentation/bloc/home_page_bloc.dart';
import '../../../home/presentation/bloc/home_page_state.dart';

class FruitsCategoryPage extends StatelessWidget {
  const FruitsCategoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.lightYellow,
        body: Stack(
          children: [
            // Top Section
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.20,
                decoration: BoxDecoration(color: AppColors.lightYellow),
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Top Row with Back and Settings Icons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        DefaultIcon.back(
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                        DefaultIcon(
                          Icons.tune_rounded,
                          iconSize: 28,
                          iconColor: AppColors.white,
                        ),
                      ],
                    ),
                    // Title and Subtitle
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Fruits Category",
                          style: Theme.of(context)
                              .textTheme
                              .headlineLarge
                              ?.copyWith(
                                color: AppColors.white,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 4),
                        BlocSelector<HomePageBloc, HomePageState,
                                HomePageLoadedState>(
                            selector: (state) => (state as HomePageLoadedState),
                            builder: (context, state) {
                              return Text(
                                "${state.homePageModel.trendingDeals.length} Items",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: AppColors.white,
                                      fontWeight: FontWeight.w400,
                                    ),
                              );
                            }),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Bottom Section
            Positioned(
              top: MediaQuery.of(context).size.height * 0.2,
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    8.verticalSpace,
                    // Search Anchor
                    TextField(
                      decoration: InputDecoration(
                        hintText: "Search Here",
                        hintStyle:
                            Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: AppColors.grey,
                                ),
                        suffixIcon: Icon(
                          Icons.search,
                          color: AppColors.grey,
                        ),
                        filled: true,
                        fillColor: AppColors.lightGrey,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    16.verticalSpace,
                    // Expanded(
                    //     child: Hero(
                    //   tag: 'fruitsCategoryGrid',
                    //   child: FruitsCategoryCardGrid(
                    //     trendingDeals: (context.read<HomePageBloc>().state
                    //             as HomePageLoadedState)
                    //         .homePageModel
                    //         .trendingDeals,
                    //     isScrollable: true,
                    //     onPressed: () {},
                    //   ),
                    // ))
                    // Grid for Fruits Category
                    Expanded(
                      child: BlocBuilder<HomePageBloc, HomePageState>(
                        builder: (context, state) {
                          if (state is HomePageLoadedState) {
                            return Hero(
                              tag: 'fruitsCategoryGrid',
                              child: FruitsCategoryCardGrid(
                                trendingDeals:
                                    state.homePageModel.trendingDeals,
                                isScrollable: true,
                                onPressed: () {},
                              ),
                            );
                          } else if (state is HomePageErrorState) {
                            return Center(
                              child: Text(
                                "Error loading categories",
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            );
                          } else {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        },
                      ),
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
