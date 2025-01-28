import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocery_app/common/common_with_different_pages/fruits_category_card_grid.dart';
import 'package:grocery_app/features/home/presentation/bloc/home_page_bloc.dart';
import 'package:grocery_app/features/home/presentation/bloc/home_page_state.dart';

import '../../../../common/components/default_icon.dart';
import '../../../../core/config/routes/route_names.dart';
import '../../../../core/themes/app_colors.dart';

class FavoritesPage extends StatelessWidget {
  final Function(int) onTabChange;
  const FavoritesPage({required this.onTabChange, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.white,
          elevation: 0,
          leading: Hero(
            tag: 'backButton',
            child: DefaultIcon.back(
              onPressed: () => onTabChange(0),
              iconColor: AppColors.black,
            ),
          ),
          title: Text(
            'Favourties',
            style: GoogleFonts.poppins(
              fontSize: 24.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.blackText,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Hero(
                    tag: "fruitsCategoryGrid",
                    child: FruitsCategoryCardGrid(
                        verticalPadding: 10,
                        trendingDeals: (context.read<HomePageBloc>().state
                                as HomePageLoadedState)
                            .homePageModel
                            .trendingDeals,
                        onPressed: (_) => Navigator.pushNamed(
                            context, RouteNames.fruitsCategoryPage))),
              ),
              SizedBox(
                height: 90,
              )
            ],
          ),
        ));
  }
}
