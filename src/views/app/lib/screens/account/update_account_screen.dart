import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import './../../services/modules/user_service.dart';

class UpdateAccountScreen extends StatefulWidget {
  final Map<String, dynamic>? userData;

  const UpdateAccountScreen({Key? key, required this.userData}) : super(key: key);

  @override
  State<UpdateAccountScreen> createState() => _UpdateAccountScreenState();
}

class _UpdateAccountScreenState extends State<UpdateAccountScreen> {
  late TextEditingController nameController;
  late TextEditingController usernameController;
  late TextEditingController emailController;
  String? gender;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.userData?['name']);
    usernameController = TextEditingController(text: widget.userData?['username']);
    emailController = TextEditingController(text: widget.userData?['email']);
    gender = widget.userData?['gender'];
  }

  Future<void> _saveUpdates() async {
    if (_formKey.currentState?.validate() ?? false) {
      final userService = UserService();
      final userData = {
        'name': nameController.text.trim(),
        'username': usernameController.text.trim(),
        'email': emailController.text.trim(),
        'gender': gender,
      };

      final response = await userService.update(widget.userData?['id'], userData);

      if (response.containsKey('error')) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Cập nhật thất bại: ${response['error']}')),
        );
      } else {
        final prefs = await SharedPreferences.getInstance();
        final updatedUserData = {
          ...widget.userData!,
          ...userData,
        };
        await prefs.setString('userData', jsonEncode(updatedUserData));

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cập nhật thành công!')),
        );
        Navigator.pop(context, true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cập nhật tài khoản'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Name input
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Tên',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập tên.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Username input
              TextFormField(
                controller: usernameController,
                decoration: const InputDecoration(
                  labelText: 'Tên đăng nhập',
                  prefixIcon: Icon(Icons.account_circle),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập tên đăng nhập.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Email input
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập email.';
                  } else if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
                      .hasMatch(value)) {
                    return 'Vui lòng nhập địa chỉ email hợp lệ.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Gender dropdown
              DropdownButtonFormField<String>(
                value: gender,
                items: const [
                  DropdownMenuItem(value: 'Nam', child: Text('Nam')),
                  DropdownMenuItem(value: 'Nữ', child: Text('Nữ')),
                  DropdownMenuItem(value: 'Khác', child: Text('Khác')),
                ],
                onChanged: (value) {
                  setState(() {
                    gender = value;
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'Giới tính',
                  prefixIcon: Icon(Icons.wc),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null) {
                    return 'Vui lòng chọn giới tính.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Save button
              Center(
                child: ElevatedButton(
                  onPressed: _saveUpdates,
                  child: const Text('Lưu thay đổi'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
