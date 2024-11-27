import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  final String _baseUrl = 'http://192.168.110.67:5007/api/public/auth';

  Future<Map<String, dynamic>> login(String username, String password) async {
    // String email, String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          // 'email': email.trim(),
          'username': username.trim(),
          'password': password.trim(),
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body); // Trả về dữ liệu JSON từ API
      } else {
        throw Exception('Failed to log in');
      }
    } catch (e) {
      print('Login Error: $e');
      return {};
    }
  }

  Future<Map<String, dynamic>> register(
      String email, String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email.trim(),
          'username': username.trim(),
          'password': password.trim(),
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to log in');
      }
    } catch (e) {
      print('Login Error: $e');
      return {};
    }
  }
}
