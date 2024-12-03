import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart'; // Sử dụng để thêm icon
import 'package:flutter/services.dart'; // Thêm để sử dụng TextInputFormatter
import '../../services/modules/auth_service.dart';
import './login_screen.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _pinController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  String _responseMessage = '';
  String? _pinErrorMessage;

  void _register() async {
    String phone = _phoneController.text.trim();
    String pin = _pinController.text.trim();
    String password = _passwordController.text.trim();

    // Kiểm tra mã PIN có phải là số và có độ dài là 6 ký tự
    if (pin.isEmpty || int.tryParse(pin) == null || pin.length != 6) {
      setState(() {
        _pinErrorMessage = 'Mã PIN phải là số hợp lệ và có 6 chữ số.';
      });
      return;
    } else {
      setState(() {
        _pinErrorMessage = null;
      });
    }

    // Kiểm tra mật khẩu có ít nhất 8 ký tự
    if (password.isEmpty || password.length < 8) {
      setState(() {
        _responseMessage = 'Mật khẩu phải có ít nhất 8 ký tự.';
      });
      return;
    }

    Map<String, dynamic> response = await _authService.register(phone, pin, password);

    setState(() {
      if (response['status'] == 'success' && response['code'] == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Tạo tài khoản thành công!'),
            duration: Duration(seconds: 2),
          ),
        );
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => LoginScreen(),
            ),
          );
        });
      } else {
        _responseMessage =
            response['message'] ?? 'Đăng ký thất bại. Vui lòng thử lại!';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Đăng Ký'),
        centerTitle: true,
        backgroundColor: Colors.green,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              const SizedBox(height: 40),
              const CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage('lib/assets/images/img_1.png'),
              ),
              const SizedBox(height: 20),
              const Text(
                'Tạo tài khoản mới',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Vui lòng điền thông tin bên dưới',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 30),
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.phone, color: Colors.green),
                  labelText: 'Số điện thoại',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _pinController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.pin, color: Colors.green),
                  labelText: 'Nhập mã PIN',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                obscureText: true,
                keyboardType: TextInputType.number, // Chỉ cho phép nhập số
                inputFormatters: [
                  LengthLimitingTextInputFormatter(6), // Giới hạn nhập 6 ký tự
                  FilteringTextInputFormatter.digitsOnly, // Chỉ cho phép nhập số
                ],
              ),
              if (_pinErrorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    _pinErrorMessage!,
                    style: const TextStyle(fontSize: 14, color: Colors.red),
                  ),
                ),
              const SizedBox(height: 20),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.lock, color: Colors.green),
                  labelText: 'Mật khẩu',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                onPressed: _register,
                icon: const Icon(FontAwesomeIcons.userPlus),
                label: const Text('Đăng Ký'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 28),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginScreen(),
                    ),
                  );
                },
                child: const Text(
                  'Quay lại đăng nhập',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.green,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              if (_responseMessage.isNotEmpty)
                Text(
                  _responseMessage,
                  style: const TextStyle(fontSize: 16, color: Colors.red),
                  textAlign: TextAlign.center,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
