import 'package:chat_application/CommonWidget/toast_bar.dart';
import 'package:chat_application/app/data/models/friends_models.dart';
import 'package:chat_application/app/data/repositories/friend_repository.dart';
import 'package:chat_application/core/utils/app_global.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FriendsController extends GetxController {
  final FriendRepository _repository = FriendRepository();
  final isLoadingRequests = true.obs;
  final isLoadingSuggestions = true.obs;
  final isLoadingFriends = true.obs;
  final loadingFriendIds = <String>{}.obs;
  final sentFriendIds = <String>{}.obs;

  var requestList = <FriendRequest>[].obs;
  var suggestionList = <FriendUser>[].obs;
  var myFriendsList = <FriendUser>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchRequests();
    fetchSuggestions();
  }

  Future<void> onRefresh() async {
    await Future.wait([fetchRequests(), fetchSuggestions()]);
  }

  Future<void> fetchRequests() async {
    try {
      isLoadingRequests.value = true;
      final response = await _repository.getRequests();
      if (response.success && response.data != null) {
        requestList.assignAll(response.data!);
      }
    } catch (e) {
      AppGlobal.printLog('Fetch Requests Error: $e');
      ToastBar.showToast(
        'Could not fetch requests: $e',
        Get.context!,
        Colors.red,
      );
    } finally {
      isLoadingRequests.value = false;
    }
  }

  Future<void> fetchSuggestions() async {
    try {
      isLoadingSuggestions.value = true;
      final response = await _repository.getSuggestions();
      if (response.success && response.data != null) {
        suggestionList.assignAll(response.data!.suggestions);
      }
    } catch (e) {
      AppGlobal.printLog('Fetch Suggestions Error: $e');
      ToastBar.showToast(
        'Could not fetch suggestions: $e',
        Get.context!,
        Colors.red,
      );
    } finally {
      isLoadingSuggestions.value = false;
    }
  }

  Future<void> handleRequests(String requestId, String action) async {
    try {
      final response = await _repository.actionRequest(requestId, action);
      if (response.success) {
        requestList.removeWhere((req) => req.requestId == requestId);
        ToastBar.showToast(
          'Request ${action == 'accepted' ? "Accepted" : "Declined"}',
          Get.context!,
          Colors.green,
        );
      } else {
        ToastBar.showToast(response.message, Get.context!, Colors.red);
      }
    } catch (e) {
      AppGlobal.printLog("Handle Request Error: $e");
    }
  }

  Future<void> addFriend(String receiverId) async {
    if (loadingFriendIds.contains(receiverId) ||
        sentFriendIds.contains(receiverId)) {
      return;
    }

    try {
      loadingFriendIds.add(receiverId);

      final response = await _repository.sendRequest(receiverId);
      if (response.success) {
        loadingFriendIds.remove(receiverId);
        sentFriendIds.add(receiverId);

        // Wait to show "Sent" UI before disappearing
        await Future.delayed(const Duration(seconds: 1));

        suggestionList.removeWhere((user) => user.id == receiverId);
        sentFriendIds.remove(receiverId);

        ToastBar.showToast('Friend request sent!', Get.context!, Colors.green);
      } else {
        loadingFriendIds.remove(receiverId);
        ToastBar.showToast(response.message, Get.context!, Colors.red);
      }
    } catch (e) {
      loadingFriendIds.remove(receiverId);
      AppGlobal.printLog("Add Friend Error: $e");
    }
  }

  Future<void> fetchFriends() async {
    try {
      isLoadingFriends.value = true;

      final response = await _repository.getFriends();
      if (response.success && response.data != null) {
        myFriendsList.assignAll(response.data!.friends);
        AppGlobal.printLog("Loaded ${myFriendsList.length} friends directly.");
      }
    } catch (e) {
      AppGlobal.printLog('Fetch Friends Error: $e');
      ToastBar.showToast(
        'Could not fetch friends: $e',
        Get.context!,
        Colors.red,
      );
    } finally {
      isLoadingFriends.value = false;
    }
  }

  Future<void> removeFriend(String friendId) async {
    try {
      final response = await _repository.removeFriend(friendId);
      if (response.success) {
        myFriendsList.removeWhere((user) => user.id == friendId);
        ToastBar.showToast(
          "Friend removed successfully",
          Get.context!,
          Colors.green,
        );
      } else {
        ToastBar.showToast(response.message, Get.context!, Colors.red);
      }
    } catch (e) {
      AppGlobal.printLog("Remove Friend Error: $e");
      ToastBar.showToast('Something went wrong.', Get.context!, Colors.red);
    }
  }
}
