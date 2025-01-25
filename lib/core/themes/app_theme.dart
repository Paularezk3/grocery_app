import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      primarySwatch: Colors.blue,
      primaryColor: Colors.blue,
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.inter(
          fontSize: 20.sp,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      textTheme: TextTheme(
        headlineLarge: GoogleFonts.inter(
          fontSize: 24.sp,
          fontWeight: FontWeight.w700,
          color: Colors.black,
        ),
        headlineMedium: GoogleFonts.poppins(
          fontSize: 28.sp,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        headlineSmall: GoogleFonts.inter(
          fontSize: 18.sp,
          fontWeight: FontWeight.w700,
          color: Colors.black87,
        ),
        bodyLarge: GoogleFonts.inter(
          fontSize: 16.sp,
          fontWeight: FontWeight.w500,
          color: Colors.black,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 14.sp,
          fontWeight: FontWeight.normal,
          color: Colors.black54,
        ),
        labelLarge: GoogleFonts.inter(
          fontSize: 16.sp,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Colors.blue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: Colors.blue),
        ),
        hintStyle: GoogleFonts.inter(
          fontSize: 14,
          color: Colors.grey.shade600,
        ),
        labelStyle: GoogleFonts.inter(
          fontSize: 14,
          color: Colors.black87,
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 4,
      ),
      cardTheme: CardTheme(
        elevation: 4,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      iconTheme: const IconThemeData(
        color: Colors.blue,
        size: 24,
      ),
    );
  }
}
