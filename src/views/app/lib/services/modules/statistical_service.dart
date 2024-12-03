import '../api_routes.dart';
import '../api_methods.dart';

class ServicesService {
  // Thống kê giao dịch của người dùng theo tháng
  Future<Map<String, dynamic>> getTransactionByMonthOfUser(String userId, int month) async {
    try {
      final response = await ApiMethods.postRequest(
        ApiRoutes.getStatisticalOfMonth,
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