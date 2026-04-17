import 'package:chat_application/app/modules/auth/forget_password/password_controller.dart';
import 'package:chat_application/core/theme/app_theme.dart';
import 'package:chat_application/core/utils/fonts.dart';
import 'package:chat_application/core/widgets/textfield/auth/textfield_auth.dart';
import 'package:chat_application/core/widgets/wave.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgetPassword extends StatelessWidget {
  const ForgetPassword({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PasswordController());
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Stack(
          alignment: Alignment.center,
          children: [
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                FocusManager.instance.primaryFocus?.unfocus();
              },
              child: const Wave(),
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: size.width / 15),
              child: Obx(
                () => Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Enter your Email to \nReset password.',
                      style: Fonts.boldTextStyle(
                        fontSize: 20,
                        color: AppTheme.textOnBackground,
                      ),
                    ),
                    SizedBox(height: size.height / 50),
                    TextfieldAuth(
                      controller: controller.emailController,
                      labelText: 'Email',
                      icon: Icons.email,
                      borderColor: Colors.white,
                    ),
                    SizedBox(height: size.height / 15),

                    if (!controller.isEmailVerified.value)
                      Align(
                        alignment: Alignment.centerRight,
                        child: _buildVerifyButton(
                          context,
                          'Verify',
                          controller.isLoadingEmail.value,
                          () {
                            FocusScope.of(context).unfocus();
                            controller.forgetPassword();
                          },
                        ),
                      ),

                    if (controller.isEmailVerified.value) ...[
                      SizedBox(height: size.height / 10),
                      TextfieldAuth(
                        controller: controller.otpController,
                        labelText: 'OTP',
                        icon: Icons.message,
                        keyboardType: TextInputType.number,
                      ),
                      SizedBox(height: size.height / 15),
                      Align(
                        alignment: Alignment.centerRight,
                        child: _buildVerifyButton(
                          context,
                          'Verify OTP',
                          controller.isLoadingOtp.value,
                          () {
                            FocusScope.of(context).unfocus();
                            controller.verifyOtp();
                          },
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVerifyButton(
    BuildContext context,
    String label,
    bool isLoading,
    VoidCallback ontap,
  ) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: isLoading ? null : ontap,
      child: Container(
        height: size.height / 15,
        width: size.width / 3,
        decoration: BoxDecoration(
          color: AppTheme.primaryColor,
          borderRadius: BorderRadius.circular(15),
        ),
        alignment: Alignment.center,
        child: isLoading
            ? SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  color: AppTheme.textOnBackground,
                  strokeWidth: 2,
                ),
              )
            : Text(
                label,
                style: Fonts.boldTextStyle(color: AppTheme.textOnBackground),
              ),
      ),
    );
  }
}
