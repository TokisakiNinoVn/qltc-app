import 'package:flutter/material.dart';
import '../../services/modules/transaction_service.dart';
import '../../services/modules/category_service.dart';

class AddTransactionScreen extends StatefulWidget {
  final String userId; // User ID passed to the screen for API calls
  const AddTransactionScreen({Key? key, required this.userId}) : super(key: key);

  @override
  _AddTransactionScreenState createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  String? _selectedCategory;

  final TransactionService _transactionService = TransactionService();
  final CategoryService _categoryService = CategoryService(); // Category service to fetch categories
  bool _isLoading = false;
  String _errorMessage = '';
  List<dynamic> _categories = [];

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  void _fetchCategories() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await _categoryService.getCategoryByUserId(widget.userId);
      if (response['code'] == 200) {
        setState(() {
          _categories = response['data']; // Set the categories to the list
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
        _errorMessage = 'Có lỗi xảy ra khi tải danh mục.';
        _isLoading = false;
      });
    }
  }

  // Submit transaction with selected category
  void _submitTransaction() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    final amount = _amountController.text;
    final title = _titleController.text;

    if (amount.isEmpty || title.isEmpty || _selectedCategory == null) {
      setState(() {
        _errorMessage = 'Vui lòng điền đầy đủ thông tin và chọn danh mục.';
        _isLoading = false;
      });
      return;
    }

    try {
      final response = await _transactionService.createTransaction(
          amount, title, _selectedCategory!, widget.userId);

      if (response['error'] != null) {
        setState(() {
          _errorMessage = response['error'];
          _isLoading = false;
        });
      } else {
        // Successfully added the transaction, navigate back
        Navigator.pop(context, true); // Trả về `true` để báo thành công
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Có lỗi xảy ra. Thử lại sau!';
        _isLoading = false;
      });
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thêm Giao Dịch'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _amountController,
              decoration: const InputDecoration(labelText: 'Số tiền'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Tiêu đề'),
            ),
            const SizedBox(height: 10),
            _isLoading
                ? const CircularProgressIndicator()
                : _categories.isEmpty
                ? const Text('Không có danh mục nào')
                : Wrap(
              spacing: 10.0,
              children: _categories.map<Widget>((category) {
                return ChoiceChip(
                  label: Text(category['name']),
                  selected: _selectedCategory == category['id'].toString(),
                  onSelected: (bool selected) {
                    setState(() {
                      _selectedCategory = selected ? category['id'].toString() : null;
                    });
                  },
                  selectedColor: Colors.teal,
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitTransaction,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
              child: const Text('Lưu Giao Dịch'),
            ),
            if (_errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Text(
                  _errorMessage,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
