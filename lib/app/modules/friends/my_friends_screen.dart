import 'package:chat_application/CommonWidget/custom_background_with_appbar.dart';
import 'package:chat_application/app/modules/chat/chat_controller.dart';
import 'package:chat_application/app/modules/friends/friends_controller.dart';
import 'package:chat_application/core/theme/app_theme.dart';
import 'package:chat_application/core/utils/app_global.dart';
import 'package:chat_application/core/utils/fonts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyFriendsScreen extends StatefulWidget {
  const MyFriendsScreen({super.key});

  @override
  State<MyFriendsScreen> createState() => _MyFriendsScreenState();
}

class _MyFriendsScreenState extends State<MyFriendsScreen> {
  final FriendsController controller = Get.find<FriendsController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchFriends();
    });
  }

  @override
  Widget build(BuildContext context) {
    final Color surfaceColor = AppTheme.primaryColor.withValues(alpha: 0.1);
    final Color outlineColor = Colors.grey.withValues(alpha: 0.3);

    return CustomBackgroundWithAppBar(
      title: 'My Friends',
      onBackTap: () => Get.back(),
      child: Obx(() {
        if (controller.isLoadingFriends.value &&
            controller.myFriendsList.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(color: AppTheme.primaryColor),
          );
        }

        if (controller.myFriendsList.isEmpty) {
          return RefreshIndicator(
            color: AppTheme.primaryColor,
            onRefresh: controller.fetchFriends,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.25),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.people_outline,
                        size: 80,
                        color: Colors.grey.withValues(alpha: 0.5),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "You haven't added any friends yet.",
                        style: Fonts.semiBoldTextStyle(
                          color: Colors.grey,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          color: AppTheme.primaryColor,
          onRefresh: controller.fetchFriends,
          child: ListView.separated(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            itemCount: controller.myFriendsList.length,
            separatorBuilder: (context, index) => const SizedBox(height: 15),
            itemBuilder: (context, index) {
              final friend = controller.myFriendsList[index];
              return Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: surfaceColor,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: outlineColor),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 25,
                      backgroundImage:
                          (friend.profilePic != null &&
                              friend.profilePic!.isNotEmpty)
                          ? NetworkImage(friend.profilePic!)
                          : null,
                      child:
                          (friend.profilePic == null ||
                              friend.profilePic!.isEmpty)
                          ? Icon(
                              Icons.person,
                              size: 25,
                              color: Colors.grey.withValues(alpha: 0.5),
                            )
                          : null,
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            friend.username ?? 'Unknown',
                            style: Fonts.boldTextStyle(fontSize: 16),
                          ),
                          Text(
                            friend.email ?? '',
                            style: Fonts.regularTextStyle(
                              fontSize: 13,
                              color: Colors.grey,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),

                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            AppGlobal.printLog(
                              "Direct chat icon tapped for friend: ${friend.id}",
                            );
                            final ChatController chatController =
                                Get.isRegistered<ChatController>()
                                ? Get.find<ChatController>()
                                : Get.put(ChatController());
                            chatController.startChatWithFriend(friend);
                          },
                          icon: Icon(Icons.chat, color: AppTheme.primaryColor),
                        ),
                        IconButton(
                          onPressed: () {
                            controller.removeFriend(friend.id!);

                            AppGlobal.printLog(
                              "Removed friend mapping ID: ${friend.id}",
                            );
                          },
                          icon: Icon(Icons.person_off),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        );
      }),
    );
  }
}
