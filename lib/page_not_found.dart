import 'package:flutter/material.dart';

class PageNotFoundComponent extends StatelessWidget {
  const PageNotFoundComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Page Not Found'),
      ),
      body: const Center(child:Text('Page not Found') )// Your Page Not Found UI goes here
    );
  }
}