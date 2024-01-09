import 'package:flutter/material.dart';
import 'package:flutter_application_1/models.dart';

class YourMainContent extends StatelessWidget {
  final List<MenuItem>? menuList;

  const YourMainContent({Key? key, this.menuList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: menuList?.length ?? 0,
        itemBuilder: (BuildContext context, int index) {
          var menu = menuList![index];

          return ListTile(
            title: Text(menu.subRoleName),
            onTap: () {
              print('Tapped on: ${menu.subRoleName}');
            },
          );
        },
      ),
    );
  }
}
