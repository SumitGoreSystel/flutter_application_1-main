// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'navbar_layout.dart';
import 'login_page.dart';
import 'NetworkService/network_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';

//import 'package:google_fonts/google_fonts.dart';

void main() {
  NetworkService.setupInterceptors();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flight Deck',
      debugShowCheckedModeBanner: false,
            theme: ThemeData(
          textTheme: GoogleFonts.montserratTextTheme().apply(),
          pageTransitionsTheme: const PageTransitionsTheme(builders: {
            TargetPlatform.iOS: FadeUpwardsPageTransitionsBuilder(),
            TargetPlatform.android: FadeUpwardsPageTransitionsBuilder()
          })),
      initialRoute:"/",
      routes: {
        "/" : (context) => Layout(),
        "/login" : (context) => LoginComponent()
      },

    );
  }

}

