/// Provides the [VolunteerRelationship] class.
import 'package:json_annotation/json_annotation.dart';

import 'directory_volunteer.dart';

part 'volunteer_relationship.g.dart';

/// The relationship between two [DirectoryVolunteer] instances.
@JsonSerializable()
class VolunteerRelationship {
  /// Create an instance.
  const VolunteerRelationship(
      {required this.id,
      required this.volunteer1Id,
      required this.volunteer2Id,
      required this.orgRelationshipId});

  /// Create an instance from a JSON object.
  factory VolunteerRelationship.fromJson(Map<String, dynamic> json) =>
      _$VolunteerRelationshipFromJson(json);

  /// The ID of this relationship.
  final int id;

  /// The ID of the first volunteer.
  @JsonKey(name: 'volunteer1_id')
  final int volunteer1Id;

  /// The ID of the second volunteer.
  @JsonKey(name: 'volunteer2_id')
  final int volunteer2Id;

  /// No idea what this value does.
  @JsonKey(name: 'org_relationship_id')
  final int orgRelationshipId;

  /// Convert an instance to JSON.
  Map<String, dynamic> toJson() => _$VolunteerRelationshipToJson(this);
}
