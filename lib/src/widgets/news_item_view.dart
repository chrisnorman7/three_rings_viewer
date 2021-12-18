import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants.dart';
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
  Widget build(BuildContext context) {
    final children = [
      TextSpan(
          text: 'Created: ${prettyDate(widget.newsItem.createdAt)} by '
              '${widget.newsItem.creator.name}.',
          style: normalStyle),
      WidgetSpan(
          child: Image.network(
        getImageUrl(widget.newsItem.creator.id),
        headers: getHeaders(apiKey: widget.apiKey),
        semanticLabel: widget.newsItem.creator.name,
      ))
    ];
    final htmlUnescape = HtmlUnescape();
    for (var line in widget.newsItem.body.split('\n')) {
      line = line.replaceAll('<p>', '').replaceAll('</p>', '').trim();
      if (line.isEmpty) {
        children.add(const TextSpan(text: '\n', style: normalStyle));
        continue;
      }
      final matches = linkRegExp.allMatches(line).toList();
      if (matches.isEmpty) {
        children.addAll(checkImages(text: line, htmlUnescape: htmlUnescape));
        continue;
      }
      var lastEnd = 0;
      for (final match in matches) {
        if (match.start > lastEnd) {
          final chunk = line.substring(lastEnd, match.start);
          children.addAll(checkImages(text: chunk, htmlUnescape: htmlUnescape));
        }
        final url = match.group(1)!;
        final title = match.group(2)!;
        children.add(TextSpan(
            text: title,
            style: linkStyle,
            recognizer: TapGestureRecognizer()..onTap = () => launch(url)));
        lastEnd = match.end;
      }
      children.add(const TextSpan(text: '\n', style: normalStyle));
    }
    return CancellableWidget(
        child: Scaffold(
            appBar: AppBar(
              title: Text(widget.newsItem.title),
            ),
            body: Focus(
                child: SelectableText.rich(TextSpan(children: children)))));
  }

  /// Check the given [text] for HTML `strong` tags.
  List<InlineSpan> checkStrong(
      {required String text, required HtmlUnescape htmlUnescape}) {
    final matches = strongRegExp.allMatches(text).toList();
    if (matches.isEmpty) {
      return [TextSpan(text: htmlUnescape.convert(text), style: normalStyle)];
    }
    final spans = <InlineSpan>[];
    var lastEnd = 0;
    for (final match in matches) {
      if (match.start > lastEnd) {
        spans.add(TextSpan(
            text: htmlUnescape.convert(text.substring(lastEnd, match.start)),
            style: normalStyle));
      }
      spans.add(TextSpan(
          text: htmlUnescape.convert(match.group(1)!), style: boldStyle));
      lastEnd = match.end;
    }
    return spans;
  }

  /// Scan the given [text] for images using [imgRegExp], and return a list of
  /// spans.
  List<InlineSpan> checkImages(
      {required String text, required HtmlUnescape htmlUnescape}) {
    final matches = imgRegExp.allMatches(text).toList();
    if (matches.isEmpty) {
      return checkStrong(text: text, htmlUnescape: htmlUnescape);
    }
    final spans = <InlineSpan>[];
    var lastEnd = 0;
    for (final match in matches) {
      if (match.start > lastEnd) {
        spans.addAll(checkStrong(
            text: text.substring(lastEnd, match.start),
            htmlUnescape: htmlUnescape));
      }
      final altText = match.group(1)!;
      final url = match.group(2)!;
      spans.add(WidgetSpan(
          child: Image.network(
        url,
        headers: getHeaders(apiKey: widget.apiKey),
        semanticLabel: altText,
      )));
      lastEnd = match.end;
    }
    return spans;
  }
}
