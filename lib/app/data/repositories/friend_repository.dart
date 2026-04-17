import 'package:chat_application/app/data/models/auth_models.dart';
import 'package:chat_application/app/data/models/friends_models.dart';
import 'package:chat_application/app/services/api_services/api_endpoints.dart';
import 'package:chat_application/core/network/api_client.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FriendRepository {
  final ApiClient _apiClient = ApiClient();

  Future<Options> _getAuthOptions() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token') ?? '';
    return Options(headers: {'Authorization': 'Bearer $token'});
  }

  // GET /api/friend/requests

  Future<ApiResponse<List<FriendRequest>>> getRequests() async {
    final options = await _getAuthOptions();
    final response = await _apiClient.get(
      ApiEndpoints.friendRequest,
      options: options,
    );

    return ApiResponse<List<FriendRequest>>.fromJson(
      response.data,
      (json) => (json as List).map((e) => FriendRequest.fromJson(e)).toList(),
    );
  }

  // POST /api/friend/request-action/:id
  Future<ApiResponse<dynamic>> actionRequest(
    String requestId,
    String action,
  ) async {
    final options = await _getAuthOptions();
    final response = await _apiClient.post(
      '${ApiEndpoints.friendAction}/$requestId',
      data: {'action': action},
      options: options,
    );
    return ApiResponse<dynamic>.fromJson(response.data, (json) => json);
  }

  // GET /api/friend/suggestions
  Future<ApiResponse<SuggestionResponse>> getSuggestions() async {
    final options = await _getAuthOptions();
    final response = await _apiClient.get(
      ApiEndpoints.friendSuggestion,
      options: options,
    );

    return ApiResponse<SuggestionResponse>.fromJson(
      response.data,
      (json) => SuggestionResponse.fromJson(json),
    );
  }

  // POST /api/friend/send-request
  Future<ApiResponse<dynamic>> sendRequest(String receiverId) async {
    final options = await _getAuthOptions();
    final response = await _apiClient.post(
      ApiEndpoints.sendFriendRequest,
      data: {'receiverId': receiverId},
      options: options,
    );
    return ApiResponse<dynamic>.fromJson(response.data, (json) => json);
  }

  // GET /api/friend/
  Future<ApiResponse<FriendListResponse>> getFriends() async {
    final options = await _getAuthOptions();
    final response = await _apiClient.get('/api/friend/', options: options);

    return ApiResponse<FriendListResponse>.fromJson(response.data, (json) {
      if (json is List) {
        return FriendListResponse(
          friends: json.map((e) => FriendUser.fromJson(e)).toList(),
        );
      }
      return FriendListResponse.fromJson(json as Map<String, dynamic>);
    });
  }

  // DELETE /api/unfriend/{id}
  Future<ApiResponse<dynamic>> removeFriend(String friendshipId) async {
    final options = await _getAuthOptions();
    final response = await _apiClient.delete(
      '${ApiEndpoints.removeFriend}/$friendshipId',
      options: options,
    );
    return ApiResponse<dynamic>.fromJson(response.data, (json) => json);
  }
}
