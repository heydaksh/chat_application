import 'dart:async';

import 'package:chat_application/CommonWidget/toast_bar.dart';
import 'package:chat_application/app/data/models/chat_models.dart';
import 'package:chat_application/app/data/repositories/chat_repository.dart';
import 'package:chat_application/app/modules/chat/chat_pagination.dart';
import 'package:chat_application/app/services/auth_service.dart';
import 'package:chat_application/core/utils/app_global.dart';
import 'package:chat_application/core/widgets/sockets/socket_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChattingController extends GetxController with ChatPaginationMixin {
  final ChatRepository _repository = ChatRepository();

  final messages = <Message>[].obs;
  final isLoadingMessages = true.obs;
  final isSending = false.obs;
  final isOtherTyping = false.obs;

  final TextEditingController textController = TextEditingController();

  late final ChatRoom chatRoom;
  String get myUserId => AuthService.to.userId ?? '';

  Timer? _typingTimer;

  @override
  void onInit() {
    super.onInit(); // This initializes the scroll listener from the mixin
    if (Get.arguments is ChatRoom) {
      chatRoom = Get.arguments as ChatRoom;
      fetchMessages(); // Initial fetch
      _setupSocket();
      _setupTypingListener();
    } else {
      AppGlobal.printLog("ERROR: ChatRoom argument missing.");
      Get.back();
    }
  }

  Future<void> fetchMessages() async {
    try {
      isLoadingMessages.value = true;
      currentPage.value = 1;

      final response = await _repository.getMessages(
        chatRoom.id,
        page: currentPage.value,
        limit: limit,
      );

      if (response.success && response.data != null) {
        messages.assignAll(response.data!.messages.reversed.toList());
        totalPages.value = response.data!.meta.totalPages;
        AppGlobal.printLog(
          "[CHAT] Loaded ${messages.length} messages. Total Pages: ${totalPages.value}",
        );
      } else {
        ToastBar.showToast(response.message, Get.context!, Colors.red);
      }
    } catch (e) {
      AppGlobal.printLog("Fetch messages error: $e");
      ToastBar.showToast('Could not load messages', Get.context!, Colors.red);
    } finally {
      isLoadingMessages.value = false;
    }
  }

  // Implementation of the mixin method
  @override
  Future<void> loadMoreMessages() async {
    try {
      isLoadingMore.value = true;
      currentPage.value++; // Increment page

      final response = await _repository.getMessages(
        chatRoom.id,
        page: currentPage.value,
        limit: limit,
      );

      if (response.success && response.data != null) {
        // Add older messages to the END of the list (since ListView is reversed)
        messages.addAll(response.data!.messages.reversed.toList());
        totalPages.value = response.data!.meta.totalPages;
      }
    } catch (e) {
      AppGlobal.printLog("Load more messages error: $e");
      currentPage.value--; // Revert page increment on failure
    } finally {
      isLoadingMore.value = false;
    }
  }

  void _setupSocket() {
    // Join the room
    SocketService().joinChat(chatRoom.id);

    // Listen for new messages
    SocketService().socket?.on("new_message", (data) {
      if (data != null && data is Map<String, dynamic>) {
        final newMessage = Message.fromJson(data);
        AppGlobal.printLog(newMessage.toString());
        final isDuplicate = messages.any((m) => m.id == newMessage.id);

        if (!isDuplicate && newMessage.chatId == chatRoom.id) {
          messages.insert(0, newMessage);
          SocketService().markRead(chatRoom.id);
        }
      }
    });
    // Listen for typing indicators
    SocketService().socket?.on('typing', (data) {
      if (data != null && data['user_id'] != myUserId) {
        isOtherTyping.value = true;
      }
    });

    SocketService().socket?.on("stop_typing", (data) {
      if (data != null && data['user_id'] != myUserId) {
        isOtherTyping.value = false;
      }
    });
  }

  void _setupTypingListener() {
    textController.addListener(() {
      if (textController.text.isNotEmpty) {
        SocketService().typing(chatRoom.id);
        AppGlobal.printLog('🦀🦀 typing started');

        _typingTimer?.cancel();
        _typingTimer = Timer(const Duration(seconds: 2), () {
          SocketService().stopTyping(chatRoom.id);
          AppGlobal.printLog('🦀🦀 typing stopped');
        });
      }
    });
  }

  Future<void> sendMessage() async {
    final text = textController.text.trim();
    if (text.isEmpty) return;

    // Capture text and clear input immediately for snappy UX
    textController.clear();

    // Optimistic UI update
    final tempMessageId = DateTime.now().millisecondsSinceEpoch.toString();
    final optimisticMessage = Message(
      id: tempMessageId,
      chatId: chatRoom.id,
      content: text,
      messageType: 'text',
      sender: null, // Representing local sender implicitly if needed
    );

    messages.insert(0, optimisticMessage);

    try {
      isSending.value = true;
      final response = await _repository.sendMessage(chatRoom.id, text, 'text');

      if (response.success && response.data != null) {
        // Replace temp message with actual saved message from DB
        final index = messages.indexWhere((m) => m.id == tempMessageId);
        if (index != -1) {
          messages[index] = response.data!;
        } else {
          messages.insert(0, response.data!);
        }
      } else {
        // Remove temp message if failed
        messages.removeWhere((m) => m.id == tempMessageId);
        ToastBar.showToast(response.message, Get.context!, Colors.red);
      }
    } catch (e) {
      messages.removeWhere((m) => m.id == tempMessageId);
      AppGlobal.printLog("Send message error: $e");
      ToastBar.showToast('Failed to send message', Get.context!, Colors.red);
    } finally {
      isSending.value = false;
    }
  }

  @override
  void onClose() {
    _typingTimer?.cancel();
    SocketService().leaveChat(chatRoom.id);
    SocketService().socket?.off("typing");
    SocketService().socket?.off("stop_typing");
    SocketService().socket?.off("new_message");
    textController.dispose();
    super.onClose();
  }
}
