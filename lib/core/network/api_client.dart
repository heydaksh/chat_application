import 'package:chat_application/app/routes/app_routes.dart';
import 'package:chat_application/app/services/api_services/api_endpoints.dart';
import 'package:chat_application/app/services/auth_service.dart';
import 'package:chat_application/core/utils/app_global.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;

  late Dio _dio;

  ApiClient._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiEndpoints.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'X-Tunnel-Skip-Anti-Phishing-Page': 'true',
        },
      ),
    );

    _dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        logPrint: (object) => AppGlobal.printLog(object.toString()),
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          if (AuthService.to.isLoggedIn) {
            options.headers['Authorization'] = 'Bearer ${AuthService.to.token}';
          }
          return handler.next(options);
        },
        onError: (DioException e, handler) {
          if (e.response?.statusCode == 401) {
            AppGlobal.printLog(
              "[API CLIENT] Unauthorized - Redirecting to login",
            );
            AuthService.to.clearAuth();
            Get.offAllNamed(Routes.login);
          }
          return handler.next(e);
        },
      ),
    );
  }

  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  Future<Response> delete(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.delete(
        path,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  Future<Response> patch(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.patch(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }
}

class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException({required this.message, this.statusCode});
  factory ApiException.fromDioError(DioException error) {
    String message = "Something went wrong";
    int? statusCode = error.response?.statusCode;

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        message = "Connection timed out";
        break;
      case DioExceptionType.badResponse:
        final responseData = error.response?.data;
        if (responseData is Map<String, dynamic>) {
          message = responseData['message'] ?? "Server error";
        } else {
          message =
              "Server error ${statusCode ?? ''}: Route not found or invalid response format";
        }
        break;
      case DioExceptionType.cancel:
        message = "Request cancelled";
        break;
      case DioExceptionType.connectionError:
        message = "No internet connection";
        break;
      default:
        message = "Unexpected error occurred";
    }

    return ApiException(message: message, statusCode: statusCode);
  }

  @override
  String toString() => message;
}
