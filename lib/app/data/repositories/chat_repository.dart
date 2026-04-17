import 'package:chat_application/app/data/models/auth_models.dart';
import 'package:chat_application/app/data/models/chat_models.dart';
import 'package:chat_application/app/services/api_services/api_endpoints.dart';
import 'package:chat_application/core/network/api_client.dart';

class ChatRepository {
  final ApiClient _apiClient = ApiClient();

  // POST /api/chat/create-room
  Future<ApiResponse<ChatRoom>> createChatRoom(String participantId) async {
    final response = await _apiClient.post(
      ApiEndpoints.createChatRoom,
      data: {'participantId': participantId},
    );
    return ApiResponse<ChatRoom>.fromJson(
      response.data,
      (json) => ChatRoom.fromJson(json),
    );
  }

  // GET /api/chat/rooms
  Future<ApiResponse<List<ChatRoom>>> getChatRooms() async {
    final response = await _apiClient.get(ApiEndpoints.getChatRooms);
    return ApiResponse<List<ChatRoom>>.fromJson(response.data, (json) {
      final chatRoomsList = json['chatRooms'] as List? ?? [];
      return chatRoomsList.map((e) => ChatRoom.fromJson(e)).toList();
    });
  }

  // GET /api/message/list/id{}
  Future<ApiResponse<PageinatedMessage>> getMessages(
    String chatId, {
    int page = 1,
    int limit = 40,
  }) async {
    final response = await _apiClient.get(
      '${ApiEndpoints.getMessageList}/$chatId',
      queryParameters: {"page": page, "limit": limit},
    );
    return ApiResponse<PageinatedMessage>.fromJson(response.data, (json) {
      return PageinatedMessage.fromJson(json);
    });
  }

  // POST /api/message/send-message
  Future<ApiResponse<Message>> sendMessage(
    String chatId,
    String content,
    String messageType,
  ) async {
    final response = await _apiClient.post(
      ApiEndpoints.sendMessage,
      data: {"chatId": chatId, "content": content, "messageType": messageType},
    );
    return ApiResponse<Message>.fromJson(
      response.data,
      (json) => Message.fromJson(json),
    );
  }
}
