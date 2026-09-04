import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:webfeed_revised/webfeed_revised.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import '../data/video_channels.dart';

class VideosTab extends StatefulWidget {
  const VideosTab({super.key});

  @override
  State<VideosTab> createState() => _VideosTabState();
}

class _VideosTabState extends State<VideosTab> {
  bool loading = true;
  final List<Map<String, String>> youtubeVideos = [];

  @override
  void initState() {
    super.initState();
    _fetchLiveVideos();
  }

  Future<void> _fetchLiveVideos() async {
    final List<Map<String, String>> loadedVideos = [];

    for (var channel in videoChannels) {
      try {
        final url = 'https://www.youtube.com/feeds/videos.xml?channel_id=${channel.channelId}';
        final response = await http.get(Uri.parse(url)).timeout(const Duration(seconds: 5));

        if (response.statusCode == 200) {
          final feed = RssFeed.parse(response.body);
          if (feed.items != null) {
            for (var item in feed.items!.take(3)) {
              final videoId = item.link?.split('v=').last ?? '';
              if (videoId.isNotEmpty) {
                loadedVideos.add({
                  'title': item.title ?? 'Job Video',
                  'channel': channel.name,
                  'videoId': videoId,
                });
              }
            }
          }
        }
      } catch (_) {}
    }

    if (mounted) {
      setState(() {
        youtubeVideos.addAll(loadedVideos);
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : youtubeVideos.isEmpty
              ? const Center(child: Text('No videos found right now.'))
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: youtubeVideos.length,
                  itemBuilder: (context, index) {
                    final video = youtubeVideos[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        leading: const Icon(Icons.play_circle_fill, color: Colors.red, size: 40),
                        title: Text(
                          video['title']!,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text(video['channel']!),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => VideoPlayerScreen(
                                title: video['title']!,
                                videoId: video['videoId']!,
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
    );
  }
}

class VideoPlayerScreen extends StatefulWidget {
  final String title;
  final String videoId;

  const VideoPlayerScreen({
    super.key,
    required this.title,
    required this.videoId,
  });

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController.fromVideoId(
      videoId: widget.videoId,
      params: const YoutubePlayerParams(
        showControls: true,
        showFullscreenButton: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Job Video')),
      body: Column(
        children: [
          YoutubePlayer(
            controller: _controller,
            aspectRatio: 16 / 9,
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              widget.title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
