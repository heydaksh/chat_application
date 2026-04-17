import 'package:chat_application/CommonWidget/toast_bar.dart';
import 'package:chat_application/app/data/repositories/auth_repository.dart';
import 'package:chat_application/app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PasswordController extends GetxController {
  final RxBool isEmailVerified = false.obs;
  final RxBool isLoadingEmail = false.obs;
  final RxBool isLoadingOtp = false.obs;
  final RxBool isLoadingReset = false.obs;

  final emailController = TextEditingController();
  final otpController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final AuthRepository _authRepository = AuthRepository();

  Future<void> forgetPassword() async {
    if (emailController.text.isEmpty || !emailController.text.isEmail) {
      ToastBar.showToast(
        'Please enter a valid email.',
        Get.context!,
        Colors.red,
      );
      return;
    }

    try {
      isLoadingEmail.value = true;
      final response = await _authRepository.forgetPassword(
        email: emailController.text.trim(),
      );
      if (response.success) {
        isEmailVerified.value = true;
        ToastBar.showToast(response.message, Get.context!, Colors.green);
      } else {
        ToastBar.showToast(response.message, Get.context!, Colors.red);
      }
    } catch (e) {
      ToastBar.showToast(e.toString(), Get.context!, Colors.red);
    } finally {
      isLoadingEmail.value = false;
    }
  }

  Future<void> verifyOtp() async {
    if (otpController.text.isEmpty) {
      ToastBar.showToast('Please enter OTP.', Get.context!, Colors.red);
      return;
    }

    // "Fixed otp will be sent with no api" - mocking OTP verification locally
    try {
      isLoadingOtp.value = true;
      await Future.delayed(
        const Duration(seconds: 1),
      ); // Mock verification delay

      // Navigate to Set New Password screen
      Get.toNamed(Routes.setNewPassword);
    } catch (e) {
      ToastBar.showToast(e.toString(), Get.context!, Colors.red);
    } finally {
      isLoadingOtp.value = false;
    }
  }

  Future<void> resetPassword() async {
    if (newPasswordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      ToastBar.showToast(
        'Please enter matching passwords.',
        Get.context!,
        Colors.red,
      );
      return;
    }

    if (newPasswordController.text != confirmPasswordController.text) {
      ToastBar.showToast('Passwords do not match.', Get.context!, Colors.red);
      return;
    }

    try {
      isLoadingReset.value = true;
      final response = await _authRepository.resetPassword(
        email: emailController.text.trim(),
        newPassword: newPasswordController.text,
        confirmPassword: confirmPasswordController.text,
      );

      if (response.success) {
        ToastBar.showToast(response.message, Get.context!, Colors.green);
        Get.offAllNamed(Routes.login);
      } else {
        ToastBar.showToast(response.message, Get.context!, Colors.red);
      }
    } catch (e) {
      ToastBar.showToast(e.toString(), Get.context!, Colors.red);
    } finally {
      isLoadingReset.value = false;
    }
  }
}
