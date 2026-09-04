import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:webfeed_revised/webfeed_revised.dart';
import '../data/articles_sources.dart';
import 'article_detail_screen.dart';

class ArticlesTab extends StatefulWidget {
  const ArticlesTab({super.key});

  @override
  State<ArticlesTab> createState() => _ArticlesTabState();
}

class _ArticlesTabState extends State<ArticlesTab> {
  final List<RssItem> items = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadAllFeeds();
  }

  Future<void> _loadAllFeeds() async {
    if (!mounted) return;
    setState(() => loading = true);

    final futures = articleSources.map((source) async {
      try {
        final response = await http.get(Uri.parse(source.url)).timeout(
              const Duration(seconds: 4),
            );
        if (response.statusCode == 200) {
          final feed = RssFeed.parse(response.body);
          return feed.items?.take(5).toList() ?? <RssItem>[];
        }
      } catch (_) {}
      return <RssItem>[];
    });

    final results = await Future.wait(futures);
    final List<RssItem> allItems = results.expand((element) => element).toList();

    allItems.sort((a, b) {
      if (a.pubDate == null) return 1;
      if (b.pubDate == null) return -1;
      return b.pubDate!.compareTo(a.pubDate!);
    });

    if (mounted) {
      setState(() {
        items
          ..clear()
          ..addAll(allItems);
        loading = false;
      });
    }
  }

  String _cleanText(String? text) {
    if (text == null) return '';
    return text
        .replaceAll(RegExp(r'<[^>]*>'), '')
        .replaceAll('&nbsp;', ' ')
        .replaceAll('&amp;', '&')
        .trim();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadAllFeeds,
              child: items.isEmpty
                  ? const Center(child: Text('No job updates found.'))
                  : ListView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final item = items[index];
                        final title = item.title ?? 'Untitled Job Alert';
                        final desc = _cleanText(item.description ?? item.content?.value ?? '');
                        final shortDesc = desc.length > 150 ? '${desc.substring(0, 150)}...' : desc;

                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: Padding(
                            padding: const EdgeInsets.all(14),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  title,
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 8),
                                Text(shortDesc.isEmpty ? 'Tap read more for full details.' : shortDesc),
                                const SizedBox(height: 10),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => ArticleDetailScreen(
                                            title: title,
                                            content: desc.isEmpty ? 'Full details available at website.' : desc,
                                            link: item.link,
                                          ),
                                        ),
                                      );
                                    },
                                    child: const Text('Read More'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
    );
  }
}
