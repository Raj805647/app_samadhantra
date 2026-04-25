import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:samadhantra/app/constant/token_storage_service.dart';
import 'package:samadhantra/app/global_routes/app_routes.dart';
import 'package:samadhantra/app/utils/app_config.dart';

class DioClient {
  static Dio getDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: AppConfig.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {"Content-Type": "application/json"},
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        // ✅ ADD TOKEN TO EVERY REQUEST
        onRequest: (options, handler) async {
          final token = await TokenService.getAccessToken();
          if (token != null) {
            options.headers["Authorization"] = "Bearer $token";
          }
          return handler.next(options);
        },

        // ✅ HANDLE TOKEN EXPIRED ERROR
        onError: (error, handler) async {
          if (error.response?.statusCode == 401) {
            final refreshToken = await TokenService.getRefreshToken();

            if (refreshToken != null) {
              try {
                final response = await Dio().post(
                  "${AppConfig.baseUrl}/auth/refresh",
                  data: {"refresh_token": refreshToken},
                );

                final newAccessToken = response.data["access_token"];

                // ✅ SAVE NEW TOKEN
                await TokenService.saveAccessToken(newAccessToken);

                // ✅ RETRY FAILED REQUEST
                final retryRequest = error.requestOptions;
                retryRequest.headers["Authorization"] =
                    "Bearer $newAccessToken";

                final retryResponse = await Dio().fetch(retryRequest);
                return handler.resolve(retryResponse);
              } catch (e) {
                // ✅ REFRESH TOKEN FAILED = LOGOUT
                await TokenService.clearAll();
                Get.offAllNamed(AppRoutes.login);
              }
            }
          }
          return handler.next(error);
        },
      ),
    );

    return dio;
  }
}
