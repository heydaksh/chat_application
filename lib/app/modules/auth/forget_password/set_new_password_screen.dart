import 'package:chat_application/app/modules/auth/forget_password/password_controller.dart';
import 'package:chat_application/core/theme/app_theme.dart';
import 'package:chat_application/core/utils/fonts.dart';
import 'package:chat_application/core/widgets/textfield/auth/textfield_auth.dart';
import 'package:chat_application/core/widgets/wave.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SetNewPasswordScreen extends StatelessWidget {
  const SetNewPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PasswordController>();
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
                      'Set New Password',
                      style: Fonts.boldTextStyle(
                        fontSize: size.width / 14,
                        color: AppTheme.textOnBackground,
                      ),
                    ),
                    SizedBox(height: size.height / 20),
                    TextfieldAuth(
                      controller: controller.newPasswordController,
                      labelText: 'New Password',
                      icon: Icons.lock,
                      obscureText: true,
                    ),
                    SizedBox(height: size.height / 25),
                    TextfieldAuth(
                      controller: controller.confirmPasswordController,
                      labelText: 'Confirm Password',
                      icon: Icons.lock_outline,
                      obscureText: true,
                    ),
                    SizedBox(height: size.height / 15),
                    Align(
                      alignment: Alignment.centerRight,
                      child: _buildSubmitButton(
                        context,
                        'Reset Password',
                        controller.isLoadingReset.value,
                        () {
                          FocusScope.of(context).unfocus();
                          controller.resetPassword();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubmitButton(
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
        width: size.width / 2.5,
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
