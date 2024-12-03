import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_screen/screens/account/update_account_screen.dart';
import './../auth/login_screen.dart';
import '../../services/modules/user_service.dart';

class AccountScreen extends StatefulWidget {
  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  Map<String, dynamic>? userData;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString('userData');
    if (userJson != null) {
      setState(() {
        userData = Map<String, dynamic>.from(jsonDecode(userJson));
      });
    }
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userData');
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  void _updateAccount() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => UpdateAccountScreen(userData: userData)),
    ).then((value) {
      if (value != null && value) {
        _loadUserData();
      }
    });
  }

  void _confirmDeleteAccount() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận xóa tài khoản'),
        content: const Text('Bạn có chắc chắn muốn xóa tài khoản không?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteAccount();
            },
            child: const Text(
              'Xóa',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteAccount() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    final userService = UserService();
    try {
      final response = await userService.deleteUser(id: userData!['id']);
      Navigator.of(context).pop();
      if (response['status'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Xóa tài khoản thành công.')),
        );
        _logout();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Xóa tài khoản thất bại: ${response['message']}'),
          ),
        );
      }
    } catch (e) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đã xảy ra lỗi khi xóa tài khoản.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (userData == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thông tin tài khoản'),
        centerTitle: true,
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 60,
                backgroundImage: userData!['avatar'] != null
                    ? NetworkImage(userData!['avatar'])
                    : const AssetImage('lib/assets/images/img.png')
                as ImageProvider,
              ),
              const SizedBox(height: 20),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildListTile(Icons.person, 'Tên:', userData!['name']),
                  _buildListTile(Icons.account_circle, 'Tên đăng nhập:', userData!['username']),
                  _buildListTile(Icons.email, 'Email:', userData!['email']),
                  _buildListTile(Icons.phone, 'Số điện thoại:', userData!['phone']),
                  _buildListTile(Icons.transgender, 'Giới tính:', userData!['gender']),
                ],
              ),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                onPressed: _updateAccount,
                icon: const Icon(Icons.edit),
                label: const Text('Cập nhật thông tin'),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: _confirmDeleteAccount,
                icon: const Icon(Icons.delete),
                label: const Text('Xóa tài khoản'),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: _logout,
                icon: const Icon(Icons.logout),
                label: const Text('Đăng xuất'),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey,
                    foregroundColor: Colors.white
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  ListTile _buildListTile(IconData icon, String title, String? subtitle) {
    return ListTile(
      leading: Icon(icon, color: Colors.teal),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle ?? 'Chưa cập nhật', style: const TextStyle(color: Colors.grey)),
    );
  }
}
