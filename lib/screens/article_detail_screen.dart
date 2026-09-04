import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ArticleDetailScreen extends StatelessWidget {
  final String title;
  final String content;
  final String? link;

  const ArticleDetailScreen({
    super.key,
    required this.title,
    required this.content,
    this.link,
  });

  Future<void> _openLink() async {
    if (link != null && link!.isNotEmpty) {
      final uri = Uri.parse(link!);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Job Details')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Text(content, style: const TextStyle(fontSize: 15, height: 1.5)),
          const SizedBox(height: 24),
          if (link != null)
            ElevatedButton.icon(
              onPressed: _openLink,
              icon: const Icon(Icons.open_in_browser),
              label: const Text('Open Official Website'),
            ),
        ],
      ),
    );
  }
}
