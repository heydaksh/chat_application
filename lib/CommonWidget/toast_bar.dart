import 'package:flutter/material.dart';
import 'package:chat_application/core/utils/app_global.dart';

class ToastBar {
  static void showToast(
    String message,
    BuildContext? context,
    Color backgroundColor,
  ) {
    if (message.isEmpty) return;

    final snackBar = SnackBar(
      content: Text(
        message,
        style: const TextStyle(color: Colors.white, fontSize: 14),
      ),
      backgroundColor: backgroundColor,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      duration: const Duration(seconds: 3),
    );

    AppGlobal.scaffoldMessengerKey.currentState?.clearSnackBars();
    AppGlobal.scaffoldMessengerKey.currentState?.showSnackBar(snackBar);
  }
}
