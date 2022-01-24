/// Provides the [CreatorVolunteer] class.
import 'package:json_annotation/json_annotation.dart';

import 'news_item.dart';

part 'creator_volunteer.g.dart';

/// The volunteer who created a [NewsItem].
@JsonSerializable()
class CreatorVolunteer {
  /// Create an instance.
  const CreatorVolunteer(
      {required this.id, required this.name, required this.username});

  /// Create an instance from a JSON object.
  factory CreatorVolunteer.fromJson(Map<String, dynamic> json) =>
      _$CreatorVolunteerFromJson(json);

  /// The ID of this user.
  final int id;

  /// The name of this volunteer.
  final String name;

  /// The username of this volunteer.
  final String username;

  /// Convert an instance to JSON.
  Map<String, dynamic> toJson() => _$CreatorVolunteerToJson(this);
}
