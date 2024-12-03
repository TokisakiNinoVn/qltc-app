import '../api_routes.dart';
import '../api_methods.dart';

class TransactionService {
  // Tạo giao dịch mới
  Future<Map<String, dynamic>> createTransaction(
      String amount, String title, String category, String userId) async {
    try {
      final response = await ApiMethods.postRequest(
          ApiRoutes.createTransaction,
          {
            'amount': amount,
            'title': title,
            'category': category,
            'userId': userId
          }
      );
      return response;
    } catch (e) {
      return {'error': e.toString()};
    }
  }

  // Lấy tất cả giao dịch của một người dùng
  Future<Map<String, dynamic>> getTransactionsByUserId(String userId) async {
    try {
      final response = await ApiMethods.getRequest('${ApiRoutes.getByUserId}/$userId');
      return response;
    } catch (e) {
      return {'error': e.toString()};
    }
  }

  // Lấy giao dịch theo ID
  Future<Map<String, dynamic>> getTransactionById(String transactionId) async {
    try {
      final response = await ApiMethods.getRequest('${ApiRoutes.getTransactionById}/$transactionId');
      return response;
    } catch (e) {
      return {'error': e.toString()};
    }
  }

  // Cập nhật giao dịch
  Future<Map<String, dynamic>> updateTransaction(String transactionId, String amount, String title, String category) async {
    try {
      final response = await ApiMethods.putRequest(
          '${ApiRoutes.updateTransaction}/$transactionId',
          {
            'amount': amount,
            'title': title,
            'category': category
          }
      );
      return response;
    } catch (e) {
      return {'error': e.toString()};
    }
  }

  // Xóa giao dịch
  Future<Map<String, dynamic>> deleteTransaction(String transactionId) async {
    try {
      final response = await ApiMethods.deleteRequest('${ApiRoutes.deleteTransaction}/$transactionId');
      return response;
    } catch (e) {
      return {'error': e.toString()};
    }
  }

  // Lấy tất cả giao dịch của một category
  Future<Map<String, dynamic>> getTransactionsByCategory(String categoryId, String userId) async {
    try {
      final response = await ApiMethods.postRequest(
          ApiRoutes.getTransactionsByCategory,
          {
            'id': categoryId,
            'idUser': userId
          }
      );
      return response;
    } catch (e) {
      return {'error': e.toString()};
    }
  }

  // Lấy giao dịch của người dùng theo tháng
  Future<Map<String, dynamic>> getTransactionByMonthOfUser(String userId, int month) async {
    try {
      final response = await ApiMethods.postRequest(
        ApiRoutes.getTransactionByMonthOfUser,
        {
          'id': userId,
          'month': month,
        },
      );
      return response;
    } catch (e) {
      return {'error': e.toString()};
    }
  }

}
