/// Provides the [NewsView] class.
import 'package:flutter/material.dart';

import '../json/news_list.dart';
import '../util.dart';
import 'news_item_view.dart';

/// A widget to show a [NewsList] instance.
class NewsView extends StatefulWidget {
  /// Create an instance.
  const NewsView({required this.newsList, required this.apiKey, Key? key})
      : super(key: key);

  /// The news list to use.
  final NewsList newsList;

  /// The API key to use for fetching images.
  final String apiKey;

  /// Create state for this widget.
  @override
  _NewsViewState createState() => _NewsViewState();
}

/// State for [NewsView].
class _NewsViewState extends State<NewsView> {
  /// Build a widget.
  @override
  Widget build(BuildContext context) {
    final newsItems = widget.newsList.newsItems
        .where((element) => element.sticky)
        .toList()
      ..addAll(widget.newsList.newsItems
          .where((element) => element.sticky == false));
    return ListView.builder(
      itemBuilder: (context, index) {
        final newsItem = newsItems[index];
        return ListTile(
          title: Text(newsItem.title + (newsItem.sticky ? ' (Sticky)' : '')),
          subtitle: Image.network(
            getImageUrl(newsItem.creator.id),
            headers: getHeaders(apiKey: widget.apiKey),
            semanticLabel: newsItem.creator.name,
          ),
          trailing: Text(prettyDate(newsItem.createdAt)),
          onTap: () =>
              Navigator.of(context).push(MaterialPageRoute<NewsItemView>(
            builder: (context) =>
                NewsItemView(newsItem: newsItem, apiKey: widget.apiKey),
          )),
        );
      },
      itemCount: newsItems.length,
    );
  }
}