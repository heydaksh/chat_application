import 'package:chat_application/app/modules/auth/signup/username/username_controller.dart';
import 'package:chat_application/core/theme/app_theme.dart';
import 'package:chat_application/core/utils/fonts.dart';
import 'package:chat_application/core/widgets/textfield/auth/textfield_auth.dart';
import 'package:chat_application/core/widgets/wave.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UsernameScreen extends GetView<UsernameController> {
  UsernameScreen({super.key});
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final isLoading = false.obs;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Stack(
          alignment: .center,
          children: [
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                FocusManager.instance.primaryFocus?.unfocus();
              },
              child: const Wave(),
            ),
            SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: size.width / 15),
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  Text(
                    'Create Username',
                    style: Fonts.boldTextStyle(
                      fontSize: size.width / 12,
                      color: AppTheme.textOnBackground,
                    ),
                  ),
                  SizedBox(height: size.height / 25),
                  Form(
                    key: _formKey,
                    child: TextfieldAuth(
                      maxLength: 15,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Username cannot be empty..';
                        } else if (value.length < 3) {
                          return 'Username must be at least 3 characters long.';
                        } else if (value.length > 15) {
                          return 'Username must be at most 15 characters long.';
                        } else if (!RegExp(
                          r'^[a-zA-Z0-9_]+$',
                        ).hasMatch(value)) {
                          return 'Username can only contain letters, numbers, and underscores.';
                        }
                        return null;
                      },
                      controller: controller.usernameController,
                      labelText: 'Username',
                      icon: Icons.person,
                    ),
                  ),
                  SizedBox(height: size.height / 10),

                  /// BUTTON ROW
                  Align(
                    alignment: Alignment.centerRight,
                    child: Column(
                      children: [
                        Obx(
                          () => GestureDetector(
                            onTap: () async {
                              FocusScope.of(context).unfocus();

                              if (!_formKey.currentState!.validate()) return;
                              if (isLoading.value) return;
                              isLoading.value = true;

                              await Future.delayed(const Duration(seconds: 2));

                              isLoading.value = false;
                              controller.signup();
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
                              child: isLoading.value
                                  ? SizedBox(
                                      height: size.width / 20,
                                      width: size.width / 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: AppTheme.textOnBackground,
                                      ),
                                    )
                                  : Text(
                                      'Next',
                                      style: Fonts.boldTextStyle(
                                        fontSize: size.width / 24,
                                        color: AppTheme.textOnBackground,
                                      ),
                                    ),
                            ),
                          ),
                        ),
                      ],
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
