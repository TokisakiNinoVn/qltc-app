import 'package:flutter/material.dart';
import './../screens/NewScreen.dart';
class MyWidget extends StatelessWidget {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Container(
      // Viết code ở đây
      child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => NewScreen()),
            );
          },
          child: const Text('Click để chuyển qua màn hình mới!')),
    );
  }
}