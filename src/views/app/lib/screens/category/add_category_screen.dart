import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/modules/category_service.dart';

class AddCategoryScreen extends StatelessWidget {
  const AddCategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final CategoryService _categoryService = CategoryService();
    final nameController = TextEditingController();
    String? selectedType;

    Future<void> _createCategory(BuildContext context, String userId) async {
      try {
        // Gọi API để tạo danh mục
        final response = await _categoryService.createCategory(
          userId,
          nameController.text,
          selectedType!,
        );

        if (response['code'] == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Thêm danh mục thành công!")),
          );
          Navigator.pop(context);
        } else {
          throw Exception(response['message']);
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Lỗi: $e")),
        );
      }
    }

    Future<String> _getUserId() async {
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString('userData');
      if (userJson != null) {
        final user = jsonDecode(userJson);
        return user['id'].toString(); // Đảm bảo trả về String
      }
      return '';
    }


    return Scaffold(
      appBar: AppBar(
        title: const Text("Thêm danh mục"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: "Tên danh mục",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: selectedType,
              items: const [
                DropdownMenuItem(value: "Chi", child: Text("Chi")),
                DropdownMenuItem(value: "Thu", child: Text("Thu")),
              ],
              onChanged: (value) {
                selectedType = value;
              },
              decoration: const InputDecoration(
                labelText: "Loại",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                if (nameController.text.isNotEmpty && selectedType != null) {
                  final userId = await _getUserId(); // Lấy userId từ SharedPreferences
                  if (userId.isNotEmpty) {
                    _createCategory(context, userId); // Gọi hàm thêm danh mục với userId
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Không tìm thấy người dùng!")),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Vui lòng điền đầy đủ thông tin!")),
                  );
                }
              },
              child: const Text("Lưu"),
            ),
          ],
        ),
      ),
    );
  }
}
