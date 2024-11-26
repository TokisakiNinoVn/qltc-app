import 'package:flutter/material.dart';

class NewScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const Text("Màn hình mới")),
        body: const Text("Đây là màn hình mới!"),
      ),
    );
  }

}