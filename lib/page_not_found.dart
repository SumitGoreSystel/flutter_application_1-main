import 'package:flutter/material.dart';

class PageNotFoundComponent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Page Not Found'),
      ),
      body: Center(child:Text('Page not Found') )// Your Page Not Found UI goes here
    );
  }
}