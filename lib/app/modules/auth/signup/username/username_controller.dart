import 'package:chat_application/app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UsernameController extends GetxController {
  final usernameController = TextEditingController();

  void signup() {
    Get.toNamed(
      Routes.signup,
      arguments: {'username': usernameController.text.trim()},
    );
  }

  void goToLogin() {
    Get.back();
  }
}
