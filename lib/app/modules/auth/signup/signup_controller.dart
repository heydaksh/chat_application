import 'package:chat_application/CommonWidget/toast_bar.dart';
import 'package:chat_application/app/data/repositories/auth_repository.dart';
import 'package:chat_application/app/routes/app_routes.dart';
import 'package:chat_application/core/utils/app_global.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignupController extends GetxController {
  final AuthRepository _authRepository = AuthRepository();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null && Get.arguments['username'] != null) {
      nameController.text = Get.arguments['username'];
    }
  }

  Future<void> signup() async {
    if (passwordController.text != confirmPasswordController.text) {
      ToastBar.showToast('Passwords do not match', Get.context!, Colors.red);
      return;
    }

    final username = nameController.text.isNotEmpty
        ? nameController.text.trim()
        : "user_${DateTime.now().millisecondsSinceEpoch}";

    try {
      isLoading.value = true;
      AppGlobal.printLog("[SIGNUP] Attempting registration for $username");

      final response = await _authRepository.register(
        username: username,
        email: emailController.text.trim(),
        mobile: phoneController.text.trim(),
        password: passwordController.text.trim(),
      );

      if (response.success) {
        ToastBar.showToast(response.message, Get.context!, Colors.green);
        // Navigate to OTP screen and pass the email
        Get.toNamed(
          Routes.otp,
          arguments: {'email': emailController.text.trim()},
        );
      } else {
        ToastBar.showToast(response.message, Get.context!, Colors.red);
      }
    } catch (e) {
      AppGlobal.printLog("[SIGNUP ERROR] $e");
      ToastBar.showToast(e.toString(), Get.context!, Colors.red);
    } finally {
      isLoading.value = false;
    }
  }

  void goToLogin() {
    Get.toNamed(Routes.login);
  }
}
