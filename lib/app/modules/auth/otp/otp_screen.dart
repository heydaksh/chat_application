import 'package:chat_application/CommonWidget/toast_bar.dart';
import 'package:chat_application/core/theme/app_theme.dart';
import 'package:chat_application/core/utils/fonts.dart';
import 'package:chat_application/core/widgets/textfield/auth/textfield_auth.dart';
import 'package:chat_application/core/widgets/wave.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'otp_controller.dart';

class OtpScreen extends GetView<OtpController> {
  OtpScreen({super.key});
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                FocusManager.instance.primaryFocus?.unfocus();
              },
              child: const Wave(),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: .start,
                children: [
                  Text(
                    'An OTP has been sent to:',
                    textAlign: TextAlign.center,
                    style: Fonts.regularTextStyle(
                      color: AppTheme.textOnBackground,
                    ),
                  ),
                  Text(
                    controller.email,
                    textAlign: TextAlign.center,
                    style: Fonts.boldTextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      textDecoration: TextDecoration.underline,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Form(
                    key: _formKey,
                    child: TextfieldAuth(
                      controller: controller.otpController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your OTP';
                        }
                        if (value.length != 6) {
                          return 'OTP must be 6 digits';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.number,
                      icon: Icons.message,
                      labelText: 'OTP',
                      labelColor: Colors.white,
                      borderColor: Colors.white,
                      maxLength: 6,
                      textColor: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 30),
                  Obx(
                    () => GestureDetector(
                      onTap: controller.isLoading.value
                          ? null
                          : () {
                              if (_formKey.currentState!.validate()) {
                                controller.verifyOtp();
                              }
                              ToastBar.showToast(
                                'OTP Verified',
                                context,
                                Colors.green,
                              );
                            },

                      child: Row(
                        mainAxisAlignment: .spaceBetween,
                        children: [
                          Obx(
                            () => TextButton(
                              onPressed: controller.isResending.value
                                  ? null
                                  : controller.resendOtp,
                              child: controller.isResending.value
                                  ? const SizedBox(
                                      height: 15,
                                      width: 15,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: AppTheme.textOnBackground,
                                      ),
                                    )
                                  : Text(
                                      "Resend OTP",
                                      style: Fonts.regularTextStyle(
                                        color: AppTheme.textOnBackground,
                                        fontSize: 12,
                                        textDecoration:
                                            TextDecoration.underline,
                                      ),
                                    ),
                            ),
                          ),
                          Container(
                            width: size.width / 4,
                            height: size.height / 14,
                            decoration: BoxDecoration(
                              color: AppTheme.primaryColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            alignment: Alignment.center,
                            child: controller.isLoading.value
                                ? const CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                : Text(
                                    'Verify',
                                    style: Fonts.boldTextStyle(
                                      fontSize: size.width / 24,
                                      color: AppTheme.textOnBackground,
                                    ),
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
