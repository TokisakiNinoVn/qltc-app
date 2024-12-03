class ApiRoutes {
  // static const String baseUrl = 'http://192.168.1.47:5007/api';
  static const String baseUrl = 'http://192.168.110.67:5007/api';

  static const String baseUrlPublic = '$baseUrl/public';

  static const String login = '$baseUrlPublic/auth/login';
  static const String register = '$baseUrlPublic/auth/register';

  static const String updateUser = '$baseUrlPublic/user';
  static const String deleteUser = '$baseUrlPublic/user';
  static const String getUser = '$baseUrlPublic/user';

  //category
  static const String getCategoryByTypeWithUserId = '$baseUrlPublic/category/a';
  static const String getCategoryByUserId = '$baseUrlPublic/category';
  static const String deleteCategory = '$baseUrlPublic/category';
  static const String updateCategory = '$baseUrlPublic/category';
  static const String createCategory = '$baseUrlPublic/category';

  //transaction
  static const String createTransaction = '$baseUrlPublic/transaction';

  static const String getByUserId = '$baseUrlPublic/transaction';
  static const String getTransactionById = '$baseUrlPublic/transaction/a';
  static const String getTransactionsByCategory = '$baseUrlPublic/transaction/b';
  static const String getTransactionByMonthOfUser = '$baseUrlPublic/transaction/c';

  static const String updateTransaction = '$baseUrlPublic/transaction';

  static const String deleteTransaction = '$baseUrlPublic/transaction';


  //statistical
  static const String getStatisticalOfMonth = '$baseUrlPublic/statistical/';
}
