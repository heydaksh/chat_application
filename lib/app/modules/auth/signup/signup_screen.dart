import 'package:chat_application/core/theme/app_theme.dart';
import 'package:chat_application/core/utils/fonts.dart';
import 'package:chat_application/core/widgets/textfield/auth/textfield_auth.dart';
import 'package:chat_application/core/widgets/wave.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'signup_controller.dart';

class SignupScreen extends GetView<SignupController> {
  SignupScreen({super.key});

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: SafeArea(
          bottom: false,
          child: Stack(
            alignment: Alignment.center,
            children: [
              const Wave(),

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
                          'SignUp Here',
                          style: Fonts.boldTextStyle(
                            fontSize: size.width / 12,
                            color: AppTheme.textOnBackground,
                          ),
                        ),

                        SizedBox(height: size.height / 25),

                        /// PHONE NUMBER
                        TextfieldAuth(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your phone number';
                            }
                            if (value.length < 10) {
                              return 'Please enter a valid 10-digit number';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.phone,
                          maxLength: 10,
                          controller: controller.phoneController,
                          labelText: 'Phone Number',
                          icon: Icons.phone,
                        ),

                        SizedBox(height: size.height / 40),

                        /// EMAIL
                        TextfieldAuth(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            if (!value.isEmail) {
                              return 'Please enter a valid email';
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
                            if (value.length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                          controller: controller.passwordController,
                          obscureText: true,
                          labelText: 'Password',
                          icon: Icons.key,
                        ),

                        SizedBox(height: size.height / 25),

                        /// CONFIRM PASSWORD
                        TextfieldAuth(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please confirm your password';
                            }
                            if (value != controller.passwordController.text) {
                              return 'Passwords do not match';
                            }
                            return null;
                          },
                          controller: controller.confirmPasswordController,
                          obscureText: true,
                          labelText: 'Confirm Password',
                          icon: Icons.key,
                        ),

                        SizedBox(height: size.height / 25),

                        /// BUTTON ROW
                        Align(
                          alignment: Alignment.centerRight,
                          child: Column(
                            children: [
                              Obx(
                                () => GestureDetector(
                                  onTap: controller.isLoading.value
                                      ? null
                                      : () {
                                          FocusScope.of(context).unfocus();
                                          if (_formKey.currentState!
                                              .validate()) {
                                            controller.signup();
                                          }
                                        },
                                  child: Container(
                                    width: size.width / 2.5,
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
                                            'Create Account',
                                            style: Fonts.boldTextStyle(
                                              fontSize: size.width / 24,
                                              color: AppTheme.textOnBackground,
                                            ),
                                          ),
                                  ),
                                ),
                              ),
                              SizedBox(height: size.height / 20),
                              const Text(
                                'Already have an account?',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black54,
                                ),
                              ),
                              GestureDetector(
                                onTap: controller.goToLogin,
                                child: Text(
                                  'Login here',
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
                        Align(
                          alignment: .bottomLeft,
                          child: Container(
                            height: size.height / 10,
                            width: size.width / 10,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppTheme.textOnBackground,
                            ),
                            child: BackButton(color: AppTheme.primaryColor),
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
      ),
    );
  }
}
