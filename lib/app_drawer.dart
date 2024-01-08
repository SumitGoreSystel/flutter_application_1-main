import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return 
    Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              'Drawer Header',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            title: Text('Menu Item 1'),
            onTap: () {
              // Handle menu item 1 click
              Navigator.pop(context); // Close the drawer
            },
          ),
          ListTile(
            title: Text('Menu Item 2'),
            onTap: () {
              // Handle menu item 2 click
              Navigator.pop(context); // Close the drawer
            },
          ),
          // Add more ListTile items as needed
        ],
      ),
    );
  }
}