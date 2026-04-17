import 'package:chat_application/CommonWidget/toast_bar.dart';
import 'package:chat_application/app/data/models/chat_models.dart';
import 'package:chat_application/app/data/models/friends_models.dart';
import 'package:chat_application/app/data/repositories/chat_repository.dart';
import 'package:chat_application/app/routes/app_routes.dart';
import 'package:chat_application/core/theme/app_theme.dart';
import 'package:chat_application/core/utils/app_global.dart';
import 'package:chat_application/core/widgets/sockets/socket_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatController extends GetxController {
  final ChatRepository _repository = ChatRepository();

  final chatRooms = <ChatRoom>[].obs;
  final isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeChatSetup();
    _listenToChatUpdates();
  }

  void _listenToChatUpdates() {
    SocketService().socket?.on('chat_list_update', (data) {
      if (data != null && data is Map<String, dynamic>) {
        final chatId = data['chatId'];
        final lastMessageText = data['lastMessage'];

        final roomIndex = chatRooms.indexWhere((room) => room.id == chatId);
        if (roomIndex != -1) {
          var updateRoom = chatRooms[roomIndex];

          final updateMessage = Message(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            chatId: chatId,
            content: lastMessageText,
            messageType: 'text',
          );

          final newRoom = ChatRoom(
            id: updateRoom.id,
            participants: updateRoom.participants,
            lastMessage: updateMessage,
            createdAt: updateMessage.createdAt,
            updatedAt: DateTime.now().toIso8601String(),
          );

          chatRooms.removeAt(roomIndex);
          chatRooms.insert(0, newRoom);
        } else {
          fetchRooms();
        }
      }
    });
  }

  Future<void> _initializeChatSetup() async {
    await fetchRooms();
  }

  Future<void> startChatWithFriend(FriendUser friend) async {
    try {
      AppGlobal.printLog(
        "[CHAT] Processing chat room with friend: ${friend.id}",
      );
      Get.dialog(
        const Center(
          child: CircularProgressIndicator(color: AppTheme.textOnBackground),
        ),
        barrierDismissible: false,
      );

      final response = await _repository.createChatRoom(friend.id!);
      Get.back();

      if (response.success && response.data != null) {
        ChatRoom rooms = response.data!;
        for (int i = 0; i < rooms.participants.length; i++) {
          if (rooms.participants[i].id == friend.id) {
            rooms.participants[i] = friend;
          }
        }

        AppGlobal.printLog(
          "[CHAT] Success! Navigating to chatting screen with roomID : ${rooms.id}",
        );
        Get.toNamed(Routes.messageScreen, arguments: rooms);
      } else {
        ToastBar.showToast(response.message, Get.context!, Colors.red);
      }
    } catch (e) {
      if (Get.isDialogOpen ?? false) Get.back();
      AppGlobal.printLog("[CHAT ERROR] Failed to start chat: $e");
      ToastBar.showToast('Could not initiate chat!', Get.context!, Colors.red);
    }
  }

  Future<void> fetchRooms() async {
    try {
      isLoading.value = true;
      AppGlobal.printLog("[CHAT] Fetching chat rooms...");

      final response = await _repository.getChatRooms();

      if (response.success && response.data != null) {
        chatRooms.assignAll(response.data!);
        AppGlobal.printLog(
          "[CHAT] Successfully loaded ${chatRooms.length} rooms.",
        );
      } else {
        ToastBar.showToast(response.message, Get.context!, Colors.red);
      }
    } catch (e) {
      AppGlobal.printLog("[CHAT ERROR] Fetching rooms failed: $e");
      ToastBar.showToast('Could not load chat rooms', Get.context!, Colors.red);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createRoom(String participantId) async {
    try {
      AppGlobal.printLog(
        "[CHAT] Creating room with participant: $participantId",
      );
      final response = await _repository.createChatRoom(participantId);

      if (response.success) {
        AppGlobal.printLog("[CHAT] Room created or already exists.");
      } else {
        ToastBar.showToast(response.message, Get.context!, Colors.red);
      }
    } catch (e) {
      AppGlobal.printLog("[CHAT ERROR] Create room failed: $e");
    }
  }

  @override
  void onClose() {
    SocketService().socket?.off('chat_list_update');
    super.onClose();
  }
}
