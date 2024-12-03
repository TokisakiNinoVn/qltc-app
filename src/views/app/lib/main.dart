import 'package:flutter/material.dart';
import 'screens/auth/login_screen.dart';

void main() {
  runApp(MaterialApp(
    theme: ThemeData(),
    home: SafeArea(
      child: Scaffold(
        body: LoginScreen(),
      ),
    ),
    debugShowCheckedModeBanner: false,
  ));
}
