/// Provides the [NewsItem] class.
import 'package:json_annotation/json_annotation.dart';

import 'creator_volunteer.dart';

part 'news_item.g.dart';

/// An item in the news.
@JsonSerializable()
class NewsItem {
  /// Create an instance.
  const NewsItem({
    required this.id,
    required this.title,
    required this.body,
    required this.url,
    required this.orgId,
    required this.createdAt,
    required this.updatedAt,
    required this.archivedAt,
    required this.expiresAt,
    required this.sticky,
    required this.priority,
    required this.creator,
    required this.updater,
  });

  /// Create an instance from a JSON object.
  factory NewsItem.fromJson(final Map<String, dynamic> json) =>
      _$NewsItemFromJson(json);

  /// The ID of this item.
  final int id;

  /// The title of this news item.
  final String title;

  /// The body of the news item.
  final String body;

  /// The URL of this item.
  final String url;

  /// The ID of the organisation who owns this news item.
  @JsonKey(name: 'org_id')
  final int orgId;

  /// When this news item was created.
  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  /// When this news item was last updated.
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  /// When (if) this news item was archived.
  @JsonKey(name: 'archived_at')
  final DateTime? archivedAt;

  /// When this news item expires.
  @JsonKey(name: 'expires_at')
  final DateTime expiresAt;

  /// Whether or not this news item is sticky.
  final bool sticky;

  /// The priority of this news item.
  final String priority;

  /// The person who created this news item.
  final CreatorVolunteer creator;

  /// The person who updated this news item.
  final CreatorVolunteer updater;

  /// Convert an instance to JSON.
  Map<String, dynamic> toJson() => _$NewsItemToJson(this);
}
