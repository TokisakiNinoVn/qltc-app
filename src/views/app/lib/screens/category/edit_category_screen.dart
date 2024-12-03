import 'package:flutter/material.dart';
import '../../services/modules/category_service.dart';

class EditCategoryScreen extends StatelessWidget {
  final Map<String, dynamic> category;

  const EditCategoryScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    final CategoryService _categoryService = CategoryService();
    final nameController = TextEditingController(text: category["name"]);
    String? selectedType = category["type"];

    Future<void> _updateCategory(BuildContext context) async {
      try {
        // Gọi API cập nhật danh mục
        final response = await _categoryService.updateCategory(
          category['id'].toString(), // ID danh mục
          '4', // ID người dùng (thay thế bằng giá trị thực)
          nameController.text,
          selectedType!,
        );

        if (response['code'] == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Cập nhật danh mục thành công!")),
          );
          Navigator.pop(context); // Quay lại màn hình trước đó
        } else {
          throw Exception(response['message']);
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Lỗi: $e")),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Chỉnh sửa danh mục"),
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
              onPressed: () {
                if (nameController.text.isNotEmpty && selectedType != null) {
                  _updateCategory(context); // Gọi hàm cập nhật danh mục
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
