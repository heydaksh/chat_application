import 'package:chat_application/CommonWidget/toast_bar.dart';
import 'package:chat_application/app/data/repositories/auth_repository.dart';
import 'package:chat_application/app/routes/app_routes.dart';
import 'package:chat_application/core/utils/app_global.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OtpController extends GetxController {
  final AuthRepository _authRepository = AuthRepository();

  final otpController = TextEditingController();
  final isLoading = false.obs;
  final isResending = false.obs;
  late String email;

  @override
  void onInit() {
    super.onInit();
    email = Get.arguments['email'] ?? '';
  }

  Future<void> verifyOtp() async {
    if (otpController.text.isEmpty) {
      ToastBar.showToast('Please enter the OTP', Get.context!, Colors.red);
      return;
    }
    try {
      isLoading.value = true;
      AppGlobal.printLog("[OTP] Verifying OTP for $email");

      final response = await _authRepository.verifyOtp(
        email: email,
        otp: otpController.text.trim(),
      );

      if (response.success && response.data != null) {
        final authData = response.data!;
        final token = authData.token;

        if (token != null) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('auth_token', token);
          if (authData.user?.id != null) {
            await prefs.setString('user_id', authData.user!.id!);
          }

          ToastBar.showToast(
            'Account verified successfully',
            Get.context!,
            Colors.green,
          );
          Get.offAllNamed(Routes.home);
        }
      } else {
        ToastBar.showToast(response.message, Get.context!, Colors.red);
      }
    } catch (e) {
      AppGlobal.printLog("[OTP VERIFY ERROR] $e");
      ToastBar.showToast(e.toString(), Get.context!, Colors.red);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> resendOtp() async {
    try {
      isResending.value = true;
      AppGlobal.printLog("[OTP RESEND] Attempting resend for $email");

      final response = await _authRepository.resendOtp(email: email);

      if (response.success) {
        ToastBar.showToast(
          'A new OTP has been sent to your Email.',
          Get.context!,
          Colors.green,
        );
      } else {
        ToastBar.showToast(response.message, Get.context!, Colors.red);
      }
    } catch (e) {
      AppGlobal.printLog("[OTP RESEND ERROR] $e");
      ToastBar.showToast(e.toString(), Get.context!, Colors.red);
    } finally {
      isResending.value = false;
    }
  }

  @override
  void onClose() {
    super.onClose();
  }
}
