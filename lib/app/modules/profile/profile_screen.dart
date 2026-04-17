import 'package:chat_application/CommonWidget/custom_button.dart';
import 'package:chat_application/CommonWidget/toast_bar.dart';
import 'package:chat_application/core/theme/app_theme.dart';
import 'package:chat_application/core/utils/fonts.dart';
import 'package:chat_application/core/widgets/textfield/auth/textfield_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import 'profile_controller.dart';

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileController>(() => ProfileController());
  }
}

class ProfileScreen extends GetView<ProfileController> {
  ProfileScreen({super.key});

  final TextEditingController bioController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();

  // Password controllers for the dialog
  final TextEditingController oldPassCtrl = TextEditingController();
  final TextEditingController newPassCtrl = TextEditingController();
  final TextEditingController confirmPassCtrl = TextEditingController();

  final ImagePicker _picker = ImagePicker();

  Future<void> pickProfileImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 70,
      );

      if (image != null) {
        controller.handleProfilePicUpload(image.path);
      }
    } catch (e) {
      debugPrint("Image Picker Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFFFAF5F2),
      body: Obx(() {
        if (controller.isLoadingProfile.value) {
          return const Center(
            child: CircularProgressIndicator(color: AppTheme.primaryColor),
          );
        }

        final user = controller.myProfile.value;
        if (user == null) {
          return Center(
            child: Text(
              "Failed to load profile.",
              style: Fonts.regularTextStyle(color: Colors.grey),
            ),
          );
        }

        // Auto-fill form details only if empty to preserve user typing
        if (bioController.text.isEmpty && user.bio != null) {
          bioController.text = user.bio!;
        }
        if (usernameController.text.isEmpty && user.username != null) {
          usernameController.text = user.username!;
        }

        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: RefreshIndicator(
            onRefresh: controller.onRefresh,
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: size.width / 20,
                vertical: size.height / 80,
              ),
              child: Column(
                children: [
                  SizedBox(height: size.height / 30),

                  /// PROFILE IMAGE
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        radius: size.width / 6,
                        backgroundColor: Colors.grey[300],
                        backgroundImage:
                            user.profilePic != null &&
                                user.profilePic!.isNotEmpty
                            ? NetworkImage(user.profilePic!)
                            : null,
                        child: controller.isUpdatingPic.value
                            ? const CircularProgressIndicator(
                                color: AppTheme.primaryColor,
                              )
                            : (user.profilePic == null ||
                                  user.profilePic!.isEmpty)
                            ? Icon(
                                Icons.person,
                                size: size.width / 6,
                                color: Colors.white,
                              )
                            : null,
                      ),
                      GestureDetector(
                        onTap: () async {
                          pickProfileImage();
                        },
                        child: Container(
                          padding: EdgeInsets.all(size.width / 80),
                          decoration: const BoxDecoration(
                            color: AppTheme.primaryColor,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: size.width / 20,
                          ),
                        ),
                      ),

                      /// icon button for delete profile picture
                      Positioned(
                        left: 1,
                        child: GestureDetector(
                          onTap: () async {
                            controller.deleteProfilePic();
                          },
                          child: Container(
                            padding: EdgeInsets.all(size.width / 80),
                            decoration: const BoxDecoration(
                              color: AppTheme.primaryColor,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.delete,
                              color: Colors.white,
                              size: size.width / 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: size.height / 40),

                  /// USERNAME
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: size.width / 25),
                    child: TextfieldAuth(
                      controller: usernameController,
                      labelText: "Username",
                      cursorColor: AppTheme.primaryColor,
                      textColor: AppTheme.textPrimary,
                      labelColor: AppTheme.primaryColor,
                      borderColor: AppTheme.primaryColor.withValues(alpha: 0.3),
                    ),
                  ),

                  SizedBox(height: size.height / 100),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Email: ',
                        style: Fonts.regularTextStyle(
                          color: AppTheme.primaryColor,
                          fontSize: size.width / 28,
                        ),
                      ),
                      Text(
                        user.email ?? 'No email available',
                        style: Fonts.regularTextStyle(
                          color: Colors.grey,
                          fontSize: size.width / 28,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: size.height / 30),

                  /// CARD
                  Container(
                    padding: EdgeInsets.all(size.width / 25),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(size.width / 25),
                      border: Border.all(
                        color: Colors.grey.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Column(
                      children: [
                        /// BIO FIELD
                        Focus(
                          onFocusChange: (hasFocus) {
                            controller.isBioFocused.value = hasFocus;
                          },
                          child: Obx(() {
                            return AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              width: size.width / 1.1,
                              padding: EdgeInsets.symmetric(
                                horizontal: size.width / 25,
                                vertical: size.height / 80,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(
                                  size.width / 25,
                                ),
                                border: Border.all(
                                  color: controller.isBioFocused.value
                                      ? AppTheme.primaryColor
                                      : AppTheme.primaryColor.withValues(
                                          alpha: 0.3,
                                        ),
                                  width: controller.isBioFocused.value
                                      ? 1.5
                                      : 1,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: controller.isBioFocused.value
                                        ? AppTheme.primaryColor.withValues(
                                            alpha: 0.15,
                                          )
                                        : Colors.black.withValues(alpha: 0.05),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: TextfieldAuth(
                                cursorColor: AppTheme.primaryColor,
                                controller: bioController,
                                labelText: 'Bio',
                                lableTextSize: size.width / 25,
                                maxLines: 4,
                                maxLength: 120,
                                textColor: AppTheme.textPrimary,
                                labelColor: AppTheme.primaryColor,
                              ),
                            );
                          }),
                        ),

                        SizedBox(height: size.height / 40),

                        _buildProfileTile(
                          size,
                          Icons.phone,
                          'Phone',
                          "+91 ${user.mobile ?? 'Not provided'}",
                        ),

                        Divider(height: size.height / 30),

                        _buildProfileTile(
                          size,
                          Icons.person_outline,
                          'Gender',
                          user.gender ?? 'Select Gender',
                          onTap: () => _showGenderSelection(context),
                        ),

                        Divider(height: size.height / 30),

                        _buildProfileTile(
                          size,
                          Icons.verified_user_outlined,
                          'Status',
                          user.isVerified ? 'Verified' : 'Unverified',
                          color: user.isVerified ? Colors.green : Colors.orange,
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: size.height / 30),

                  /// MAIN SAVE BUTTON
                  CustomButton(
                    text: 'Save Changes',
                    isLoading: controller.isSaving.value,
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      controller.saveProfileChanges(
                        usernameController.text,
                        bioController.text,
                      );
                    },
                  ),

                  SizedBox(height: size.height / 20),

                  _buildActionTile(
                    size,
                    Icons.lock_outline,
                    'Change Password',
                    () => _showChangePasswordDialog(context),
                  ),
                  SizedBox(height: size.height / 80),
                  _buildActionTile(size, Icons.logout, 'Logout', () {
                    Get.dialog(
                      AlertDialog(
                        title: const Text('Logout'),
                        content: const Text('Are you sure you want to logout?'),
                        actions: [
                          TextButton(
                            onPressed: () => Get.back(),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              controller.logout();
                              Get.back();
                            },
                            child: const Text(
                              'Logout',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                  SizedBox(height: size.height / 80),
                  _buildActionTile(
                    size,
                    Icons.delete_forever,
                    'Delete Account',
                    () {
                      Get.dialog(
                        AlertDialog(
                          title: const Text('Delete Account'),
                          content: const Text(
                            'Are you sure you want to delete your account?',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Get.back(), // Close dialog
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                Get.back(); // Close dialog first
                                // Call the controller method
                                controller.deleteAccount(user.id!);
                              },
                              child: const Text(
                                'Delete',
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    isDestructive: true,
                  ),
                  SizedBox(height: size.height / 10),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  void _showGenderSelection(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: ['male', 'female'].map((gender) {
            return ListTile(
              title: Text(
                gender,
                style: Fonts.semiBoldTextStyle(color: AppTheme.textPrimary),
              ),
              leading: const Icon(Icons.person, color: AppTheme.primaryColor),
              onTap: () {
                controller.updateProfile({'gender': gender});
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showChangePasswordDialog(BuildContext context) {
    oldPassCtrl.clear();
    newPassCtrl.clear();
    confirmPassCtrl.clear();

    Get.dialog(
      AlertDialog(
        backgroundColor: Colors.white,
        title: Text(
          "Change Password",
          style: Fonts.boldTextStyle(color: AppTheme.primaryColor),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextfieldAuth(
              controller: oldPassCtrl,
              labelText: "Old Password",
              obscureText: true,
              cursorColor: AppTheme.primaryColor,
              textColor: AppTheme.textPrimary,
              labelColor: AppTheme.primaryColor,
            ),
            const SizedBox(height: 15),
            TextfieldAuth(
              controller: newPassCtrl,
              labelText: "New Password",
              obscureText: true,
              cursorColor: AppTheme.primaryColor,
              textColor: AppTheme.textPrimary,
              labelColor: AppTheme.primaryColor,
            ),
            const SizedBox(height: 15),
            TextfieldAuth(
              controller: confirmPassCtrl,
              labelText: "Confirm Password",
              obscureText: true,
              cursorColor: AppTheme.primaryColor,
              textColor: AppTheme.textPrimary,
              labelColor: AppTheme.primaryColor,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              "Cancel",
              style: Fonts.semiBoldTextStyle(color: Colors.grey),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
            ),
            onPressed: () {
              if (oldPassCtrl.text.isEmpty || newPassCtrl.text.isEmpty) {
                ToastBar.showToast(
                  'Please fill all fields',
                  context,
                  Colors.orange,
                );
                return;
              }
              controller.changePassword(
                oldPassCtrl.text,
                newPassCtrl.text,
                confirmPassCtrl.text,
              );
            },
            child: controller.isLoading.value
                ? CircularProgressIndicator(color: AppTheme.textOnBackground)
                : Text(
                    "Update",
                    style: Fonts.boldTextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileTile(
    Size size,
    IconData icon,
    String title,
    String value, {
    Color? color,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Row(
        children: [
          Icon(
            icon,
            color: color ?? AppTheme.primaryColor,
            size: size.width / 18,
          ),
          SizedBox(width: size.width / 25),
          Text(
            title,
            style: Fonts.semiBoldTextStyle(
              fontSize: size.width / 24,
              color: Colors.black87,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: Fonts.regularTextStyle(
              fontSize: size.width / 28,
              color: color ?? Colors.grey[700],
            ),
          ),
          if (onTap != null) ...[
            const SizedBox(width: 8),
            Icon(Icons.edit, size: 16, color: Colors.grey[400]),
          ],
        ],
      ),
    );
  }

  Widget _buildActionTile(
    Size size,
    IconData icon,
    String title,
    VoidCallback onTap, {
    bool isDestructive = false,
  }) {
    final color = isDestructive ? Colors.red : AppTheme.primaryColor;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: size.width / 20,
          vertical: size.height / 60,
        ),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(size.width / 30),
        ),
        child: Row(
          children: [
            Icon(icon, color: color),
            SizedBox(width: size.width / 25),
            Text(
              title,
              style: Fonts.boldTextStyle(
                fontSize: size.width / 24,
                color: color,
              ),
            ),
            const Spacer(),
            Icon(Icons.arrow_forward_ios, color: color, size: size.width / 25),
          ],
        ),
      ),
    );
  }
}
