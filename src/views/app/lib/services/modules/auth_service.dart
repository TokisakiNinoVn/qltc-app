import '../api_routes.dart';
import '../api_methods.dart';

class AuthService {
  Future<Map<String, dynamic>> login(String phone, String pin, String password) async {
    return await ApiMethods.postRequest(ApiRoutes.login, {
      'phone': phone.trim(),
      'pin': pin.trim(),
      'password': password.trim(),
    });
  }

  Future<Map<String, dynamic>> register(
      String phone, String pin, String password) async {
    return await ApiMethods.postRequest(ApiRoutes.register, {
      'phone': phone.trim(),
      'pin': pin.trim(),
      'password': password.trim(),
    });
  }
}
