import '../api_routes.dart';
import '../api_methods.dart';

class UserService {
  // Sửa phương thức update để nhận id và userData dưới dạng Map
  Future<Map<String, dynamic>> update(int id, Map<String, dynamic> userData) async {
    return await ApiMethods.postRequest(
      '${ApiRoutes.updateUser}/$id',
      userData,
    );
  }

  Future<Map<String, dynamic>> deleteUser({required int id}) async {
    try {
      return await ApiMethods.deleteRequest(
        '${ApiRoutes.deleteUser}/$id',
      );
    } catch (e) {
      return {'error': e.toString()};
    }
  }
  Future<Map<String, dynamic>> getInfor({required int id}) async {
    try {
      return await ApiMethods.getRequest(
        '${ApiRoutes.getUser}/$id',
      );
    } catch (e) {
      return {'error': e.toString()};
    }
  }
}
