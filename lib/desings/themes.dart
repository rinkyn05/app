// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

import '../config/utils/appcolors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: Colors.blueGrey[50],
      appBarTheme: const AppBarTheme(
        color: Colors.transparent,
        elevation: 0,
        titleTextStyle: TextStyle(
          color: AppColors.gdarkblue,
          fontFamily: 'MB',
          fontSize: 28,
        ),
      ),
      scaffoldBackgroundColor: Colors.blueGrey[50],
      textTheme: const TextTheme(
        titleLarge: TextStyle(
          color: AppColors.gdarkblue,
          fontFamily: 'MB',
          fontSize: 30,
        ),
        titleMedium: TextStyle(
          color: AppColors.gdarkblue,
          fontFamily: 'MB',
          fontSize: 28,
        ),
        titleSmall: TextStyle(
          color: AppColors.gdarkblue,
          fontFamily: 'MB',
          fontSize: 26,
        ),
        bodyLarge: TextStyle(
          color: AppColors.gdarkblue,
          fontFamily: 'MB',
          fontSize: 18,
        ),
        bodyMedium: TextStyle(
          color: AppColors.gdarkblue,
          fontFamily: 'MM',
          fontSize: 16,
        ),
        bodySmall: TextStyle(
          color: AppColors.gdarkblue,
          fontFamily: 'MM',
          fontSize: 15,
        ),
        labelLarge: TextStyle(
          color: AppColors.gdarkblue,
          fontFamily: 'MM',
          fontSize: 28,
        ),
        labelMedium: TextStyle(
          color: AppColors.gdarkblue,
          fontFamily: 'MM',
          fontSize: 26,
        ),
        labelSmall: TextStyle(
          color: AppColors.gdarkblue,
          fontFamily: 'MM',
          fontSize: 24,
        ),
      ),
      cardColor: Colors.white,
      iconTheme: const IconThemeData(
        color: AppColors.gdarkblue,
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: const Color.fromARGB(255, 13, 19, 51),
          textStyle: const TextStyle(
            fontFamily: 'MB',
          ),
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.blueGrey[50],
        selectedItemColor: AppColors.gblue,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        selectedLabelStyle: TextStyle(
          fontFamily: 'MB',
          fontSize: 22,
        ),
        unselectedLabelStyle: TextStyle(
          fontFamily: 'MB',
          fontSize: 20,
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: AppColors.gdarkblue,
      appBarTheme: const AppBarTheme(
        color: Colors.transparent,
        elevation: 0,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontFamily: 'MB',
          fontSize: 28,
        ),
      ),
      scaffoldBackgroundColor: AppColors.gdarkblue,
      textTheme: const TextTheme(
        titleLarge: TextStyle(
          color: Colors.white,
          fontFamily: 'MB',
          fontSize: 30,
        ),
        titleMedium: TextStyle(
          color: Colors.white,
          fontFamily: 'MB',
          fontSize: 28,
        ),
        titleSmall: TextStyle(
          color: Colors.white,
          fontFamily: 'MB',
          fontSize: 26,
        ),
        bodyLarge: TextStyle(
          color: Colors.white,
          fontFamily: 'MB',
          fontSize: 18,
        ),
        bodyMedium: TextStyle(
          color: Colors.white,
          fontFamily: 'MM',
          fontSize: 16,
        ),
        bodySmall: TextStyle(
          color: Colors.white,
          fontFamily: 'MM',
          fontSize: 15,
        ),
        labelLarge: TextStyle(
          color: Colors.white,
          fontFamily: 'MM',
          fontSize: 28,
        ),
        labelMedium: TextStyle(
          color: Colors.white,
          fontFamily: 'MM',
          fontSize: 26,
        ),
        labelSmall: TextStyle(
          color: Colors.white,
          fontFamily: 'MM',
          fontSize: 24,
        ),
      ),
      cardColor: const Color(0xFF1E1E1E),
      iconTheme: const IconThemeData(
        color: Colors.white,
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: Colors.white,
          textStyle: const TextStyle(
            fontFamily: 'MB',
          ),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.gdarkblue,
        selectedItemColor: AppColors.gblue,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        selectedLabelStyle: TextStyle(
          fontFamily: 'MB',
          fontSize: 22,
        ),
        unselectedLabelStyle: TextStyle(
          fontFamily: 'MM',
          fontSize: 20,
        ),
      ),
    );
  }
}
