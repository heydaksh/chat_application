import 'package:chat_application/CommonWidget/custom_background_with_appbar.dart';
import 'package:chat_application/CommonWidget/custom_text_field.dart';
import 'package:chat_application/CommonWidget/typing_indicator.dart';
import 'package:chat_application/app/data/models/chat_models.dart';
import 'package:chat_application/app/data/models/friends_models.dart';
import 'package:chat_application/app/modules/chat/chatting_controller.dart';
import 'package:chat_application/core/theme/app_theme.dart';
import 'package:chat_application/core/utils/fonts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChattingScreen extends GetView<ChattingController> {
  const ChattingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Determine the name of the other participant for the Title
    final otherParticipant = controller.chatRoom.participants.firstWhere(
      (p) => p.id != controller.myUserId,
      orElse: () => FriendUser(id: '', username: 'Unknown User'),
    );
    final title = otherParticipant.username ?? 'Chat';

    return CustomBackgroundWithAppBar(
      title: title,
      onBackTap: () => Get.back(),
      child: Column(
        children: [
          Expanded(
            child: Obx(() {
              if (controller.isLoadingMessages.value &&
                  controller.messages.isEmpty) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: AppTheme.primaryColor,
                  ),
                );
              }

              if (controller.messages.isEmpty) {
                return Center(
                  child: Text(
                    "No messages yet. Say hi!",
                    style: Fonts.semiBoldTextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                  ),
                );
              }

              return ListView.builder(
                reverse: true,
                controller: controller.scrollController,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                itemCount: controller.messages.length + 1,
                itemBuilder: (context, index) {
                  if (index == controller.messages.length) {
                    return Obx(() {
                      if (controller.isLoadingMore.value) {
                        return const Padding(
                          padding: .all(8),
                          child: SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppTheme.primaryColor,
                            ),
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    });
                  }
                  final msg = controller.messages[index];
                  final isMe =
                      msg.sender?.id == controller.myUserId ||
                      msg.sender == null;

                  return _buildMessageBubble(msg, isMe);
                },
              );
            }),
          ),
          _buildBottomInputArea(),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(Message msg, bool isMe) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 5),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        constraints: BoxConstraints(maxWidth: Get.width * 0.75),
        decoration: BoxDecoration(
          color: isMe ? AppTheme.primaryColor : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: isMe
                ? const Radius.circular(16)
                : const Radius.circular(0),
            bottomRight: isMe
                ? const Radius.circular(0)
                : const Radius.circular(16),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          msg.content,
          style: Fonts.regularTextStyle(
            color: isMe ? Colors.white : AppTheme.textPrimary,
            fontSize: 15,
          ),
        ),
      ),
    );
  }

  Widget _buildBottomInputArea() {
    return Column(
      mainAxisSize: .min,
      crossAxisAlignment: .start,
      children: [
        Obx(() {
          if (controller.isOtherTyping.value) {
            return Padding(
              padding: const EdgeInsets.only(left: 20, bottom: 5),
              child: const TypingIndicator(),
            );
          }
          return const SizedBox.shrink();
        }),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: SafeArea(
            child: Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    controller: controller.textController,
                    hintText: "Type your message...",
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Obx(
                  () => GestureDetector(
                    onTap: controller.isSending.value
                        ? null
                        : () => controller.sendMessage(),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: controller.isSending.value
                            ? Colors.grey
                            : AppTheme.primaryColor,
                        shape: BoxShape.circle,
                      ),
                      child: controller.isSending.value
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Icon(
                              Icons.send_rounded,
                              color: Colors.white,
                              size: 20,
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
