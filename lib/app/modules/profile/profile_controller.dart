import 'package:chat_application/CommonWidget/toast_bar.dart';
import 'package:chat_application/app/data/models/auth_models.dart';
import 'package:chat_application/app/data/repositories/auth_repository.dart';
import 'package:chat_application/app/data/repositories/profile_repository.dart';
import 'package:chat_application/app/routes/app_routes.dart';
import 'package:chat_application/app/services/auth_service.dart';
import 'package:chat_application/core/utils/app_global.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  final ProfileRepository _repository = ProfileRepository();
  final AuthRepository _authRepository =
      AuthRepository(); // Added for password change

  // Reactive state variables
  final Rx<User?> myProfile = Rx<User?>(null);
  final isLoadingProfile = true.obs;
  final isUpdatingPic = false.obs;
  final isSaving = false.obs;
  RxBool isBioFocused = false.obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    getMyProfile();
  }

  Future<void> onRefresh() async {
    await Future.wait([getMyProfile()]);
  }

  // GET MY PROFILE
  Future<void> getMyProfile() async {
    try {
      isLoadingProfile.value = true;
      final response = await _repository.getMyProfile();
      if (response.success && response.data != null) {
        myProfile.value = response.data;
      } else {
        ToastBar.showToast(response.message, Get.context!, Colors.red);
      }
    } catch (e) {
      AppGlobal.printLog("Get My Profile Error: $e");
    } finally {
      isLoadingProfile.value = false;
    }
  }

  // UPDATE PROFILE
  Future<void> updateProfile(Map<String, dynamic> data) async {
    try {
      isSaving.value = true;
      final response = await _repository.updateMyProfile(data);
      if (response.success && response.data != null) {
        myProfile.value = response.data;
        ToastBar.showToast(
          'Profile updated successfully',
          Get.context!,
          Colors.green,
        );
      } else {
        ToastBar.showToast(response.message, Get.context!, Colors.red);
      }
    } catch (e) {
      AppGlobal.printLog("Update Profile Error: $e");
    } finally {
      isSaving.value = false;
    }
  }

  // SAVE TEXT CHANGES (Username & Bio)
  Future<void> saveProfileChanges(String newUsername, String newBio) async {
    Map<String, dynamic> data = {};
    if (newUsername.isNotEmpty && newUsername != myProfile.value?.username) {
      data['username'] = newUsername;
    }
    if (newBio != (myProfile.value?.bio ?? '')) {
      data['bio'] = newBio;
    }

    if (data.isNotEmpty) {
      await updateProfile(data);
    } else {
      ToastBar.showToast('No changes detected', Get.context!, Colors.orange);
    }
  }

  // CHANGE PASSWORD
  Future<void> changePassword(
    String oldPassword,
    String newPassword,
    String confirmPassword,
  ) async {
    if (newPassword != confirmPassword) {
      ToastBar.showToast(
        'New passwords do not match',
        Get.context!,
        Colors.red,
      );
      return;
    }
    try {
      isLoading.value = true;
      final response = await _authRepository.changePassword(
        oldPassword: oldPassword,
        newPassword: newPassword,
        confirmPassword: confirmPassword,
      );
      if (response.success) {
        Get.back(); // Close dialog
        ToastBar.showToast(
          'Password changed successfully',
          Get.context!,
          Colors.green,
        );
      } else {
        ToastBar.showToast(response.message, Get.context!, Colors.red);
      }
    } catch (e) {
      AppGlobal.printLog("Change Password Error: $e");
      ToastBar.showToast('Failed to change password', Get.context!, Colors.red);
    } finally {
      isLoading.value = false;
    }
  }

  // UPLOAD PROFILE PIC
  Future<void> handleProfilePicUpload(String filePath) async {
    try {
      isUpdatingPic.value = true;
      final response = await _repository.uploadProfilePic(filePath);

      if (response.success && response.data != null) {
        if (myProfile.value != null) {
          myProfile.value = User(
            id: myProfile.value!.id,
            username: myProfile.value!.username,
            email: myProfile.value!.email,
            mobile: myProfile.value!.mobile,
            isVerified: myProfile.value!.isVerified,
            gender: myProfile.value!.gender,
            bio: myProfile.value!.bio,
            profilePic: response.data!.profilePic, // <-- NEW IMAGE URL
          );
        }

        ToastBar.showToast(
          'Profile picture updated successfully',
          Get.context!,
          Colors.green,
        );
      } else {
        ToastBar.showToast(response.message, Get.context!, Colors.red);
      }
    } catch (e) {
      AppGlobal.printLog("Upload Profile Picture Error: $e");
    } finally {
      isUpdatingPic.value = false;
    }
  }

  // DELETE PROFILE PHOTO
  Future<void> deleteProfilePic() async {
    try {
      isUpdatingPic.value = true;
      final response = await _repository.deleteProfilePic();

      if (response.success) {
        if (myProfile.value != null) {
          myProfile.value = User(
            id: myProfile.value!.id,
            username: myProfile.value!.username,
            email: myProfile.value!.email,
            mobile: myProfile.value!.mobile,
            isVerified: myProfile.value!.isVerified,
            gender: myProfile.value!.gender,
            bio: myProfile.value!.bio,
            profilePic: '',
          );
        }

        ToastBar.showToast(
          'Profile picture deleted successfully',
          Get.context!,
          Colors.green,
        );
      } else {
        ToastBar.showToast(response.message, Get.context!, Colors.red);
      }
    } catch (e) {
      AppGlobal.printLog("Delete Profile Picture Error: $e");
    } finally {
      isUpdatingPic.value = false;
    }
  }

  // DELETE ACCOUNT
  Future<void> deleteAccount(String accountId) async {
    try {
      isLoading.value = true;
      final response = await _authRepository.deleteAccount(
        accountId: accountId,
      );

      if (response.success) {
        ToastBar.showToast(
          'Account deleted successfully',
          Get.context!,
          Colors.green,
        );
        // Clear saved token and user ID
        await AuthService.to.clearAuth();
        // Redirect to login page
        Get.offAllNamed(Routes.login);
      } else {
        ToastBar.showToast(response.message, Get.context!, Colors.red);
      }
    } catch (e) {
      AppGlobal.printLog("Delete Account Error: $e");
      ToastBar.showToast('Failed to delete account', Get.context!, Colors.red);
    } finally {
      isLoading.value = false;
    }
  }

  // LOGOUT
  void logout() async {
    try {
      isLoading.value = true;
      AppGlobal.printLog("[PROFILE] Logging out...");
      AuthService.to.clearAuth();
      Get.offAllNamed(Routes.login);
    } catch (e) {
      AppGlobal.printLog("Logout Error: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
