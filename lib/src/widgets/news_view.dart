/// Provides the [NewsView] class.
import 'package:flutter/material.dart';

import '../json/news_list.dart';
import '../util.dart';
import 'news_item_view.dart';

/// A widget to show a [NewsList] instance.
class NewsView extends StatefulWidget {
  /// Create an instance.
  const NewsView({required this.newsList, required this.apiKey, final Key? key})
      : super(key: key);

  /// The news list to use.
  final NewsList newsList;

  /// The API key to use for fetching images.
  final String apiKey;

  /// Create state for this widget.
  @override
  NewsViewState createState() => NewsViewState();
}

/// State for [NewsView].
class NewsViewState extends State<NewsView> {
  /// Build a widget.
  @override
  Widget build(final BuildContext context) {
    final newsItems = [
      ...widget.newsList.newsItems.where((final element) => element.sticky),
      ...widget.newsList.newsItems
          .where((final element) => element.sticky == false)
    ];
    return ListView.builder(
      itemBuilder: (final context, final index) {
        final newsItem = newsItems[index];
        final title = Text(
          newsItem.title + (newsItem.sticky ? ' (Sticky)' : ''),
        );
        return ListTile(
          autofocus: index == 0,
          leading: Image.network(
            getImageUrl(newsItem.creator.id),
            headers: getHeaders(apiKey: widget.apiKey),
            semanticLabel: newsItem.creator.name,
          ),
          title: newsItem.sticky
              ? Container(
                  decoration: const BoxDecoration(color: Colors.yellow),
                  child: title,
                )
              : title,
          subtitle: Text(prettyDate(newsItem.createdAt)),
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute<NewsItemView>(
              builder: (final context) =>
                  NewsItemView(newsItem: newsItem, apiKey: widget.apiKey),
            ),
          ),
        );
      },
      itemCount: newsItems.length,
    );
  }
}
