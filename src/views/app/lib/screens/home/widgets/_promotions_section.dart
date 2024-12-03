import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PromotionsSection extends StatelessWidget {
  const PromotionsSection({Key? key}) : super(key: key);

  // Danh sách tin nhắn cho người dùng
  static const messageForUser = [
    'Xem tất cả các khuyến mãi',
    'Tìm kiếm khuyến mãi',
    'Đăng ký nhận thông báo',
    'Chúc bạn và gia đình luôn mạnh khỏe',
    'Hãy tận hưởng ngày tuyệt vời của bạn!',
  ];

  // Lấy tên người dùng từ SharedPreferences
  Future<String> _getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString('userData');
    if (userJson != null) {
      final user = jsonDecode(userJson);
      return user['name'] ?? ''; // Đảm bảo trả về String
    }
    return 'Khách'; // Tên mặc định nếu không tìm thấy
  }

  // Hàm chọn tin nhắn ngẫu nhiên
  String _getRandomMessage() {
    final random = Random();
    return messageForUser[random.nextInt(messageForUser.length)];
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '🎉 Khuyến mãi dành riêng cho bạn!',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.indigo,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 160,
            child: FutureBuilder<String>(
              future: _getUserName(),
              builder: (context, snapshot) {
                final userName = snapshot.data ?? 'Khách';
                return ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _buildWelcomeCard(userName),
                    ...List.generate(
                      5, // Số lượng ảnh/lời nhắn
                          (index) => _buildImageWithMessage(),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Widget cho lời chào
  Widget _buildWelcomeCard(String userName) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.all(12),
      width: 240,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.lightBlueAccent, Colors.blueAccent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: Text(
          "Xin chào $userName, chúc bạn một ngày vui vẻ!",
          style: const TextStyle(
            fontSize: 16,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  // Widget cho ảnh kèm tin nhắn
  Widget _buildImageWithMessage() {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      width: 120,
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(60), // Bo tròn
            child: Image.asset(
              'lib/assets/images/bot.png',
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.orange.shade100,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.orange.shade200,
                  blurRadius: 6,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Center(
              child: Text(
                _getRandomMessage(),
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.deepOrange,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
