import '../api_routes.dart';
import '../api_methods.dart';

class CategoryService {
  // Tạo danh mục mới
  Future<Map<String, dynamic>> createCategory(String userId, String name, String type) async {
    return await ApiMethods.postRequest('${ApiRoutes.createCategory}/$userId', {
      'name': name,
      'type': type,
    });
  }

  // Cập nhật danh mục
  Future<Map<String, dynamic>> updateCategory(String categoryId, String userId, String name, String type) async {
    return await ApiMethods.putRequest('${ApiRoutes.updateCategory}/$categoryId', {
      'idUser': userId,
      'name': name,
      'type': type,
    });
  }

  // Xóa danh mục
  Future<Map<String, dynamic>> deleteCategory(String categoryId) async {
    return await ApiMethods.deleteRequest('${ApiRoutes.deleteCategory}/$categoryId');
  }

  // Lấy danh sách danh mục theo userId
  Future<Map<String, dynamic>> getCategoryByUserId(String userId) async {
    return await ApiMethods.getRequest('${ApiRoutes.getCategoryByUserId}/$userId');
  }

  // Lấy danh sách danh mục theo loại và userId
  Future<Map<String, dynamic>> getCategoryByTypeWithUserId(String userId, String type) async {
    return await ApiMethods.postRequest('${ApiRoutes.getCategoryByTypeWithUserId}/$userId', {
      'type': type,
    });
  }
}

