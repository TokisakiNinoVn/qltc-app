import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiMethods {
  // Phương thức POST
  static Future<Map<String, dynamic>> postRequest(
      String url,
      Map<String, dynamic> body,
      ) async {
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      // Phân tích dữ liệu từ backend
      final jsonResponse = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonResponse;
      } else {
        // Trả về thông tin lỗi từ backend nếu có
        return {
          'status': 'error',
          'message': jsonResponse['message'] ?? 'Lỗi không xác định.',
        };
      }
    } catch (e) {
      print('API Error: $e');
      return {
        'status': 'error',
        'message': 'Không thể kết nối đến server. Vui lòng thử lại sau.',
      };
    }
  }


  // Phương thức GET
  static Future<Map<String, dynamic>> getRequest(String url) async {
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print('API Error: $e');
      return {'error': e.toString()};
    }
  }

  // Phương thức PUT
  static Future<Map<String, dynamic>> putRequest(
      String url,
      Map<String, dynamic> body,
      ) async {
    try {
      final response = await http.put(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print('API Error: $e');
      return {'error': e.toString()};
    }
  }

  // Phương thức DELETE
  static Future<Map<String, dynamic>> deleteRequest(String url) async {
    try {
      final response = await http.delete(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print('API Error: $e');
      return {'error': e.toString()};
    }
  }
}
