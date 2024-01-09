import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class NetworkService {
  static final Dio dio = Dio();
  static FlutterSecureStorage storage = const FlutterSecureStorage();

  static Future<void> setupInterceptors() async {
    String? accessToken = await storage.read(key: 'access_token');

    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        // Add headers to the request
        if (accessToken != null) {
          options.headers['Authorization'] = 'Bearer $accessToken';
        }
        options.headers['Content-Type'] = 'application/json';

        // Continue with the modified options
        return handler.next(options);
      },
      onResponse: (response, handler) {
        // Do something with the successful response data
        print('Response ${response.statusCode}');
        return handler.next(response);
      },
      onError: (DioError e, handler) {
        // Handle errors here
        print('Error ${e.message}');

        // Optionally, you can modify the error before passing it to the next handler
        // e.response?.data = {'customErrorMessage': 'An error occurred'};

        // Continue with the modified error
        return handler.next(e);
      },
    ));
  }

  // Other methods for making API requests can be added here
}
