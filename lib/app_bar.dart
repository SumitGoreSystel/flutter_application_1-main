import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'models.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  CustomAppBar({Key? key}) : super(key: key);
  final bool showLogo = true;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  static FlutterSecureStorage storage = const FlutterSecureStorage();
  UserResponse? validateTokenResponse;
  // Class variable to store the token response
  List<MenuItem>? menuList;
  @override
  Widget build(BuildContext context) {
    return 
    AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.menu),
        onPressed: () {
          Scaffold.of(context).openDrawer();
        },
      ),
      title: Row(
        children: [
          if (widget.showLogo)
            Image.asset(
              'assets/images/Logo.png',
              height: 45.0,
            ),
          if (widget.showLogo) const SizedBox(width: 8.0),
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
                //Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                storage.deleteAll();
                Navigator.of(context).pushReplacementNamed('/login');

              },
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }
}
