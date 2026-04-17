import 'package:chat_application/app/data/models/auth_models.dart';
import 'package:chat_application/app/services/api_services/api_endpoints.dart';
import 'package:chat_application/core/network/api_client.dart';

class AuthRepository {
  final ApiClient _apiClient = ApiClient();

  //  LOGIN -------------
  Future<ApiResponse<AuthResponse>> login({
    required String email,
    required String password,
  }) async {
    final response = await _apiClient.post(
      ApiEndpoints.login,
      data: {'email': email, 'password': password, "deviceId": "1234567890"},
    );
    return ApiResponse<AuthResponse>.fromJson(
      response.data,
      (json) => AuthResponse.fromJson(json),
    );
  }

  // REGISTER -------------
  Future<ApiResponse<dynamic>> register({
    required String username,
    required String email,
    required String mobile,
    required String password,
  }) async {
    final response = await _apiClient.post(
      ApiEndpoints.register,
      data: {
        'username': username,
        'email': email,
        'mobile': mobile,
        'password': password,
      },
    );
    return ApiResponse<dynamic>.fromJson(response.data, (json) => json);
  }

  // DELETE ACCOUNT ----------
  Future<ApiResponse<dynamic>> deleteAccount({
    required String accountId,
  }) async {
    final response = await _apiClient.delete(
      '${ApiEndpoints.deleteAccount}/$accountId',
    );
    return ApiResponse<dynamic>.fromJson(response.data, (json) => json);
  }

  // VERIFY OTP ----------
  Future<ApiResponse<AuthResponse>> verifyOtp({
    required String email,
    required String otp,
  }) async {
    final response = await _apiClient.post(
      ApiEndpoints.verifyOtp,
      data: {'email': email, 'otp': otp},
    );
    return ApiResponse<AuthResponse>.fromJson(
      response.data,
      (json) => AuthResponse.fromJson(json),
    );
  }

  // RESEND OTP ----------
  Future<ApiResponse<dynamic>> resendOtp({required String email}) async {
    final response = await _apiClient.post(
      ApiEndpoints.resendOtp,
      data: {'email': email},
    );
    return ApiResponse<dynamic>.fromJson(response.data, (json) => json);
  }

  // CHANGE PASSWORD (LOGGED-IN)----------
  Future<ApiResponse<dynamic>> changePassword({
    required String oldPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    final response = await _apiClient.post(
      ApiEndpoints.changePassword,
      data: {
        'oldPassword': oldPassword,
        'newPassword': newPassword,
        'confirmPassword': confirmPassword,
      },
      // options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    return ApiResponse<dynamic>.fromJson(response.data, (json) => json);
  }

  // FORGET PASSWORD (NOT LOGGED-IN) ----------
  Future<ApiResponse<dynamic>> forgetPassword({required String email}) async {
    final response = await _apiClient.post(
      ApiEndpoints.forgetPassOnLogin,
      data: {'email': email},
    );
    return ApiResponse<dynamic>.fromJson(response.data, (json) => json);
  }

  // RESET PASSWORD (NOT LOGGED-IN) --------
  Future<ApiResponse<dynamic>> resetPassword({
    required String email,
    required String newPassword,
    required String confirmPassword,
  }) async {
    final response = await _apiClient.post(
      ApiEndpoints.resetPassUsingOtp,
      data: {
        'email': email,
        'newPassword': newPassword,
        'confirmPassword': confirmPassword,
      },
    );
    return ApiResponse<dynamic>.fromJson(response.data, (json) => json);
  }
}
