/// Provides constants for use in the program.
library constants;

import 'package:flutter/material.dart';

/// The base URL for HTTP requests.
const baseUrl = 'https://www.3r.org.uk';

/// How often should HTTP requests be repeated.
const httpGetInterval = Duration(minutes: 10);

/// A regular expression for recognising links in news items.
final linkRegExp = RegExp(r'\<a href="([^"]+)">([^<]+)\<\/a\>');

/// A regular expression to get images.
final imgRegExp = RegExp(r'\<img alt="([^"]+)" src="([^"]+)" \/\>');

/// A regular expression for checking for `<strong>` and `</strong>` tags.
final strongRegExp = RegExp(r'\<strong\>([^<$]+)\<\/strong\>');

/// The below styles taken from [https://discoverflutter.com/how-to-add-a-hyperlink-in-text-in-flutter/].

/// The style for regular text in news items.
const normalStyle = TextStyle(color: Colors.black);

/// A bold style.
const boldStyle = TextStyle(
  color: Colors.black,
  fontWeight: FontWeight.bold,
);

/// The style for links in news items.
const linkStyle = TextStyle(
    color: Colors.red,
    fontWeight: FontWeight.bold,
    decoration: TextDecoration.underline);
