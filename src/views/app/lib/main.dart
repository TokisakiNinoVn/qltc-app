import 'package:flutter/material.dart';
import '././widgets/MyWidget.dart';
import '././screens/login_screen.dart';

void main() {
  runApp(MaterialApp(
    theme: ThemeData(),
    home: SafeArea(
      child: Scaffold(
        body: LoginScreen(), // Sử dụng LoginScreen làm màn hình khởi đầu
      ),
    ),
    debugShowCheckedModeBanner: false,
  ));
}
