import 'package:chat_application/core/utils/app_global.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

mixin ChatPaginationMixin on GetxController {
  final ScrollController scrollController = ScrollController();

  // Pagination State
  final RxInt currentPage = 1.obs;
  final RxInt totalPages = 1.obs;
  final RxBool isLoadingMore = false.obs;
  final int limit = 40;

  @override
  void onInit() {
    super.onInit();
    _setupScrollListener();
  }

  void _setupScrollListener() {
    scrollController.addListener(() {
      // In a reversed ListView, maxScrollExtent is the "top" of the chat (oldest messages)
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent * 0.9) {
        if (!isLoadingMore.value && currentPage.value < totalPages.value) {
          AppGlobal.printLog(
            "📜 Scrolled to top, loading page ${currentPage.value + 1}",
          );
          loadMoreMessages();
        }
      }
    });
  }

  // Abstract method that the main controller will implement
  Future<void> loadMoreMessages();

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}
