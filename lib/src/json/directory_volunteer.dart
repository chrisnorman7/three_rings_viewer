/// Provides the [DirectoryVolunteer] class.
import 'package:json_annotation/json_annotation.dart';

import 'account.dart';
import 'person.dart';
import 'volunteer_property.dart';
import 'volunteer_relationship.dart';
import 'volunteer_role.dart';

part 'directory_volunteer.g.dart';

/// A volunteer in the directory.
@JsonSerializable()
class DirectoryVolunteer {
  /// Create an instance.
  const DirectoryVolunteer(
      {required this.id,
      required this.orgId,
      required this.url,
      required this.name,
      required this.isSupportPerson,
      required this.account,
      required this.createdAt,
      required this.updatedAt,
      required this.creator,
      required this.updater,
      required this.roles,
      required this.relationships,
      required this.volunteerProperties});

  /// Create an instance from a JSON object.
  factory DirectoryVolunteer.fromJson(Map<String, dynamic> json) =>
      _$DirectoryVolunteerFromJson(json);

  /// The ID of this volunteer.
  final int id;

  /// The ID of the organisation this volunteer is part of.
  @JsonKey(name: 'org_id')
  final int orgId;

  /// The URL of the JSON representation of this volunteer.
  final String url;

  /// The name of this volunteer.
  final String name;

  /// Whether or not this person is a support volunteer.
  @JsonKey(name: 'is_support_person')
  final bool isSupportPerson;

  /// The account for this volunteer.
  final Account account;

  /// When this volunteer was created.
  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  /// When this volunteer was updated.
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  /// The creator of this volunteer.
  final Person creator;

  /// The person who updated this volunteer.
  final Person updater;

  /// The roles for this volunteer.
  final List<VolunteerRole> roles;

  /// The relationships for this volunteer.
  final List<VolunteerRelationship>? relationships;

  /// The properties for this volunteer.
  @JsonKey(name: 'volunteer_properties')
  final List<Map<String, VolunteerProperty>> volunteerProperties;

  /// The URL to the image of this volunteer.
  String get imageUrl => 'https://www.3r.org.uk/directory/$id/photos/thumb.jpg';

  /// Convert an instance to JSON.
  Map<String, dynamic> toJson() => _$DirectoryVolunteerToJson(this);
}
