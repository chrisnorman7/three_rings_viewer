/// Provides the [NewsList] class.
import 'package:json_annotation/json_annotation.dart';

import 'news_item.dart';

part 'news_list.g.dart';

/// Load a list of [NewsItem] instances.
@JsonSerializable()
class NewsList {
  /// Create an instance.
  const NewsList(this.newsItems);

  /// Create an instance from a JSON object.
  factory NewsList.fromJson(Map<String, dynamic> json) =>
      _$NewsListFromJson(json);

  /// The items this list contains.
  @JsonKey(name: 'news_items')
  final List<NewsItem> newsItems;

  /// Convert an instance to JSON.
  Map<String, dynamic> toJson() => _$NewsListToJson(this);
}
