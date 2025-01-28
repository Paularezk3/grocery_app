import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocery_app/common/components/primary_button.dart';
import 'package:grocery_app/core/config/routes/route_names.dart';

import '../../common/components/default_icon.dart';
import '../../core/themes/app_colors.dart';

class ProfilePage extends StatelessWidget {
  final Function(int) onTabChange;
  const ProfilePage({required this.onTabChange, super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

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
          'Profile',
          style: GoogleFonts.poppins(
            fontSize: 24.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.blackText,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Information
            _buildProfileItem(
              context,
              label: 'Username',
              value: user?.displayName ?? 'Unknown User',
              icon: Icons.edit,
              onTap: () {
                // Handle username edit
                print('Edit Username');
              },
            ),
            const Divider(),
            _buildProfileItem(
              context,
              label: 'Email',
              value: user?.email ?? 'Unknown Email',
              icon: Icons.edit,
              onTap: () {
                // Handle email edit
                print('Edit Email');
              },
            ),
            const Divider(),
            _buildProfileItem(
              context,
              label: 'Phone Number',
              value: user?.phoneNumber ?? 'No Phone Number',
              icon: Icons.edit,
              onTap: () {
                // Handle phone number edit
                print('Edit Phone Number');
              },
            ),
            const Spacer(),

            // Sign Out Button
            Center(
              child: SizedBox(
                width: double.infinity,
                child: PrimaryButton(
                  text: "Sign Out",
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      RouteNames
                          .onboardingFromInside, // Replace with your login route name
                      (route) => false,
                    );
                  },
                ),
              ),
            ),
            SizedBox(
              height: 60,
            )
          ],
        ),
      ),
    );
  }

  Widget _buildProfileItem(
    BuildContext context, {
    required String label,
    required String value,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ],
          ),
          IconButton(
            onPressed: onTap,
            icon: Icon(icon, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
