import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'dio_client.dart';

class ApiService {
  final Dio _dio = DioClient.getDio();

  // ✅ POST REQUEST
  Future<Response> post(
      String endpoint, {
        dynamic data,
        Map<String, dynamic>? queryParameters,
        Options? options,
        bool isMultipart = false,
        Map<String, String>? headers,
      }) async {
    try {
      // ✅ Prepare final data based on type
      dynamic finalData = data;

      if (isMultipart && data is FormData) {
        // For multipart requests, ensure proper content type
        final optionsWithMultipart = (options ?? Options()).copyWith(
          contentType: 'multipart/form-data',
          headers: {
            ...(options?.headers ?? {}),
            ...(headers ?? {}),
            'Accept': 'application/json',
          },
        );

        finalData = data;
        options = optionsWithMultipart;
      } else if (data is Map<String, dynamic>) {
        // For regular JSON requests
        final optionsWithJson = (options ?? Options()).copyWith(
          contentType: 'application/json',
          headers: {
            ...(options?.headers ?? {}),
            ...(headers ?? {}),
            'Accept': 'application/json',
          },
        );

        options = optionsWithJson;
      }

      // ✅ Make the request
      final response = await _dio.post(
        endpoint,
        data: finalData,
        queryParameters: queryParameters,
        options: options,
      );

      return response;

    } on DioException catch (e) {
      // ✅ FULL DEBUG LOG
      print("❌ API POST ERROR");
      print("❌ URL => ${e.requestOptions.uri}");
      print("❌ METHOD => ${e.requestOptions.method}");
      print("❌ STATUS => ${e.response?.statusCode}");
      print("❌ ERROR TYPE => ${e.type}");
      print("❌ ERROR MESSAGE => ${e.message}");

      // Log request data (carefully, as it might contain FormData)
      if (e.requestOptions.data is FormData) {
        print("❌ REQUEST TYPE => Multipart/FormData");
        final formData = e.requestOptions.data as FormData;
        print("❌ FORM FIELDS => ${formData.fields.length}");
        print("❌ FORM FILES => ${formData.files.length}");
      } else {
        print("❌ REQUEST DATA => ${e.requestOptions.data}");
      }

      // ✅ THROW CLEAN MESSAGE TO UI
      if (e.response?.data != null) {
        final errorData = e.response!.data;

        if (errorData is Map<String, dynamic>) {
          // Handle structured error response
          final message = errorData["message"] ??
              errorData["error"] ??
              errorData["errors"]?.toString() ??
              e.response?.statusMessage ??
              "Something went wrong. Please try again.";

          throw message.toString();
        } else if (errorData is String) {
          throw errorData;
        }
      }

      // Handle different Dio error types
      String errorMessage = _getDioErrorMessage(e);
      throw errorMessage;

    } catch (e) {
      print("❌ UNKNOWN ERROR => $e");
      print("❌ STACK TRACE => ${StackTrace.current}");
      throw "Unexpected error occurred. Please try again.";
    }
  }

  // ✅ Helper method to create FormData for multipart requests
  FormData createFormData({
    required Map<String, dynamic> fields,
    Map<String, MultipartFile>? files,
    List<MapEntry<String, MultipartFile>>? fileList,
  }) {
    final formData = FormData();

    // Add fields
    fields.forEach((key, value) {
      if (value != null) {
        formData.fields.add(MapEntry(key, value.toString()));
      }
    });

    // Add files from map
    if (files != null) {
      files.forEach((key, file) {
        formData.files.add(MapEntry(key, file));
      });
    }

    // Add files from list
    if (fileList != null) {
      formData.files.addAll(fileList);
    }

    return formData;
  }

  // ✅ Helper method to create MultipartFile from File
  Future<MultipartFile> createMultipartFile({
    required File file,
    String fieldName = 'file',
    String? filename,
  }) async {
    final fileName = filename ?? 'file_${DateTime.now().millisecondsSinceEpoch}.jpg';

    return await MultipartFile.fromFile(
      file.path,
      filename: fileName,
    );
  }

  // ✅ Helper to create MultipartFile from bytes
  MultipartFile createMultipartFileFromBytes({
    required List<int> bytes,
    required String filename,
    String fieldName = 'file',
  }) {
    return MultipartFile.fromBytes(
      bytes,
      filename: filename,
    );
  }

  // ✅ Helper to extract Dio error messages
  String _getDioErrorMessage(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return "Connection timeout. Please check your internet.";
      case DioExceptionType.sendTimeout:
        return "Request timeout. Please try again.";
      case DioExceptionType.receiveTimeout:
        return "Response timeout. Please try again.";
      case DioExceptionType.badResponse:
        return "Server error (${e.response?.statusCode}). Please try again.";
      case DioExceptionType.cancel:
        return "Request cancelled.";
      case DioExceptionType.unknown:
        if (e.error is SocketException) {
          return "No internet connection. Please check your network.";
        }
        return "Network error. Please check your connection.";
      case DioExceptionType.badCertificate:
        return "Certificate error. Please try again later.";
      case DioExceptionType.connectionError:
        return "Connection error. Please check your internet.";
    }
  }
  // ✅ GET REQUEST
  Future<Response> get(String endpoint) async {
    try {
      final response = await _dio.get(endpoint);
      return response;

    } on DioException catch (e) {
      print("❌ API GET ERROR");
      print("❌ URL => ${e.requestOptions.uri}");
      print("❌ STATUS => ${e.response?.statusCode}");
      print("❌ DATA => ${e.response?.data}");

      throw e.response?.data?["message"] ??
          "Something went wrong. Please try again.";
    } catch (e) {
      print("❌ UNKNOWN ERROR => $e");
      throw "Unexpected error occurred";
    }
  }

  Future<Response> patch(
      String endpoint, {
        dynamic data, // Changed from Map<String, dynamic>? to dynamic
        Map<String, dynamic>? queryParameters,
        Options? options,
      }) async {
    try {
      // Check if data is FormData and set appropriate headers
      Options requestOptions = options ?? Options();

      if (data is FormData) {
        // For FormData, let Dio set the Content-Type automatically
        requestOptions = requestOptions.copyWith(
          contentType: 'multipart/form-data',
        );
      }

      final response = await _dio.patch(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: requestOptions,
      );
      return response;

    } on DioException catch (e) {
      print("❌ API PATCH ERROR");
      print("❌ URL => ${e.requestOptions.uri}");
      print("❌ STATUS => ${e.response?.statusCode}");
      print("❌ DATA => ${e.response?.data}");

      // Handle different error types
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        throw "Connection timeout. Please try again.";
      }

      if (e.type == DioExceptionType.connectionError) {
        throw "No internet connection";
      }

      throw e.response?.data?["message"] ??
          "Something went wrong. Please try again.";
    } catch (e) {
      print("❌ UNKNOWN ERROR => $e");
      throw "Unexpected error occurred";
    }
  }

  Future<Response> put(
      String endpoint, {
        dynamic data,
        Map<String, dynamic>? queryParameters,
        Options? options,
        bool isMultipart = false,
        Map<String, String>? headers,
      }) async {
    try {
      dynamic finalData = data;

      if (isMultipart && data is FormData) {
        final optionsWithMultipart = (options ?? Options()).copyWith(
          contentType: 'multipart/form-data',
          headers: {
            ...(options?.headers ?? {}),
            ...(headers ?? {}),
            'Accept': 'application/json',
          },
        );

        finalData = data;
        options = optionsWithMultipart;
      } else if (data is Map<String, dynamic>) {
        final optionsWithJson = (options ?? Options()).copyWith(
          contentType: 'application/json',
          headers: {
            ...(options?.headers ?? {}),
            ...(headers ?? {}),
            'Accept': 'application/json',
          },
        );

        options = optionsWithJson;
      }

      final response = await _dio.put(
        endpoint,
        data: finalData,
        queryParameters: queryParameters,
        options: options,
      );

      return response;
    } on DioException catch (e) {
      print("❌ API PUT ERROR");
      print("❌ URL => ${e.requestOptions.uri}");
      print("❌ METHOD => ${e.requestOptions.method}");
      print("❌ STATUS => ${e.response?.statusCode}");
      print("❌ ERROR TYPE => ${e.type}");
      print("❌ ERROR MESSAGE => ${e.message}");

      if (e.requestOptions.data is FormData) {
        print("❌ REQUEST TYPE => Multipart/FormData");
        final formData = e.requestOptions.data as FormData;
        print("❌ FORM FIELDS => ${formData.fields.length}");
        print("❌ FORM FILES => ${formData.files.length}");
      } else {
        print("❌ REQUEST DATA => ${e.requestOptions.data}");
      }

      if (e.response?.data != null) {
        final errorData = e.response!.data;

        if (errorData is Map<String, dynamic>) {
          final message = errorData["message"] ??
              errorData["error"] ??
              errorData["errors"]?.toString() ??
              e.response?.statusMessage ??
              "Something went wrong. Please try again.";

          throw message.toString();
        } else if (errorData is String) {
          throw errorData;
        }
      }

      String errorMessage = _getDioErrorMessage(e);
      throw errorMessage;
    } catch (e) {
      print("❌ UNKNOWN ERROR => $e");
      throw "Unexpected error occurred. Please try again.";
    }
  }

  Future<Response> delete(
      String endpoint, {
        Map<String, dynamic>? queryParameters,
        Options? options,
        Map<String, String>? headers,
      }) async {
    try {
      final response = await _dio.delete(
        endpoint,
        queryParameters: queryParameters,
        options: options,
      );

      return response;
    } on DioException catch (e) {
      print("❌ API DELETE ERROR => ${e.message}");
      throw _getDioErrorMessage(e);
    }
  }
}
