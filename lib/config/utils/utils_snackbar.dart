import 'package:flutter/material.dart';
import 'appcolors.dart';

class NotificationService {
  static GlobalKey<ScaffoldMessengerState> messengerKey =
      GlobalKey<ScaffoldMessengerState>();

  static void showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        backgroundColor: AppColors.darkBlueColor,
        content: Text(
          message,
          style: const TextStyle(color: AppColors.text, fontFamily: "MB"),
        ),
      ),
    );
  }
}
