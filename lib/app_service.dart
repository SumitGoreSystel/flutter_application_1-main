import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'models.dart';

class ApiService {
  static const baseUrl = 'localhost:44306'; // Adjusted the base URL
  FlutterSecureStorage storage = FlutterSecureStorage();

  /// User Login Validation Method
  Future<LoginResponse> makePostRequest(String userId, String password) async {
    try {
      final response = await http.post(
        Uri.https(baseUrl, 'users/auth'), // Used Uri.https for HTTPS
        body: jsonEncode({
          'userName': userId,
          'password': password,
          'companyCode': 'string',
        }),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final userData = UserData.fromJson(json.decode(response.body));

        return LoginResponse(
          success: true,
          message: 'Request succeeded',
          statusCode: response.statusCode,
          data: userData,
        );
      } else {
        return LoginResponse(
          success: false,
          message: 'Request failed',
          statusCode: response.statusCode,
          data: UserData(
            errorMessage: response.body,
            token: '', // Adjust this based on your error handling logic
            userId: 0, // Default value for userId
            userNameInitial: '', // Default value for userNameInitial
            designation: '', // Default value for designation
            emailId: '', // Default value for emailId
            mobileNo: '', // Default value for mobileNo
            roleId: 0, // Default value for roleId
            profileImage: '', // Default value for profileImage
          ),
        );
      }
    } catch (error) {
      return LoginResponse(
        success: false,
        message: 'Error occurred',
        statusCode: 500,
        data: UserData(
          errorMessage: error.toString(),
          token: '', // Adjust this based on your error handling logic
          userId: 0, // Default value for userId
          userNameInitial: '', // Default value for userNameInitial
          designation: '', // Default value for designation
          emailId: '', // Default value for emailId
          mobileNo: '', // Default value for mobileNo
          roleId: 0, // Default value for roleId
          profileImage: '', // Default value for profileImage
        ),
      );
    }
  }

  Future<UserResponse> validateToken() async {
    try {
      final String? accessToken = await storage.read(key: 'access_token');

      final response = await http.get(
        Uri.https(baseUrl, 'users/ValidateToken'),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        return UserResponse.fromJson(responseData);
      } else {
        throw Exception('Failed to validate token: ${response.statusCode}');
      }
    } catch (error) {
      print('Error validating token: $error');
      throw Exception('Error validating token: $error');
    }
  }

  Future<MenuData> fetchMenuData() async {
    final String? accessToken = await storage.read(key: 'access_token');
    final response = await http.get(
      Uri.https(baseUrl, 'menus/GetMenuForUser'),
      headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = json.decode(response.body);
      return MenuData.fromJson(jsonData);
    } else {
      throw Exception('Failed to load menu data');
    }
  }
}
