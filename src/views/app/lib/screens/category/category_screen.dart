import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/modules/category_service.dart';
import 'add_category_screen.dart';
import 'edit_category_screen.dart';
import '../../services/modules/transaction_service.dart';
import 'transaction_list_screen.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final CategoryService _categoryService = CategoryService();
  final TransactionService _transactionService = TransactionService();
  List<Map<String, dynamic>> _categories = [];
  bool _isLoading = true;
  String _filter = 'all'; // Lọc theo tất cả, chi hoặc thu

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  // Hàm để lấy userId từ SharedPreferences
  Future<String> _getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString('userData');
    if (userJson != null) {
      final user = jsonDecode(userJson);
      return user['id'].toString();
    }
    return '';
  }

  Future<void> _fetchCategories() async {
    try {
      final userId = await _getUserId();
      if (userId.isEmpty) {
        throw Exception('Không tìm thấy userId');
      }

      final response = await _categoryService.getCategoryByUserId(userId);
      if (response['code'] == 200) {
        setState(() {
          _categories = List<Map<String, dynamic>>.from(response['data']);
          _isLoading = false;
        });
      } else {
        throw Exception(response['message']);
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Không có giao dịch!')));
    }
  }

  // Hàm để hiển thị danh sách giao dịch khi người dùng chọn danh mục
  Future<void> _viewTransactions(String categoryId) async {
    try {
      final userId = await _getUserId();
      if (userId.isEmpty) {
        throw Exception('Không tìm thấy userId');
      }

      final response = await _transactionService.getTransactionsByCategory(categoryId, userId);
      if (response['code'] == 200 || response['status'] == "success") {
        // Chuyển đến màn hình hiển thị danh sách giao dịch
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TransactionListScreen(
              transactions: List<Map<String, dynamic>>.from(response['data']),
            ),
          ),
        );
      } else {
        throw Exception(response['message']);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Lỗi: $e')));
    }
  }
  Future<void> _deleteCategory(String categoryId) async {
    try {
      final response = await _categoryService.deleteCategory(categoryId);
      if (response['code'] == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Xóa danh mục thành công!')),
        );
        _fetchCategories();
      } else {
        throw Exception(response['message']);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Lỗi: $e')));
    }
  }

  // Hàm để lọc danh mục theo loại
  void _filterCategories(String filter) {
    setState(() {
      _filter = filter;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Lọc danh mục theo filter
    List<Map<String, dynamic>> filteredCategories = _categories.where((category) {
      if (_filter == 'all') {
        return true;
      } else {
        return category['type'] == _filter;
      }
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Quản lý danh mục"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_box_outlined, size: 30,),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddCategoryScreen()),
              ).then((_) => _fetchCategories());
            },
          ),
          IconButton(
            icon: const Icon(Icons.replay, size: 30,),
            onPressed: _fetchCategories,
          ),
          // Lọc theo "Chi"
          // IconButton(
          //   icon: const Icon(Icons.arrow_circle_up, size: 30, color: Colors.red,),
          //   onPressed: () => _filterCategories('Chi'),
          // ),
          // // Lọc theo "Thu"
          // IconButton(
          //   icon: const Icon(Icons.arrow_circle_down, size: 30, color: Colors.green,),
          //   onPressed: () => _filterCategories('Thu'),
          // ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,

          children: [
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: () => _filterCategories('all'),
                  icon: const Icon(Icons.filter_alt),
                  label: const Text("Tất cả"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton.icon(
                  onPressed: () => _filterCategories('Chi'),
                  icon: const Icon(Icons.arrow_circle_up),
                  label: const Text("Chi"),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white),
                ),
                const SizedBox(width: 10),
                ElevatedButton.icon(
                  onPressed: () => _filterCategories('Thu'),
                  icon: const Icon(Icons.arrow_circle_down),
                  label: const Text("Thu"),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: filteredCategories.length,
                itemBuilder: (context, index) {
                  final category = filteredCategories[index];
                  return Card(
                    elevation: 4,
                    margin: const EdgeInsets.only(bottom: 10),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      leading: Icon(
                        category['type'] == "Chi" ? Icons.arrow_circle_up : Icons.arrow_circle_down,
                        color: category['type'] == "Chi" ? Colors.red : Colors.green,
                        size: 40,
                      ),
                      title: Text(
                        category['name'],
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        category['type'] == "Chi" ? "Chi tiêu" : "Thu nhập",
                        style: TextStyle(color: category['type'] == "Chi" ? Colors.red : Colors.green),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Text(
                              '${category['transaction_count']} mục',
                              style: const TextStyle(fontSize: 14),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditCategoryScreen(category: category),
                                ),
                              ).then((_) => _fetchCategories());
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text("Xác nhận"),
                                  content: const Text("Bạn có chắc chắn muốn xóa danh mục này?"),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text("Hủy"),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        _deleteCategory(category['id'].toString());;
                                      },
                                      child: const Text("Xóa"),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      onTap: () {
                        // Gọi hàm để xem giao dịch của category
                        _viewTransactions(category['id'].toString());
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
