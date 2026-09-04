import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../data/reels_list.dart';

class ReelsTab extends StatelessWidget {
  const ReelsTab({super.key});

  Future<void> _launchReel(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: reelsList.length,
        itemBuilder: (context, index) {
          final reel = reelsList[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              contentPadding: const EdgeInsets.all(12),
              leading: const CircleAvatar(
                backgroundColor: Colors.pink,
                child: Icon(Icons.video_collection, color: Colors.white),
              ),
              title: Text(reel.title, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: const Text('Watch on Instagram'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () => _launchReel(reel.url),
            ),
          );
        },
      ),
    );
  }
}
