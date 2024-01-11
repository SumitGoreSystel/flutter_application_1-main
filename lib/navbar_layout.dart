// ignore_for_file: use_build_context_synchronously, duplicate_ignore, library_private_types_in_public_api

import 'dart:async';
import 'dart:html';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/navigation.dart';
import 'package:flutter_application_1/page_not_found.dart';
import 'app_bar.dart';
import 'package:flutter_application_1/models.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'FlightDeck/User/user_component.dart';
import 'app_service.dart';
import 'FlightDeck/main_body.dart';
import 'package:flutter/foundation.dart'
    show kIsWeb; // Import for checking if the app is running on the web

class Layout extends StatefulWidget {
  const Layout({super.key});

  @override
  _LayoutState createState() => _LayoutState();
}

class _LayoutState extends State<Layout> {
  static FlutterSecureStorage storage = const FlutterSecureStorage();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  int _currentIndex = 0; // Index to track the currently displayed page
  final ApiService apiService = ApiService();
  UserResponse?
      validateTokenResponse; // Class variable to store the token response
  List<MenuItem>? menuList; // Class variable to store the token response

  @override
  void initState() {
    super.initState();
    validateTokenAndNavigate();
  }

  List<MenuItem> mapMenuItems(List<MenuItem> userMenuItems) {
    List<MenuItem> parentMenuList = [];

    // Filter parent items
    List<MenuItem> parentItems =
        userMenuItems.where((item) => item.isParent == 1).toList();

    // Map childMenuList for each parent item
    parentMenuList = parentItems.map((parentItem) {
      parentItem.child = userMenuItems
          .where((childItem) => childItem.parentMenuId == parentItem.menuId)
          .toList();
      return parentItem;
    }).toList();

    return parentMenuList;
  }

  Future<void> validateTokenAndNavigate() async {
    BuildContext currentContext = context; // Store the context

    try {
      final response = await apiService.validateToken();

      if (response != null) {
        setState(() {
          validateTokenResponse = response;
        });
        getMenu(response.userId);
      } else {
        // ignore: use_build_context_synchronously
        Navigator.of(currentContext).pushReplacementNamed('/login');
      }
    } catch (error) {
      print('Error during token validation: $error');
      ScaffoldMessenger.of(currentContext).showSnackBar(const SnackBar(
        content: Text('Error during token validation. Please try again.'),
      ));
      Navigator.of(currentContext).pushReplacementNamed('/login');
    }
  }

  getMenu(int userId) {
    apiService.fetchMenuData(userId).then((value) => {
          setState(() {
            menuList = mapMenuItems(value.items);
          })
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomAppBar(),
      drawer: Drawer(
        child: Column(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: Image(image: AssetImage('assets/images/Logo.png')),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: menuList?.length ?? 0,
                itemBuilder: (BuildContext context, int index) {
                  var menu = menuList![index];

                  return ExpansionTile(
                    title: Text(menu.subRoleName),
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: menu.child!.length,
                        itemBuilder: (BuildContext context, int childIndex) {
                          var childMenu = menu.child![childIndex];
                          return ListTile(
                            title: Text(childMenu.subRoleName),
                            onTap: () {
                              print(childMenu.subRoleCode);
                              Navigation.mainNavigation.currentState!
                                  .pushReplacementNamed(
                                      "/${childMenu.subRoleCode}");
                              Navigator.of(context).pop();
                            },
                          );
                        },
                      ),
                    ],
                  );
                },
              ),
            )
            // Add more ListTile items as needed
          ],
        ),
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
                child: Navigator(
              key: Navigation.mainNavigation,
              initialRoute: "/",
              onGenerateRoute: (RouteSettings settings) {
                Widget page;

                switch (settings.name) {
                  case "/USRL":
                    {
                      page = User();
                      break;
                    }
                  // case "/main/2": {
                  //   page = Page2();
                  //   break;
                  // }
                  // case "/main/3": {
                  //   page = Page3();
                  //   break;
                  // }
                  // case "/main/4": {
                  //   page = Page4();
                  //   break;
                  // }
                  default:
                    {
                      page = PageNotFoundComponent();
                    }
                }
                final uri = Uri.parse(settings.name!);
                window.history.pushState(null, '', uri.path);

                return PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) => page,
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    const begin = Offset(1.0, 0.0);
                    const end = Offset.zero;
                    final tween = Tween(begin: begin, end: end);
                    final offsetAnimation = animation.drive(tween);
                    return SlideTransition(
                      position: offsetAnimation,
                      child: child,
                    );
                  },
                );
              },
            )),
          ],
        ),
      ),
      // Navigator(
      //   key: _navigatorKey,
      //   onGenerateRoute: (settings) {
      //     if (settings.name == '/') {
      //       return MaterialPageRoute(
      //         builder: (context) => YourMainContent(menuList: menuList),
      //       );
      //     } else {

      //     }
      //     return null;
      //   },
      // ),
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
