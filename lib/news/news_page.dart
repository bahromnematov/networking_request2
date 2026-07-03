import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:networking_request2/news/news_model.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  List<Articles> news = [];

  Future<void> openUrl(String url) async {
    final Uri uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw Exception('URL ochilmadi: $url');
    }
  }

  Future<List<Articles>> getApiNews() async {
    final response = await http.get(
      Uri.parse(
        "https://newsapi.org/v2/top-headlines?sources=techcrunch&apiKey=2eebeaa50122431cb3c2a603d3920bae",
      ),
    );
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body)['articles'];
      for (var a in data) {
        news.add(Articles.fromJson(a));
      }
      return news;
    }
    return news;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: FutureBuilder<List<Articles>>(
          future: getApiNews(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            final news = snapshot.data!;

            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: 350,
                  pinned: true,
                  stretch: true,
                  title: const Text("News App"),
                  flexibleSpace: FlexibleSpaceBar(
                    background: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Image.network(
                            news[0].urlToImage ??
                                "https://png.pngtree.com/png-vector/20190820/ourmid/pngtree-no-image-vector-illustration-isolated-png-image_1694547.jpg",
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                news[0].author ?? "",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),

                              const SizedBox(height: 8),

                              Text(news[0].title ?? ""),

                              const SizedBox(height: 8),

                              Text(
                                DateFormat("dd MMM yyyy HH:mm").format(
                                  DateTime.parse(news[0].publishedAt ?? ""),
                                ),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    return InkWell(
                      onTap: () {
                        openUrl(news[index].url ?? "");
                      },
                      child: Container(
                        margin: const EdgeInsets.all(15),
                        child: Row(
                          children: [
                            Container(
                              width: 130,
                              height: 130,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                image: DecorationImage(
                                  image: NetworkImage(
                                    news[index].urlToImage ??
                                        "https://png.pngtree.com/png-vector/20190820/ourmid/pngtree-no-image-vector-illustration-isolated-png-image_1694547.jpg",
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),

                            const SizedBox(width: 12),

                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    news[index].author ?? "",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(news[index].title ?? ""),
                                  Text(
                                    DateFormat("dd MMM yyyy HH:mm").format(
                                      DateTime.parse(
                                        news[index].publishedAt ?? "",
                                      ),
                                    ),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }, childCount: news.length),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
