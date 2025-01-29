import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocery_app/core/themes/app_colors.dart';

class NotificationsDialog extends StatelessWidget {
  final String userId;

  const NotificationsDialog({super.key, required this.userId});

  Future<List<Map<String, dynamic>>> _fetchNotifications() async {
    try {
      final notificationsSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('notifications')
          .orderBy('time', descending: true)
          .get();

      if (notificationsSnapshot.docs.isEmpty) {
        return []; // Return an empty list if no notifications exist
      }

      return notificationsSnapshot.docs
          .map((doc) => doc.data())
          .cast<Map<String, dynamic>>()
          .toList();
    } catch (e) {
      debugPrint("Error fetching notifications: $e");
      throw Exception(
          "Failed to load notifications"); // Throw an exception to handle in FutureBuilder
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.whiteBackground.withValues(alpha: 0.1),
              AppColors.grey.withValues(alpha: 0.05)
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: _fetchNotifications(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SizedBox(
                height: 200,
                child: Center(child: CircularProgressIndicator()),
              );
            }

            if (snapshot.hasError) {
              return SizedBox(
                height: 200,
                child: Center(
                  child: Text(
                    "Error loading notifications: ${snapshot.error}",
                    style: TextStyle(color: AppColors.red, fontSize: 16.sp),
                  ),
                ),
              );
            }

            final notifications = snapshot.data ?? [];

            return SizedBox(
              width: 350.w,
              height: 400.h,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      "Notifications",
                      style: GoogleFonts.poppins(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.black,
                      ),
                    ),
                    const Divider(),
                    // Notifications List
                    Expanded(
                      child: notifications.isEmpty
                          ? Center(
                              child: Text(
                                "No notifications yet!",
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: AppColors.grey,
                                ),
                              ),
                            )
                          : ListView.builder(
                              itemCount: notifications.length,
                              itemBuilder: (context, index) {
                                final notification = notifications[index];
                                final isRead = notification['isRead'] ?? false;
                                final time = notification['time'] as Timestamp;

                                return Card(
                                  elevation: 2,
                                  margin: EdgeInsets.symmetric(vertical: 4.h),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: ListTile(
                                    leading: Icon(
                                      isRead
                                          ? Icons.notifications_none_rounded
                                          : Icons.notifications_active_rounded,
                                      color: isRead
                                          ? AppColors.grey
                                          : AppColors.orange,
                                    ),
                                    title: Text(
                                      notification['title'] ?? 'Untitled',
                                      style: TextStyle(
                                        fontWeight: isRead
                                            ? FontWeight.normal
                                            : FontWeight.bold,
                                        fontSize: 14.sp,
                                      ),
                                    ),
                                    subtitle: Text(
                                      time.toDate().toString().substring(0, 16),
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        color: AppColors.grey,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
