import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '🌠 Liên hệ Admin',
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16.0),
          ContactButton(
            icon: FontAwesomeIcons.github,
            label: 'GitHub',
            url: 'https://github.com/yourusername',
          ),
          const SizedBox(height: 8.0),
          ContactButton(
            icon: FontAwesomeIcons.facebook,
            label: 'Facebook',
            url: 'https://facebook.com/yourusername',
          ),
          const SizedBox(height: 8.0),
          ContactButton(
            icon: FontAwesomeIcons.discord,
            label: 'Discord',
            url: 'https://discord.com/invite/yourinvitecode',
          ),
          const SizedBox(height: 8.0),
          ContactButton(
            icon: FontAwesomeIcons.phone,
            label: 'Zalo',
            url: 'https://zalo.me/yourphonenumber',
          ),
        ],
      ),
    );
  }
}

class ContactButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final String url;

  const ContactButton({
    required this.icon,
    required this.label,
    required this.url,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _launchUrl(url, context),
      child: Row(
        children: [
          Icon(icon, size: 30.0, color: Colors.blue),
          const SizedBox(width: 16.0),
          Text(
            label,
            style: const TextStyle(fontSize: 18.0),
          ),
        ],
      ),
    );
  }

  void _launchUrl(String url, BuildContext context) async {
    // Placeholder: Open the link with your URL launcher logic.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Mở liên kết: $url')),
    );
  }
}
