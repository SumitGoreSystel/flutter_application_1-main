import 'package:flutter/material.dart';
import 'package:flutter_application_1/models.dart';
import 'package:flutter_svg/svg.dart';
import 'app_service.dart';
import 'app_drawer.dart';
import 'FlightDeck/main_body.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Layout extends StatefulWidget {
  @override
  _LayoutState createState() => _LayoutState();
}

class _LayoutState extends State<Layout> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ApiService apiService = ApiService();
  UserResponse? validateTokenResponse; // Class variable to store the token response

  @override
  void initState() {
    super.initState();
    validateTokenAndNavigate();
  }

  Future<void> validateTokenAndNavigate() async {
    try {
      final response = await apiService.validateToken();

      if (response != null) {
        print('Token validation successful');
        setState(() {
          validateTokenResponse = response;
        });
        
      } else {
        print('Token validation failed');
        Navigator.pushReplacementNamed(context, '/login');
      }
    } catch (error) {
      print('Error: $error');
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  // Future<void> getMenu(String userId) async {
  //   try {
  //     final response = await apiService.get

  //     if (response != null) {
  //       print('Token validation successful');
  //       setState(() {
  //         validateTokenResponse = response;
  //       });
        
  //     } else {
  //       print('Token validation failed');
  //       Navigator.pushReplacementNamed(context, '/login');
  //     }
  //   } catch (error) {
  //     print('Error: $error');
  //     Navigator.pushReplacementNamed(context, '/login');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            _scaffoldKey.currentState!.openDrawer();
          },
        ),
        title: Row(
          children: [
            Image.asset(
              'assets/images/Logo.png',
              height: 45.0,
            ),
            const SizedBox(width: 8.0),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Handle search
            },
          ),
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // Handle notifications
            },
          ),
          IconButton(
            icon: const Icon(Icons.mail),
            onPressed: () {
              // Handle messages
            },
          ),
          _buildUserDropdown(),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                  color: Colors.white,
                  ),
              child: Image(image: AssetImage('assets/images/Logo.png')),
            ),
            ListTile(
              title: const Text('Menu Item 1'),
              onTap: () {
                // Handle menu item 1 click
                Navigator.pop(context); // Close the drawer
              },
            ),
            ListTile(
              title: const Text('Menu Item 2'),
              onTap: () {
                // Handle menu item 2 click
                Navigator.pop(context); // Close the drawer
              },
            ),
            // Add more ListTile items as needed
          ],
        ),
      ),
      body: YourMainContent(),
    );
  }

  Widget _buildUserDropdown() {
    return PopupMenuButton(
      icon: const Icon(Icons.person),
      itemBuilder: (BuildContext context) {
        return [
          PopupMenuItem(
            child: ListTile(
              leading: const Icon(Icons.account_circle),
              title: Text(
                  'Username: ${validateTokenResponse?.userName ?? "John Doe"}'),
            ),
          ),
          PopupMenuItem(
            child: ListTile(
              leading: const Icon(Icons.work),
              title: Text(
                  'Designation: ${validateTokenResponse?.designation ?? "Software Engineer"}'),
            ),
          ),
          PopupMenuItem(
            child: ListTile(
              leading: const Icon(Icons.email),
              title: Text(
                  'Email: ${validateTokenResponse?.emailId ?? "john.doe@example.com"}'),
            ),
          ),
          PopupMenuItem(
            child: ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: const Text('Logout'),
              onTap: () {
                showLogoutConfirmationDialog(context);
              },
            ),
          ),
        ];
      },
    );
  }

  void showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout Confirmation'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/login');
              },
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }
}
