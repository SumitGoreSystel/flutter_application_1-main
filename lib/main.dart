// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'navbar_layout.dart';
import 'page_not_found.dart';
import 'login_page.dart';

//import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/login': (context) => LoginComponent(),
        '/PageNotFound': (context) => PageNotFoundComponent(),
        '/': (context) => Layout(),
      },
      onUnknownRoute: (settings) {
        return MaterialPageRoute(builder: (context) => PageNotFoundComponent());
      },
    );
  }
}
