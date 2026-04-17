import 'package:chat_application/CommonWidget/toast_bar.dart';
import 'package:chat_application/app/routes/app_routes.dart';
import 'package:chat_application/core/theme/app_theme.dart';
import 'package:chat_application/core/utils/fonts.dart';
import 'package:chat_application/core/widgets/textfield/auth/textfield_auth.dart';
import 'package:chat_application/core/widgets/wave.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'login_controller.dart';

class LoginScreen extends GetView<LoginController> {
  LoginScreen({super.key});

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
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

            /// CONTENT
            SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width / 15),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// TITLE
                      Text(
                        'Login To Chat..',
                        style: Fonts.boldTextStyle(
                          fontSize: size.width / 12,
                          color: AppTheme.textOnBackground,
                        ),
                      ),

                      SizedBox(height: size.height / 25),

                      /// EMAIL
                      TextfieldAuth(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a valid Email.';
                          }
                          if (!value.isEmail) {
                            return 'Please enter a valid Email.';
                          }
                          return null;
                        },
                        controller: controller.emailController,
                        labelText: 'Email',
                        icon: Icons.email,
                      ),

                      SizedBox(height: size.height / 40),

                      /// PASSWORD
                      TextfieldAuth(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          if (value.length < 9) {
                            return 'Password must be at least 9 characters long';
                          }

                          if (!value.contains(RegExp(r'[a-zA-Z]'))) {
                            return 'Password must contain at least one letter';
                          }
                          if (!value.contains(RegExp(r'[0-9]'))) {
                            return 'Password must contain at least one number';
                          }
                          if (!value.contains(
                            RegExp(r'[!@#$%^&*(),.?":{}|<>]'),
                          )) {
                            return 'Password must contain at least one special character';
                          }
                          return null;
                        },
                        controller: controller.passwordController,
                        obscureText: true,
                        labelText: 'Password',
                        icon: Icons.key,
                      ),

                      SizedBox(height: size.height / 25),
                      Align(
                        alignment: .centerLeft,
                        child: TextButton(
                          onPressed: () {
                            Get.toNamed(Routes.forgetPass);
                          },
                          child: Text(
                            'Forgot Password?',
                            style: Fonts.semiBoldTextStyle(
                              textDecoration: .underline,
                              color: AppTheme.textOnBackground,
                            ),
                          ),
                        ),
                      ),

                      /// BUTTON ROW
                      Align(
                        alignment: Alignment.centerRight,
                        child: Column(
                          children: [
                            Obx(
                              () => GestureDetector(
                                onTap: controller.isLoading.value
                                    ? null
                                    : () async {
                                        FocusScope.of(context).unfocus();
                                        if (_formKey.currentState!.validate()) {
                                          await controller.login();

                                          ToastBar.showToast(
                                            'Login Success!',
                                            context,
                                            Colors.green,
                                          );
                                        }
                                      },
                                child: Container(
                                  width: size.width / 3,
                                  padding: EdgeInsets.symmetric(
                                    vertical: size.height / 50,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppTheme.primaryColor,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  alignment: Alignment.center,
                                  child: controller.isLoading.value
                                      ? SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: CircularProgressIndicator(
                                            color: AppTheme.textOnBackground,
                                            strokeWidth: 2,
                                          ),
                                        )
                                      : Text(
                                          'Login',
                                          style: Fonts.boldTextStyle(
                                            fontSize: size.width / 20,
                                            color: AppTheme.textOnBackground,
                                          ),
                                        ),
                                ),
                              ),
                            ),
                            SizedBox(height: size.height / 20),
                            const Text(
                              'Don\'t have an account?',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black54,
                              ),
                            ),
                            GestureDetector(
                              onTap: controller.goToSignup,
                              child: Text(
                                'Create One',
                                style: Fonts.boldTextStyle(
                                  textDecoration: TextDecoration.underline,
                                  fontSize: 16,
                                  color: AppTheme.primaryColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
