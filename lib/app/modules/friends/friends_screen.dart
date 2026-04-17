import 'package:chat_application/CommonWidget/custom_button.dart';
import 'package:chat_application/CommonWidget/custom_text_field.dart';
import 'package:chat_application/app/modules/friends/friends_controller.dart';
import 'package:chat_application/app/routes/app_routes.dart';
import 'package:chat_application/core/theme/app_theme.dart';
import 'package:chat_application/core/utils/fonts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FriendsScreen extends GetView<FriendsController> {
  const FriendsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Color surfaceColor = const Color(0xFFFAF5F2);
    final Color outlineColor = Colors.grey.withValues(alpha: 0.3);

    return SafeArea(
      child: RefreshIndicator(
        onRefresh: controller.onRefresh,
        color: AppTheme.primaryColor,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// --- MY FRIENDS SHORTCUT ---
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppTheme.primaryColor.withValues(alpha: 0.8),
                      AppTheme.primaryColor,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 5,
                  ),
                  leading: const Icon(
                    Icons.people_alt,
                    color: Colors.white,
                    size: 30,
                  ),
                  title: Text(
                    'View My Friends',
                    style: Fonts.boldTextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                  subtitle: Text(
                    'See and manage your accepted friends',
                    style: Fonts.regularTextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                    ),
                  ),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
                    size: 18,
                  ),
                  onTap: () => Get.toNamed(Routes.myFriends),
                ),
              ),
              const SizedBox(height: 30),

              /// --- FRIEND REQUESTS ---
              _buildSectionHeader('Friend Requests', onSeeAll: () {}),
              const SizedBox(height: 10),
              Obx(() {
                if (controller.isLoadingRequests.value) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: AppTheme.primaryColor,
                    ),
                  );
                }
                if (controller.requestList.isEmpty) {
                  return Text(
                    "No pending requests.",
                    style: Fonts.regularTextStyle(color: Colors.grey),
                  );
                }
                return Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: surfaceColor,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: outlineColor),
                  ),
                  child: ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: controller.requestList.length,
                    separatorBuilder: (_, _) =>
                        Divider(color: outlineColor, height: 30),
                    itemBuilder: (context, index) {
                      final request = controller.requestList[index];
                      return _buildRequestTile(
                        requestId: request.requestId,
                        name: request.sender?.username ?? 'Unknown',
                        imageUrl: request.sender?.profilePic ?? '',
                        onAccept: () => controller.handleRequests(
                          request.requestId,
                          'accepted',
                        ),
                        onDecline: () => controller.handleRequests(
                          request.requestId,
                          'rejected',
                        ),
                      );
                    },
                  ),
                );
              }),

              const SizedBox(height: 30),

              /// --- FRIEND SUGGESTIONS ---
              _buildSectionHeader('Friend Suggestions', onSeeAll: () {}),
              const SizedBox(height: 10),
              Obx(() {
                if (controller.isLoadingSuggestions.value) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: AppTheme.primaryColor,
                    ),
                  );
                }
                if (controller.suggestionList.isEmpty) {
                  return Text(
                    "No suggestions available.",
                    style: Fonts.regularTextStyle(color: Colors.grey),
                  );
                }
                return Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: surfaceColor,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: outlineColor),
                  ),
                  child: ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: controller.suggestionList.length,
                    separatorBuilder: (_, _) =>
                        Divider(color: outlineColor, height: 30),
                    itemBuilder: (context, index) {
                      final suggestion = controller.suggestionList[index];
                      return _buildSuggestionTile(
                        id: suggestion.id!,
                        name: suggestion.username ?? 'Unknown',
                        imageUrl: suggestion.profilePic ?? '',
                        onAddFriend: () => controller.addFriend(suggestion.id!),
                      );
                    },
                  ),
                );
              }),

              const SizedBox(height: 30),

              /// --- SEARCH FRIENDS ---
              _buildSectionHeader('Search Friends', onSeeAll: () {}),
              const SizedBox(height: 10),
              CustomTextField(
                hintText: 'Search friends...',
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  // --- HELPER WIDGETS ---

  Widget _buildSectionHeader(String title, {required VoidCallback onSeeAll}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: Fonts.boldTextStyle(
            fontSize: 20,
            color: AppTheme.primaryColor, // Reusing your brown color
          ),
        ),
        GestureDetector(
          onTap: onSeeAll,
          child: Row(
            children: [
              Text(
                'See All',
                style: Fonts.regularTextStyle(color: Colors.grey, fontSize: 14),
              ),
              const Icon(Icons.chevron_right, color: Colors.grey, size: 18),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRequestTile({
    required String requestId,
    required String name,
    required String imageUrl,
    required VoidCallback onAccept,
    required VoidCallback onDecline,
  }) {
    return Row(
      children: [
        CircleAvatar(
          radius: 28,
          backgroundColor: Colors.grey[300],
          backgroundImage: imageUrl.isNotEmpty ? NetworkImage(imageUrl) : null,
          child: imageUrl.isEmpty
              ? const Icon(Icons.person, color: Colors.grey)
              : null,
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: Fonts.semiBoldTextStyle(fontSize: 16)),
              const SizedBox(height: 10),
              Row(
                children: [
                  CustomButton(
                    text: 'Accept',
                    width: 90,
                    height: 35,
                    fontSize: 14,
                    onPressed: onAccept,
                  ),
                  const SizedBox(width: 10),
                  CustomButton(
                    text: 'Decline',
                    width: 90,
                    height: 35,
                    fontSize: 14,
                    isSecondary: true,
                    onPressed: onDecline,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSuggestionTile({
    required String id,
    required String name,
    required String imageUrl,
    required VoidCallback onAddFriend,
  }) {
    return Row(
      children: [
        CircleAvatar(
          radius: 25,
          backgroundColor: Colors.grey[300],
          backgroundImage: imageUrl.isNotEmpty ? NetworkImage(imageUrl) : null,
          child: imageUrl.isEmpty
              ? const Icon(Icons.person, color: Colors.grey)
              : null,
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: Fonts.semiBoldTextStyle(fontSize: 16)),
              const SizedBox(height: 2),
            ],
          ),
        ),
        Obx(() {
          final isLoading = controller.loadingFriendIds.contains(id);
          final isSent = controller.sentFriendIds.contains(id);
          return CustomButton(
            text: isSent ? 'Sent' : 'Add Friend',
            width: 110,
            height: 35,
            fontSize: 14,
            isSecondary: isSent,
            isLoading: isLoading,
            onPressed: isSent ? () {} : onAddFriend,
          );
        }),
      ],
    );
  }
}
