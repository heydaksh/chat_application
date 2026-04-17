import 'package:chat_application/app/data/models/auth_models.dart';
import 'package:chat_application/app/services/api_services/api_endpoints.dart';
import 'package:chat_application/core/network/api_client.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileRepository {
  final ApiClient _apiClient = ApiClient();

  Future<Options> _getAuthOptions() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token') ?? '';
    return Options(headers: {'Authorization': 'Bearer $token'});
  }

  // GET api/profile
  Future<ApiResponse<User>> getMyProfile() async {
    final options = await _getAuthOptions();
    final response = await _apiClient.get(
      ApiEndpoints.getProfile,
      options: options,
    );

    return ApiResponse<User>.fromJson(
      response.data,
      (json) => User.fromJson(json),
    );
  }

  // PATCH api/profile-update
  Future<ApiResponse<User>> updateMyProfile(Map<String, dynamic> data) async {
    final options = await _getAuthOptions();
    final response = await _apiClient.patch(
      ApiEndpoints.updateProfile,
      data: data,
      options: options,
    );

    return ApiResponse<User>.fromJson(
      response.data,
      (json) => User.fromJson(json),
    );
  }

  // POST api/auth/profile-photo
  Future<ApiResponse<User>> uploadProfilePic(String imagePath) async {
    final options = await _getAuthOptions();
    FormData formData = FormData.fromMap({
      "file": await MultipartFile.fromFile(imagePath),
    });
    final response = await _apiClient.post(
      ApiEndpoints.uploadProfilePic,
      data: formData,
      options: options,
    );
    return ApiResponse<User>.fromJson(
      response.data,
      (json) => User.fromJson(json),
    );
  }

  // DELETE api/auth/profile-photo
  Future<ApiResponse<User>> deleteProfilePic() async {
    final options = await _getAuthOptions();
    final response = await _apiClient.delete(
      ApiEndpoints.deleteProfilePic,
      options: options,
    );
    return ApiResponse<User>.fromJson(
      response.data,
      (json) => User.fromJson(json),
    );
  }
}
