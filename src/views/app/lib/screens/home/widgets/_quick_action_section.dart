import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import './../../account/account_screen.dart';
import './../../statistical/statistical_screen.dart';
import './../../transaction/add_transaction_screen.dart';



class QuickActionSection extends StatelessWidget {
  const QuickActionSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            QuickActionItem(
              icon: Icons.add_circle,
              label: 'Thêm mới',
              onPressed: () {
                // Xử lý logic khi nhấn "Thêm mới"
              },
            ),
            QuickActionItem(
              icon: Icons.pie_chart,
              label: 'Thống kê',
              onPressed: () {
                // Xử lý logic khi nhấn "Thống kê"
              },
            ),
            QuickActionItem(
              icon: Icons.help_center,
              label: 'Hỗ trợ',
              onPressed: () async {
                const url = 'https://nino.is-a.dev/';
                if (await canLaunchUrl(Uri.parse(url))) {
                  await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
                } else {
                  throw 'Không thể mở URL: $url';
                }
              },
            ),
            QuickActionItem(
              icon: Icons.person,
              label: 'Tài khoản',
              onPressed: () {
                // Xử lý logic khi nhấn "Tài khoản"
              },
            ),
          ],
        ),
      ),
    );
  }
}

class QuickActionItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  const QuickActionItem({
    Key? key,
    required this.icon,
    required this.label,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton(
          onPressed: onPressed,
          icon: Icon(icon, size: 28, color: Colors.teal),
        ),
        Text(label, style: const TextStyle(fontSize: 14)),
      ],
    );
  }
}

