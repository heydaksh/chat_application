import 'package:chat_application/CommonWidget/toast_bar.dart';
import 'package:chat_application/app/data/repositories/auth_repository.dart';
import 'package:chat_application/app/routes/app_routes.dart';
import 'package:chat_application/app/services/auth_service.dart';
import 'package:chat_application/core/utils/app_global.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  final AuthRepository _authRepository = AuthRepository();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final isLoading = false.obs;

  Future<void> login() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      ToastBar.showToast(
        'Please enter Email and Password.',
        Get.context!,
        Colors.red,
      );
      return;
    }

    try {
      isLoading.value = true;
      AppGlobal.printLog(
        "[LOGIN] Attempting login for ${emailController.text.trim()}",
      );

      final response = await _authRepository.login(
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      if (response.success && response.data != null) {
        final authData = response.data!;
        final bool isVerified = authData.user?.isVerified ?? false;

        if (isVerified) {
          final token = authData.token;
          if (token != null) {
            await AuthService.to.saveToken(token);
            if (authData.user?.id != null) {
              await AuthService.to.saveUserId(authData.user!.id!);
            }
            AppGlobal.printLog("[LOGIN] Token saved to AuthService");
            ToastBar.showToast(response.message, Get.context!, Colors.green);
            Get.offAllNamed(Routes.home);
          }
        } else {
          ToastBar.showToast(
            'Verification Required',
            Get.context!,
            Colors.orange,
          );

          Get.toNamed(
            Routes.otp,
            arguments: {'email': emailController.text.trim()},
          );
        }
      } else {
        ToastBar.showToast(response.message, Get.context!, Colors.red);
      }
    } catch (e) {
      AppGlobal.printLog("[LOGIN ERROR] $e");
      ToastBar.showToast(e.toString(), Get.context!, Colors.red);
    } finally {
      isLoading.value = false;
    }
  }

  void goToSignup() {
    Get.toNamed(Routes.username);
  }

  @override
  void onClose() {
    super.onClose();
  }
}
