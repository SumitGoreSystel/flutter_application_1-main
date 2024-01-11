// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'NetworkService/network_service.dart';
import 'app_service.dart';

class LoginComponent extends StatelessWidget {
  const LoginComponent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/login_bg.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Flight-Deck',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 40.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        const Text(
                          'Systel is committed to providing total customer satisfaction through continual improvement, the pursuit of zero defects, on-time delivery, and customer service.',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.0,
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        SvgPicture.asset(
                          'assets/images/logo_white.svg',
                          height: 60.0,
                        ),
                        const SizedBox(height: 20.0),
                        Image.asset(
                          'assets/images/login_stages.png',
                          height: 200.0,
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: 400.0,
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        'assets/images/logo_white.svg',
                        height: 60.0,
                      ),
                      const SizedBox(height: 20.0),
                      const Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      LoginForm(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class LoginForm extends StatelessWidget {
  final TextEditingController _userIdController;
  final TextEditingController _passwordController;
  final FlutterSecureStorage storage;
  final ApiService apiService;

  LoginForm({Key? key})
      : _userIdController = TextEditingController(),
        _passwordController = TextEditingController(),
        storage = const FlutterSecureStorage(),
        apiService = ApiService(),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
      // Add your form key and validation logic as needed
      child: Column(
        children: [
          TextFormField(
            controller: _userIdController,
            decoration: InputDecoration(
              labelText: 'UserID',
              filled: true,
              fillColor: Colors.white,
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
            ),
          ),
          const SizedBox(height: 12.0),
          TextFormField(
            controller: _passwordController,
            obscureText: true,
            decoration: InputDecoration(
              labelText: 'Password',
              filled: true,
              fillColor: Colors.white,
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
            ),
          ),
          const SizedBox(height: 20.0),
          ElevatedButton(
            onPressed: () async {
              final userId = _userIdController.text;
              final password = _passwordController.text;

              try {
                // Make the login API request
                final loginResponse =
                    await apiService.login(userId, password);

                if (loginResponse.data.token.isNotEmpty) {
                  // Store the access token
                  await storage.write(
                      key: 'access_token', value: loginResponse.data.token);
                  await NetworkService.setupInterceptors();

                  final response = await apiService.validateToken();

                  if (response.token.isNotEmpty) {
                    Navigator.of(context).pushReplacementNamed('/');

                    print('Token validation successful');
                  } else {
                    print('Token validation failed');
                  }

                  // Validate the token with another API request
                } else {
                  // Handle the case when the login response does not contain a token
                  print(
                      'Login failed: ${loginResponse.data.designation}');
                }
              } catch (error) {
                // Handle errors that might occur during API requests
                print('Login error: $error');
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: HexColor("#F24800"),
              // Background color
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
            ),
            child: Container(
              width: double.infinity, // Match the width of the input fields
              padding: const EdgeInsets.symmetric(
                  vertical: 12.0), // Adjust the height here
              child: const Center(
                child: Text(
                  'Login',
                  style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // Set text color to white
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 4.0),
          Divider(
            color: Colors.grey[800],
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // Add your Microsoft login logic here
                Navigator.of(context).pushReplacementNamed('/');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0072C6), // Background color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: const Center(
                  child: Text(
                    'Login With Microsoft',
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
