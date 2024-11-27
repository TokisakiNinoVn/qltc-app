import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'home_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  // Biến để lưu trữ response từ API
  String _responseMessage = '';
  // String _responseMes = _responseMessage.message;

  void _login() async {
    String email = _emailController.text.trim();
    String username = _usernameController.text.trim();
    String password = _passwordController.text.trim();

    // var response = await _authService.login(email, username, password);
    var response = await _authService.login(username, password);

    setState(() {
      if (response.isNotEmpty && response['status'] == 'success') {
        String username = response['data']['username'];
        String message = response['message'];

        // Chuyển sang HomeScreen và truyền dữ liệu
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
                HomeScreen(username: username, message: message),
          ),
        );
      } else {
        _responseMessage = response['data']['message'];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // const Image(image: AssetImage('assets/images/img.png'),),
            // TextField(
            //   controller: _emailController,
            //   decoration: const InputDecoration(labelText: 'Email'),
            // ),
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'username'),
            ),

            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              child: const Text('Login'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RegisterScreen(),
                    ),
                  );
                },
                child: const Text('Đăng ký tài khoản')),

            Text(
              _responseMessage,
              style: const TextStyle(fontSize: 16, color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}
