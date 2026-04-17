import 'package:chat_application/app/data/models/friends_models.dart';
import 'package:chat_application/app/modules/chat/chat_controller.dart';
import 'package:chat_application/app/routes/app_routes.dart';
import 'package:chat_application/app/services/auth_service.dart';
import 'package:chat_application/core/theme/app_theme.dart';
import 'package:chat_application/core/utils/app_global.dart';
import 'package:chat_application/core/utils/fonts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatScreen extends GetView<ChatController> {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF5F2),
      appBar: Get.previousRoute.isNotEmpty
          ? AppBar(
              title: Text(
                "Chats",
                style: Fonts.boldTextStyle(color: AppTheme.primaryColor),
              ),
              backgroundColor: Colors.white,
              iconTheme: const IconThemeData(color: AppTheme.primaryColor),
              elevation: 0,
            )
          : null,
      body: SafeArea(
        child: RefreshIndicator(
          color: AppTheme.primaryColor,
          onRefresh: controller.fetchRooms,
          child: Obx(() {
            if (controller.isLoading.value && controller.chatRooms.isEmpty) {
              return const Center(
                child: CircularProgressIndicator(color: AppTheme.primaryColor),
              );
            }

            if (controller.chatRooms.isEmpty) {
              return ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.3),
                  Center(
                    child: Column(
                      children: [
                        Icon(
                          Icons.chat_bubble_outline,
                          size: 60,
                          color: Colors.grey.withValues(alpha: 0.5),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "No active chats yet. Start a conversation!",
                          style: Fonts.semiBoldTextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }

            return ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              itemCount: controller.chatRooms.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final room = controller.chatRooms[index];

                // Identify the other user in the room to display their name and image
                final myId = AuthService.to.userId ?? '';
                final otherParticipant = room.participants.firstWhere(
                  (p) => p.id != myId,
                  orElse: () => room.participants.isNotEmpty
                      ? room.participants.first
                      : FriendUser(id: '', username: 'Unknown'),
                );

                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: Colors.grey.withValues(alpha: 0.2),
                    ),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 8,
                    ),
                    leading: CircleAvatar(
                      radius: 25,
                      backgroundColor: Colors.grey[200],
                      backgroundImage:
                          (otherParticipant.profilePic != null &&
                              otherParticipant.profilePic!.isNotEmpty)
                          ? NetworkImage(otherParticipant.profilePic!)
                          : null,
                      child:
                          (otherParticipant.profilePic == null ||
                              otherParticipant.profilePic!.isEmpty)
                          ? Icon(
                              Icons.person,
                              color: Colors.grey.withValues(alpha: 0.6),
                            )
                          : null,
                    ),
                    title: Text(
                      otherParticipant.username ?? 'Unknown User',
                      style: Fonts.boldTextStyle(
                        fontSize: 16,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    subtitle: Text(
                      room.lastMessage?.content ?? "Tap to open conversation",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Fonts.regularTextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        if (room.lastMessage?.createdAt != null)
                          Text(
                            _formatDate(room.lastMessage!.createdAt!),
                            style: Fonts.regularTextStyle(
                              fontSize: 11,
                              color: Colors.grey,
                            ),
                          ),
                        const Icon(
                          Icons.chevron_right,
                          color: Colors.grey,
                          size: 20,
                        ),
                      ],
                    ),
                    onTap: () {
                      AppGlobal.printLog("Opened Chat Room ID: ${room.id}");
                      Get.toNamed(Routes.messageScreen, arguments: room);
                    },
                  ),
                );
              },
            );
          }),
        ),
      ),
    );
  }

  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr).toLocal();
      final now = DateTime.now();
      if (date.year == now.year &&
          date.month == now.month &&
          date.day == now.day) {
        return "${date.hour}:${date.minute.toString().padLeft(2, '0')}";
      }
      return "${date.day}/${date.month}";
    } catch (_) {
      return "";
    }
  }
}
