/// Provides the [NewsVolunteer] class.
import 'package:json_annotation/json_annotation.dart';

import 'news_item.dart';

part 'news_volunteer.g.dart';

/// The volunteer who created a [NewsItem].
@JsonSerializable()
class NewsVolunteer {
  /// Create an instance.
  const NewsVolunteer(
      {required this.id, required this.name, required this.username});

  /// Create an instance from a JSON object.
  factory NewsVolunteer.fromJson(Map<String, dynamic> json) =>
      _$NewsVolunteerFromJson(json);

  /// The ID of this user.
  final int id;

  /// The name of this volunteer.
  final String name;

  /// The username of this volunteer.
  final String username;

  /// Convert an instance to JSON.
  Map<String, dynamic> toJson() => _$NewsVolunteerToJson(this);
}
