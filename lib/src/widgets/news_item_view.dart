import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher.dart';

import '../json/news_item.dart';
import '../util.dart';
import 'cancellable_widget.dart';

/// A widget to display a [NewsItem] instance.
class NewsItemView extends StatefulWidget {
  /// Create an instance.
  const NewsItemView({required this.newsItem, required this.apiKey, Key? key})
      : super(key: key);

  /// The news item to display.
  final NewsItem newsItem;

  /// The API key to use for getting images.
  final String apiKey;

  /// Create state for this widget.
  @override
  _NewsItemViewState createState() => _NewsItemViewState();
}

/// State for [NewsItemView].
class _NewsItemViewState extends State<NewsItemView> {
  /// Build a widget.
  @override
  Widget build(BuildContext context) => CancellableWidget(
        child: Scaffold(
          appBar: AppBar(
            title: Text(widget.newsItem.title),
          ),
          body: Focus(
            autofocus: true,
            child: SingleChildScrollView(
              child: Html(
                data:
                    '<h3>Priority: ${widget.newsItem.priority}</h3>${widget.newsItem.body}',
                onAnchorTap: (
                  url,
                  context,
                  attributes,
                  element,
                ) =>
                    url == null ? null : launch(url),
                customImageRenders: {
                  networkSourceMatcher(domains: ['3r.org.uk', 'www.3r.org.uk']):
                      (context, attributes, element) {
                    final src = attributes['src'] ?? 'about:blank';
                    final alt = attributes['alt'] ?? 'Unlabelled image';
                    final headers = getHeaders(apiKey: widget.apiKey);
                    return Image.network(
                      src,
                      errorBuilder: (context, error, stackTrace) {
                        print('Failed to load $alt ($src).');
                        print('Headers: $headers');
                        print(error);
                        print(stackTrace);
                        return Icon(
                          Icons.image_not_supported_rounded,
                          semanticLabel: alt,
                        );
                      },
                      headers: headers,
                      height: double.tryParse(attributes['height'] ?? ''),
                      semanticLabel: alt,
                      width: double.tryParse(attributes['width'] ?? ''),
                    );
                  }
                },
              ),
            ),
          ),
        ),
      );
}
