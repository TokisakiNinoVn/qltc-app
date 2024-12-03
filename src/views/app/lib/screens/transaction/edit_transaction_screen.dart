import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/modules/category_service.dart';
import '../../services/modules/transaction_service.dart';

class EditTransactionScreen extends StatefulWidget {
  final Map<String, dynamic> transaction;

  const EditTransactionScreen({Key? key, required this.transaction})
      : super(key: key);

  @override
  _EditTransactionScreenState createState() => _EditTransactionScreenState();
}

class _EditTransactionScreenState extends State<EditTransactionScreen> {
  late TextEditingController _titleController;
  late TextEditingController _amountController;
  final CategoryService _categoryService = CategoryService();
  String? _selectedCategory;
  List<dynamic> _categories = [];
  bool _isLoading = false;
  String _errorMessage = '';
  late final String userId;

  Future<String> _getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString('userData');
    if (userJson != null) {
      final user = jsonDecode(userJson);
      return user['id'].toString();
    }
    return '';
  }

  void _fetchCategories() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final userId = await _getUserId();
      if (userId.isEmpty) {
        _errorMessage = 'Không tìm thấy userId';
      }
      final response = await _categoryService.getCategoryByUserId(userId);
      if (response['code'] == 200 && response['data'] != null) {
        setState(() {
          _categories = response['data'];
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = 'Không thể tải danh mục. Thử lại sau!';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Có lỗi xảy ra khi tải danh mục: $e';
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.transaction['title']);
    _amountController = TextEditingController(
      text: widget.transaction['amount'].toString(),
    );

    // Get user ID and fetch categories
    _getUserId().then((id) {
      setState(() {
        userId = id;
      });
      _fetchCategories();
    });

    // Set the initial selected category from the transaction
    _selectedCategory = widget.transaction['categoryName'];
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chỉnh Sửa Giao Dịch"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Tiêu đề
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: "Tiêu đề",
                prefixIcon: Icon(Icons.title),
              ),
            ),
            const SizedBox(height: 16),
            // Số tiền
            TextFormField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Số tiền",
                prefixIcon: Icon(Icons.money),
              ),
            ),
            const SizedBox(height: 16),
            // Hiển thị danh mục
            _isLoading
                ? const CircularProgressIndicator()
                : _categories.isEmpty
                ? Text(_errorMessage.isEmpty
                ? 'Không tìm thấy danh mục'
                : _errorMessage)
                : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Danh mục',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 10.0, // khoảng cách giữa các nhãn
                  runSpacing: 10.0,
                  children: _categories.map<Widget>((category) {
                    final String categoryName = category['name'];
                    return ChoiceChip(
                      label: Text(categoryName),
                      selected: _selectedCategory == categoryName,
                      onSelected: (bool selected) {
                        setState(() {
                          _selectedCategory =
                          selected ? categoryName : null;
                        });
                      },
                    );
                  }).toList(),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Nút lưu
            ElevatedButton(
              onPressed: () {
                final updatedTransaction = {
                  'title': _titleController.text,
                  'amount': double.tryParse(_amountController.text) ?? 0.0,
                  'categoryName': _selectedCategory,
                };

                // Quay lại với giao dịch đã chỉnh sửa
                Navigator.pop(context, updatedTransaction);
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: Colors.blueAccent,
              ),
              child: const Text("Lưu"),
            ),
          ],
        ),
      ),
    );
  }
}
