import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocery_app/core/themes/app_colors.dart';
import '../../../cart/presentation/pages/cart_page.dart';
import '../../../categories/presentation/pages/categories_page.dart';
import '../../../favourites/presentation/pages/favourites_page.dart';
import '../../../profile/profile_page.dart';
import 'home_page.dart';
import 'bottom_navigation_bar.dart';

class MainHomePage extends StatefulWidget {
  final int pageIndex;
  const MainHomePage({super.key, this.pageIndex = 0});

  @override
  State<MainHomePage> createState() => _MainHomePageState();
}

class _MainHomePageState extends State<MainHomePage> {
  late PageController _pageController;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.pageIndex;
    _pageController = PageController(initialPage: _selectedIndex);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ProviderScope(
        child: Scaffold(
          backgroundColor: AppColors.whiteBackground,
          body: Stack(
            children: [
              // PageView for managing pages with slide animation
              PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(), // Disable swipe
                children: [
                  HomePage(onTabChange: _onItemTapped),
                  CategoriesPage(onTabChange: _onItemTapped),
                  CartPage(),
                  FavoritesPage(),
                  ProfilePage(),
                ],
              ),

              // Persistent Bottom Navigation Bar
              Align(
                alignment: Alignment.bottomCenter,
                child: DefaultBottomNavigationBar(
                  currentIndex: _selectedIndex,
                  onTap: _onItemTapped,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
