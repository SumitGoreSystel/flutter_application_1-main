// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_application_1/FlightDeck/User/user_component.dart';
import 'navbar_layout.dart';
import 'page_not_found.dart';
import 'login_page.dart';
import 'NetworkService/network_service.dart';
import 'package:go_router/go_router.dart';

//import 'package:google_fonts/google_fonts.dart';

void main() {
  NetworkService.setupInterceptors();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flight Deck',
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
      // initialRoute: '/',
      // routes: {
      //   '/login': (context) => const LoginComponent(),
      //   '/PageNotFound': (context) => const PageNotFoundComponent(),
      //   '/': (context) => const Layout(),
      // },
      // onUnknownRoute: (settings) {
      //   return MaterialPageRoute(builder: (context) => const PageNotFoundComponent());
      // },
    );
  }

  final _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => Layout(),
      routes: [
        GoRoute(path: 'WDB',builder: (context, state) => User())
      ]
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => LoginComponent(),
    ),
    
  ],
);
}

